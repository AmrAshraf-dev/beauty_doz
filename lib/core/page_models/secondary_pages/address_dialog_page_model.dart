import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/address.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class AddressDialogPageModel extends BaseNotifier {
  int radvalue;

  final AuthenticationService auth;
  final HttpApi api;

  final BuildContext context;

  AddressDialogPageModel({this.context, this.auth, this.api}) {
    setState(state: NotifierState.busy, notifyListener: false);
  }

  List<Address> addresses;

  getUserAddress(BuildContext context) async {
    addresses =
        await api.getUserAddress(userId: auth.user.user.id, context: context);
    addresses == null ? setError() : setIdle();
  }

  gotoPayment(BuildContext context, int addressId, Cart cart) {
    UI.push(
        context,
        Routes.paymentMethod(
            address: addresses.firstWhere((o) => o.id == addressId),
            cart: cart));
  }

  void gotoAddresses(BuildContext context) async {
    await UI.push(context, Routes.addresses);
    getUserAddress(context);
  }
}
