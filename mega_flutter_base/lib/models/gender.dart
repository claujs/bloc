import 'package:flutter_modular/flutter_modular.dart';
import 'package:megaleios_flutter_localization/megaleios_flutter_localization.dart';

enum Gender { male, female, other }

extension GenderExtension on Gender {
  String get name {
    final localization =
        MegaleiosLocalizations.of(Modular.navigatorKey.currentContext);
    switch (this) {
      case Gender.male:
        return localization.translate('gender_male');
      case Gender.female:
        return localization.translate('gender_female');
      case Gender.other:
        return localization.translate('gender_other');
      default:
        return '';
    }
  }

  String get value {
    switch (this) {
      case Gender.male:
        return 'M';
      case Gender.female:
        return 'F';
      case Gender.other:
        return 'O';
      default:
        return '';
    }
  }
}

class GenderUtils {
  static Gender fromIndex(int index) {
    switch (index) {
      case 0:
        return Gender.male;
      case 1:
        return Gender.female;
      case 2:
        return Gender.other;
      default:
        return Gender.other;
    }
  }

  static Gender fromValue(String index) {
    switch (index) {
      case 'M':
        return Gender.male;
      case 'F':
        return Gender.female;
      case 'O':
        return Gender.other;
      default:
        return Gender.other;
    }
  }
}
