import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';

mixin Validator {
  String phoneValidator(String value, BuildContext context) {
    if (value == null ||
        value.isEmpty ||
        int.tryParse(value) == null ||
        int.tryParse(value) < 8) {
      return AppLocalizations.of(context).get("invalid phone number") ??
          'invalid phone number';
    }
    return null;
  }

  String extensionValidator(String value, BuildContext context) {
    if (value == null || value.isEmpty || int.tryParse(value) == null) {
      return AppLocalizations.of(context).get("Invalid extension") ??
          "Invalid Extension";
    }
    return null;
  }

  String namelValidator(String value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).get('Name is empty') ??
          "Name is empty";
    } else if (value.length < 2) {
      return AppLocalizations.of(context).get('Too short name') ??
          'Too short name';
    }
    return null;
  }

  String emailValidator(String value, BuildContext context) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$";
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return AppLocalizations.of(context).get('Invalid email address') ??
          "Invalid email address";
    }
    return null;
  }

  String passwordValidator(String value, BuildContext context) {
    if (value.length < 8) {
      return AppLocalizations.of(context)
              .get('Password must be at least 8 characters.') ??
          "Password must be at least 8 characters.";
    }
    if (value.length > 16) {
      return AppLocalizations.of(context)
              .get('Password exceeded 16 characters.') ??
          "Password exceeded 16 characters.";
    }
    return null;
  }

  String userNameValidator(String value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return AppLocalizations.of(context).get('Username is empty') ??
          "Username is empty";
    } else if (value.length < 2) {
      return AppLocalizations.of(context).get('Too short name') ??
          "Too short name";
    }
    return null;
  }
}
