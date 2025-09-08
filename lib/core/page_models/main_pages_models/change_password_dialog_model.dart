import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/utils/validator.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class ChangePasswordDialogModel extends BaseNotifier with Validator {
  final HttpApi api;
  final AuthenticationService auth;

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController retypeNewPassController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();

  ChangePasswordDialogModel({NotifierState state, this.api, this.auth})
      : super(state: state);

  final formKey = GlobalKey<FormState>();

  changePassowrd(BuildContext context, AppLocalizations locale) async {
    if (formKey.currentState.validate()) {
      if (newPasswordController.text == retypeNewPassController.text) {
        setBusy();

        Map<String, dynamic> param = {
          'email': auth.user.user.email,
          'oldPassword': currentPasswordController.text,
          'password': newPasswordController.text,
        };

        bool result = await auth.changePassowrd(context, param: param);
        if (result) {
          UI.toast(locale.get("Password changed successfuly") ??
              "Password changed successfuly");

          // clear text fields
          currentPasswordController.clear();
          retypeNewPassController.clear();
          newPasswordController.clear();

          Navigator.pop(context);

          setIdle();
        } else {
          setError();
        }
      } else {
        UI.toast(
            locale.get("Passwords doesn't match") ?? "Passwords doesn't match");
        setError();
      }
    }
  }
}
