import 'package:flutter/services.dart';

class AppInputFormatters {
  static final List<TextInputFormatter> personName = [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\s.'-]")),
    LengthLimitingTextInputFormatter(120),
  ];

  static final List<TextInputFormatter> companyName = [
    FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z0-9\s&.,'-]")),
    LengthLimitingTextInputFormatter(120),
  ];

  static final List<TextInputFormatter> email = [
    FilteringTextInputFormatter.deny(RegExp(r"\s")),
    LengthLimitingTextInputFormatter(150),
  ];

  static final List<TextInputFormatter> phone = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(15),
  ];

  static final List<TextInputFormatter> password = [
    LengthLimitingTextInputFormatter(64),
  ];
}
