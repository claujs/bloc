import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:mega_flutter_base/utils/bloc_utils.dart';
import 'package:rxdart/rxdart.dart';

import '../models/address.dart';
import '../models/city.dart';
import '../models/country.dart';
import '../models/state.dart';
import 'address_form_repository.dart';

class AddressFormBloc extends BlocBase {
  final AddressFormRepository _repository;

  List<Country> countries = [];
  List<StateModel> states = [];
  List<City> cities = [];

  AddressFormBloc(this._repository);

  var validCEP = BehaviorSubject<Address>();
  Sink<Address> get validCEPIn => validCEP.sink;
  Stream<Address> get validCEPOut => validCEP.stream;

  Future<void> setCEP(Address address) async {
    validCEPIn.add(null);
    validCEPIn.add(address);
  }

  Future<void> loadCEP(String value) async {
    validCEPIn.add(null);

    if (value == null || value.trim().isEmpty || value.length < 9) {
      return;
    }

    await BlocUtils.load(
      action: (_) async {
        final response = await _repository.loadFromCep(value);
        cities = await _repository.loadCities(response.stateId);
        states = await _repository.loadStates();

        validCEPIn.add(response);
      },
      onError: (e, bloc) {
        validCEPIn.add(null);
        bloc.setMessage(e.message);
      },
    );
  }

  loadCity(String stateId) async {
    BlocUtils.load(action: (_) async {
      cities = await _repository.loadCities(stateId);
    });
  }

  loadCountries() async {
    BlocUtils.load(action: (_) async {
      countries = await _repository.loadCountries();
      states = await _repository.loadStates();
    });
  }

  @override
  void dispose() {
    validCEP.close();
    super.dispose();
  }
}
