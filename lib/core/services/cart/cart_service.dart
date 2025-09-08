import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartService extends BaseNotifier {
  final HttpApi api = locator<HttpApi>();

  CartService({NotifierState state}) : super(state: state);

  Cart cart;

  addToCart(BuildContext context, {Map<String, dynamic> body}) async {
    setBusy();
    try {
      final cart = await api.newCartRequest(context, body: body);
      if (cart != null) {
        this.cart = cart;
      } else {
        this.cart = null;
      }
    } catch (e) {
      setError();
      this.cart = null;
      // return null;
    }
    setIdle();
    return this.cart;
  }

  getCartsForUser(BuildContext context, {String promo}) async {
    final cart = await api.getCarts(context,
        userId: Provider.of<AuthenticationService>(context, listen: false)
            .user
            .user
            .id,
        promo: promo);

    if (cart != null) {
      this.cart = cart;
      setIdle();
      return this.cart;
    } else {
      setError();
      return null;
    }
  }

  removeFromCart(BuildContext context, {int userId, int lineId}) async {
    Cart cart2;
    try {
      cart2 =
          await api.removerFromCart(context, userId: userId, lineId: lineId);
    } catch (e) {
      setError();
    }
    if (cart2 != null) {
      cart = cart2;
      setIdle();
    } else {
      setError();
    }
    return cart;
  }
}
