import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/utils/validator.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class ResetPasswordPageModel extends BaseNotifier with Validator {
  final HttpApi api;
  final AuthenticationService auth;

  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  ResetPasswordPageModel({NotifierState state, this.api, this.auth})
      : super(state: state);

  gotoResetForm(context) async {
    final locale = AppLocalizations.of(context);
    final formValid = formKey.currentState.validate();
    var res;
    if (formValid) {
      setBusy();
      try {
        res = await auth.sendResetEmail(context, email: emailController.text);
      } catch (e) {
        res = false;
      }
      if (res == true) {
        UI.push(context, Routes.resetForm(email: emailController.text),
            replace: true);
      } else {
        UI.toast(locale.get("User not found") ?? "User not found");
        setIdle();
      }
    }
  }
}
