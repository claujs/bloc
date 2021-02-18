import 'package:flutter/material.dart';
import 'package:mega_flutter_base/utils/formats.dart';
import 'package:mega_flutter_base/utils/text_field_utils.dart';
import 'package:mega_flutter_features/address_form/address_form_bloc.dart';
import 'package:mega_flutter_features/modal_bottom_sheets/modal_bottom_sheets.dart';
import 'package:mega_flutter_features/models/address.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

class AddressForm extends StatefulWidget {
  final AddressFormBloc bloc;
  final Address address;
  final bool isEdit;
  final Function(Address) onUpdated;

  const AddressForm({
    @required this.bloc,
    @required this.onUpdated,
    this.address,
    this.isEdit = false,
  })  : assert(bloc != null),
        assert(onUpdated != null);

  @override
  _AddressFormState createState() => _AddressFormState();
}

class _AddressFormState extends State<AddressForm> {
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _complementController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  AddressFormBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;

    if (widget.address?.zipCode != null) {
      bloc.setCEP(widget.address);
    }

    bloc.validCEPOut.listen((address) {
      if (address != null) {
        _cepController.text = address.zipCode;
        _streetController.text = address.streetAddress;
        _numberController.text = address.number;
        _complementController.text = address.complement;
        _neighborhoodController.text = address.neighborhood;
        _stateController.text = address.stateName;
        _cityController.text = address.cityName;
        widget.onUpdated(address);
      } else {
        _streetController.text = '';
        _numberController.text = '';
        _complementController.text = '';
        _neighborhoodController.text = '';
        _stateController.text = '';
        _cityController.text = '';
        widget.onUpdated(Address());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MegaleiosLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFieldUtils.buildField(
          context,
          textInputAction: TextInputAction.search,
          controller: _cepController,
          inputFormats: [Formats.cepMaskFormatter],
          label: localizations.translate('cep'),
          required: true,
          minLength: 9,
          keyboardType: TextInputType.number,
          validator: (_) {
            if (bloc.validCEP.value == null)
              return localizations.translate(
                'error_field_invalid',
                params: [localizations.translate('cep')],
              );
            return null;
          },
          onSaved: (value) {
            bloc.validCEP.value.zipCode = value;
            widget.onUpdated(bloc.validCEP.value);
          },
          onChanged: bloc.loadCEP,
          onFieldSubmitted: bloc.loadCEP,
        ),
        StreamBuilder<Address>(
          initialData: widget.address,
          stream: bloc.validCEPOut,
          builder: (_, snapshot) {
            if (snapshot.hasData) {
              return Visibility(
                visible: snapshot.data.zipCode != null,
                child: Column(
                  children: <Widget>[
                    TextFieldUtils.buildField(
                      context,
                      controller: _streetController,
                      label: localizations.translate('address'),
                      required: true,
                      minLength: 3,
                      onSaved: (value) {
                        bloc.validCEP.value.streetAddress = value;
                        widget.onUpdated(bloc.validCEP.value);
                      },
                    ),
                    TextFieldUtils.buildField(
                      context,
                      controller: _numberController,
                      inputFormats: [Formats.numberStreetFormatter],
                      minLength: 1,
                      label: localizations.translate('number'),
                      required: true,
                      keyboardType: TextInputType.number,
                      onSaved: (value) {
                        bloc.validCEP.value.number = value;
                        widget.onUpdated(bloc.validCEP.value);
                      },
                    ),
                    TextFieldUtils.buildField(
                      context,
                      controller: _complementController,
                      label: localizations.translate('complement'),
                      onSaved: (value) {
                        bloc.validCEP.value.complement = value;
                        widget.onUpdated(bloc.validCEP.value);
                      },
                    ),
                    TextFieldUtils.buildField(
                      context,
                      controller: _neighborhoodController,
                      label: localizations.translate('neighborhood'),
                      required: true,
                      minLength: 3,
                      onSaved: (value) {
                        bloc.validCEP.value.neighborhood = value;
                        widget.onUpdated(bloc.validCEP.value);
                      },
                    ),
                    TextFieldUtils.buildSelectableField(
                      context,
                      controller: _stateController,
                      label: localizations.translate('state'),
                      required: true,
                      onTap: () {
                        FocusScope.of(context).requestFocus(FocusNode());
                        MegaModals(context).showModalStates(
                          bloc.states,
                          title: localizations.translate('state'),
                          hint: localizations.translate('state_hint'),
                          onTap: (value) {
                            setState(() {
                              _stateController.text = value.name;
                              bloc.validCEP.value.stateName = value.name;
                              bloc.validCEP.value.stateId = value.valueString;

                              bloc.loadCity(value.valueString);
                              _cityController.text = '';
                              bloc.validCEP.value.cityName = '';
                              widget.onUpdated(bloc.validCEP.value);
                            });
                          },
                        );
                      },
                    ),
                    Visibility(
                      visible: _stateController.text.isNotEmpty,
                      child: Column(
                        children: <Widget>[
                          TextFieldUtils.buildSelectableField(
                            context,
                            controller: _cityController,
                            label: localizations.translate('city'),
                            required: true,
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              MegaModals(context).showModalCities(
                                bloc.cities,
                                title: localizations.translate('city'),
                                hint: localizations.translate('city_hint'),
                                onTap: (value) {
                                  _cityController.text = value.name;
                                  bloc.validCEP.value.cityName = value.name;
                                  bloc.validCEP.value.cityId =
                                      value.valueString;
                                  widget.onUpdated(bloc.validCEP.value);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ],
    );
  }
}
