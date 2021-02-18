import 'package:cpfcnpj/cpfcnpj.dart';

abstract class MegaValidators {
  static bool isCpfOrCnpj(String text) {
    return CPF.isValid(text) || CNPJ.isValid(text);
  }

  static bool isCpf(String text) {
    return CPF.isValid(text);
  }
}
