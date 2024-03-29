import 'package:flutter/material.dart';
import 'package:mega_flutter_base/models/gender.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

class RadioButtonsGroup extends StatelessWidget {
  final int groupValue;
  final String title;
  final TextStyle titleStyle;
  final bool canRow;
  final List<String> labels;
  final List<String> hints;
  final Function(int) onChanged;

  const RadioButtonsGroup({
    this.groupValue,
    this.canRow = true,
    this.title,
    this.titleStyle,
    this.labels,
    this.hints,
    this.onChanged,
  }) : assert(hints == null || hints.length == labels.length);

  @override
  Widget build(BuildContext context) {
    if (labels.length <= 2 && canRow && hints == null) {
      return _buildRow(context);
    }
    return _buildColumn(context);
  }

  _buildRow(BuildContext context) {
    final List<Widget> children = [];

    final theme = Theme.of(context).textTheme;
    if (title != null)
      children.add(Text(
        title.toUpperCase(),
        textAlign: TextAlign.start,
        style: titleStyle ?? theme.headline4,
      ));

    final List<Widget> rowChildren = [];
    labels.asMap().forEach(
      (index, label) {
        rowChildren.add(
            Radio(value: index, groupValue: groupValue, onChanged: onChanged));
        rowChildren.add(
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: Text(
                label,
                maxLines: 1,
                style: theme.bodyText2,
              ),
            ),
          ),
        );
      },
    );
    children.add(Row(
      children: rowChildren,
    ));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  _buildColumn(BuildContext context) {
    final List<Widget> children = [];
    final theme = Theme.of(context).textTheme;

    if (title != null)
      children.add(Text(
        title.toUpperCase(),
        textAlign: TextAlign.start,
        style: theme.headline4,
      ));

    labels.asMap().forEach((index, label) {
      children.add(
        Row(
          children: <Widget>[
            Radio(value: index, groupValue: groupValue, onChanged: onChanged),
            Expanded(
              child: GestureDetector(
                onTap: () => onChanged(index),
                child: Text(
                  label,
                  style: theme.bodyText2,
                ),
              ),
            ),
            Visibility(
              visible: hints != null,
              child: GestureDetector(
                onTap: () => onChanged(index),
                child: Text(
                  hints != null ? hints[index] : '',
                  style: theme.bodyText1.copyWith(
                    color: Theme.of(context).accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  static Widget gender(
    BuildContext context, {
    Gender initial,
    @required Function(Gender) onChanged,
  }) {
    final localizations = MegaleiosLocalizations.of(context);

    Gender gender = initial;
    return StatefulBuilder(
      builder: (_, setState) {
        return RadioButtonsGroup(
          title: localizations.translate('gender'),
          labels: [
            Gender.male.name,
            Gender.female.name,
            Gender.other.name,
          ],
          groupValue: gender?.index,
          onChanged: (value) {
            setState(() {
              gender = GenderUtils.fromIndex(value);
            });
            onChanged(gender);
          },
        );
      },
    );
  }
}
