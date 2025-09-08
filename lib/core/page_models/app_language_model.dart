import 'package:flutter/material.dart';

import '../services/preference/preference.dart';

class AppLanguageModel extends ChangeNotifier {
  Locale _appLocale = Locale('en');

  Locale get appLocal => _appLocale ?? Locale("en");
  fetchLocale() async {
    if (Preference.getString(PrefKeys.languageCode) == null) {
      _appLocale = Locale('en');
    } else {
      _appLocale = Locale(Preference.getString(PrefKeys.languageCode));
    }
    notifyListeners();

    return null;
  }

  void changeLanguage(Locale type) async {

    // if (_appLocale == type) {
    //   return;
    // }
    
    if (type == Locale("ar")) {
      _appLocale = Locale("ar");
      await Preference.setString(PrefKeys.languageCode, 'ar');
      await Preference.setString('countryCode', '');
    } else if (type == Locale("en")) {
      _appLocale = Locale("en");
      await Preference.setString(PrefKeys.languageCode, 'en');
    }
    notifyListeners();
  }
}
