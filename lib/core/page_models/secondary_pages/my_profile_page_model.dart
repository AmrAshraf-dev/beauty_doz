import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/countries.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class MyProfilePageModel extends BaseNotifier {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final AuthenticationService auth;
  HttpApi api;

  List<Countries> countries;

  bool fetchingExtension = false;

  MyProfilePageModel({this.auth}) {
    nameController.text = auth.user?.user?.name ?? " ";
    // selectedExtension = int.tryParse(auth.user.user?.mobile?.extintion ?? 965);
    selectedExtension = auth.user.user?.mobile?.extintion ?? "965";
    phoneController.text = auth.user.user?.mobile?.number ?? " ";
    passwordController.text = auth.user.user.password;
    emailController.text = auth.user?.user?.email ?? " ";
  }

  String selectedExtension;

  getExtensions(BuildContext context) async {
    api = Provider.of<Api>(context, listen: false);
    final locale = AppLocalizations.of(context);
    fetchingExtension = true;
    setState();

    countries = await api.getCountries(context);
    if (countries == null) {
      UI.toast(locale.get("Error") ?? "Error");
    }
    fetchingExtension = false;
    setState();
  }

  updateUserInfo(
    BuildContext context,
  ) async {
    final locale = AppLocalizations.of(context);
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty) {
      Map<String, dynamic> body = {
        "name": nameController.text,
        "email": emailController.text,
        "mobile": {
          "extintion": selectedExtension.toString(),
          "number": phoneController.text
        }
      };

      bool res;
      setBusy();
      res = await auth.updateUserInfo(context, body: body);
      if (res) {
        UI.toast(locale.get("Information updated successfully") ??
            "Information updated successfully");
        // selectedExtension = int.tryParse(auth.user.user.mobile.extintion);
        selectedExtension = auth.user.user.mobile.extintion;
        setIdle();
      } else {
        UI.toast(locale.get("Error") ?? "Error");
        setError();
      }
    } else {
      UI.toast(locale.get("Something is empty") ?? "Somthing is empty");
    }
  }
}
