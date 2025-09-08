import 'package:beautydoz/core/services/preference/preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../base_notifier.dart';

class CurrencyService extends BaseNotifier {
  CurrencyService() {
    selectedCurrency = Preference.getString(PrefKeys.currncy) ?? 'kwd';
  }

  String selectedCurrency = 'kwd';
  List<String> currencies = ['bhd', 'omr', 'qar', 'sar', 'aed', 'kwd'];

  // getFlagIcon(context, 'bhd.png', 'bhd'),
  //                 getFlagIcon(context, 'omr.png', 'omr'),
  //                 getFlagIcon(context, 'qar.png', 'qar'),
  //                 getFlagIcon(context, 'sar.png', 'sar'),
  //                 getFlagIcon(context, 'aed.png', 'aed'),
  List<String> getOtherCurrencies() {
    List<String> currnciess = ['bhd', 'omr', 'qar', 'sar', 'aed', 'kwd'];
    currnciess.remove(selectedCurrency);
    return currnciess;
  }

  String get curr => selectedCurrency.toUpperCase();
  selectCurrency(String currncy) {
    selectedCurrency = currncy;
    Preference.setString(PrefKeys.currncy, currncy);

    notifyListeners();
  }

  Map<String, num> currncyExchange = {
    'bhd': 1.25,
    'omr': 1.28,
    'sar': 12.43,
    'qar': 12.07,
    'aed': 12.17,
    'kwd': 1
  };

  String getPriceWithCurrncy(num price) {
    return selectedCurrency == 'kwd' ||
            selectedCurrency == 'bhd' ||
            selectedCurrency == 'omr'
        ? (price * currncyExchange[selectedCurrency]).toStringAsFixed(3)
        : (price * currncyExchange[selectedCurrency]).toStringAsFixed(2);
  }
}
