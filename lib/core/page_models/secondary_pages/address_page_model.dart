import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/address.dart';
import 'package:beautydoz/core/models/cities.dart';
import 'package:beautydoz/core/models/countries.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class AdressesPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;

  List<Address> addresses;

  AdressesPageModel(
      {@required BuildContext context,
      NotifierState state,
      this.api,
      this.auth})
      : super(state: state) {
    loadCountries(context);
    getUserAddress();
  }

  List<Countries> countries;
  List<Cities> cities;

  Countries countrySelected;
  Cities citySelected;

  loadCountries(BuildContext context) async {
    setBusy();
    countries = await api.getCountries(context);
    setIdle();
  }

  getUserAddress() async {
    setBusy();
    addresses = await api.getUserAddress(userId: auth.user.user.id);
    addresses == null ? setError() : setIdle();
  }

  deleteAddress(BuildContext context, Address address) async {
    final locale = AppLocalizations.of(context);
    setBusy();
    bool res;
    try {
      res = await api.deleteAddress(context, addressId: address.id);
    } catch (e) {
      UI.toast(locale.get("Error") ?? "Error");
      setError();
    }
    if (res == true) {
      UI.toast(locale.get("Deleted Successfully") ?? "Deleted Successfully");
      addresses.remove(address);
      setIdle();
    } else {
      UI.toast("Error");
      setError();
    }
  }
}
