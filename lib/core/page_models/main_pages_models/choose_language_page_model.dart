import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/page_models/app_language_model.dart';
import '../../../ui/routes/routes.dart';
import '../../services/preference/preference.dart';

class ChooseLanguagePageModel extends BaseNotifier {
  AppLanguageModel languageModel;

  int checkedButton = 1;

  ChooseLanguagePageModel({this.languageModel});

  switchLang(BuildContext context, String locale) {
    languageModel.changeLanguage(Locale(locale));
    Preference.setBool(PrefKeys.firstLaunch, false);
    UI.push(context, Routes.onBorading);
  }

  // nextOnPress(BuildContext context) {
  //   Preference.setBool(PrefKeys.firstLaunch, false);
  //   UI.push(context, Routes.home);
  // }
}
