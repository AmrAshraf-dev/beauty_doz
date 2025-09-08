import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class ProfilePageModel extends BaseNotifier {
  final AuthenticationService auth;

  ProfilePageModel({this.auth});

  orderRoute(BuildContext context) {
    UI.push(context, Routes.myOrders);
  }

  aboutRoute(context) {
    UI.push(context, Routes.about);
  }

  languageRoute(BuildContext context) {
    UI.push(context, Routes.languages);
  }

  addressRoute(context) {
    UI.push(context, Routes.addresses);
  }

  profileRoute(BuildContext context) {
    UI.push(context, Routes.myProfile);
  }

  contactRoute(BuildContext context) {
    UI.push(context, Routes.contact);
  }

  rate(BuildContext context) {
    UI.push(context, Routes.rateUs);
  }

  void signOut(BuildContext context) async {
    await auth.signOut;
    Provider.of<FavouriteService>(context, listen: false)
        ?.favourites
        ?.lines
        ?.clear();
    Provider.of<CartService>(context, listen: false).cart = null;
    UI.pushReplaceAll(context, Routes.splash);
  }

  favouriteRoute(BuildContext context) {
    UI.push(context, Routes.favorites);
  }
}
