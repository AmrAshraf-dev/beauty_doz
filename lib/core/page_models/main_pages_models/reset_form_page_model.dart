import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/utils/validator.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class ResetFormPageModel extends BaseNotifier with Validator {
  final HttpApi api;
  final AuthenticationService auth;
  final String email;

  final formKey = GlobalKey<FormState>();

  TextEditingController newPasswordControlelr = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController retypeNewPasswordControlelr = TextEditingController();

  ResetFormPageModel({NotifierState state, this.api, this.auth, this.email})
      : super(state: state);

  void resetPassword(BuildContext context) async {
    final locale = AppLocalizations.of(context);
    final formValid = formKey.currentState.validate();
    Map<String, dynamic> body;
    bool res;
    if (formValid) {
      setBusy();
      if (newPasswordControlelr.text == retypeNewPasswordControlelr.text) {
        body = {
          'code': codeController.text,
          'email': email,
          'password': newPasswordControlelr.text
        };
        res = await auth.resetPassword(context, body: body);
        if (res == true) {
          UI.pushReplaceAll(context, Routes.signIn);
        } else {
          UI.toast(locale.get("Error") ?? "Error");
          setIdle();
        }
      } else {
        UI.toast(locale.get("Password is not the same"));
        setIdle();
      }
    }
  }
}
