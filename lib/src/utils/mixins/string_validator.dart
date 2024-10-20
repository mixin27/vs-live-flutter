import 'package:flutter/services.dart';

/// This file contains some helper functions used for string validation.
abstract class StringValidator {
  bool isValid(String value);
}

class RegexValidator implements StringValidator {
  const RegexValidator({required this.regexSource});

  final String regexSource;

  @override
  bool isValid(String value) {
    try {
      // https://regex101.com/
      final RegExp regExp = RegExp(regexSource);
      final Iterable<Match> matches = regExp.allMatches(value);

      for (var match in matches) {
        if (match.start == 0 && match.end == value.length) {
          return true;
        }
      }

      return false;
    } catch (e) {
      // Invalid regex
      assert(false, e.toString());
      return true;
    }
  }
}

class ValidatorInputFormatter implements TextInputFormatter {
  ValidatorInputFormatter({required this.editingValidator});

  final StringValidator editingValidator;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final bool oldValueValid = editingValidator.isValid(oldValue.text);
    final bool newValueValid = editingValidator.isValid(newValue.text);

    if (oldValueValid && !newValueValid) {
      return oldValue;
    }
    return newValue;
  }
}

class EmailEditingRegexValidator extends RegexValidator {
  EmailEditingRegexValidator() : super(regexSource: '^(|\\S)+\$');
}

class EmailSubmitRegexValidator extends RegexValidator {
  EmailSubmitRegexValidator() : super(regexSource: '^\\S+@\\S+\\.\\S+\$');
}

/// <a href="https://stackoverflow.com/a/55552272">https://stackoverflow.com/a/55552272</a>
///
/// * `^` Start of string
/// * `(?:[+0]9)?` Optionally match a + or 0 followed by 9
/// * `[0-9]{10}` Match 10 digits
/// * `$` End of string
class PhoneSubmitRegexValidator extends RegexValidator {
  PhoneSubmitRegexValidator() : super(regexSource: '^(?:[+0]9)?[0-9]{10}\$');
}

class NonEmptyStringValidator extends StringValidator {
  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }
}

class IdenticalStringValidator extends StringValidator {
  IdenticalStringValidator(this.secondValue);

  final String secondValue;

  @override
  bool isValid(String value) {
    return value.isNotEmpty;
  }

  bool compare(String value) => secondValue == value;
}

class MinLengthStringValidator extends StringValidator {
  MinLengthStringValidator(this.minLength);
  final int minLength;

  @override
  bool isValid(String value) {
    return value.length >= minLength;
  }
}
