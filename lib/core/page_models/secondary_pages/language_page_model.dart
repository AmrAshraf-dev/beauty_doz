import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/app_language_model.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:flutter/material.dart';

class LanguagesPageModel extends BaseNotifier {
  final AppLanguageModel languageModel;

  final AuthenticationService auth;
  LanguagesPageModel({this.auth, this.languageModel});

  retrieveSelectedLanguage() {
    return languageModel.appLocal.languageCode;
  }

  modifySelectedLanguage(BuildContext context, String locale) {
    languageModel.changeLanguage(Locale(locale));
  }
}
