import 'dart:convert';

import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/models/myorders.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:flutter/material.dart';
import 'package:hesabe_flutter_kit/hesabe_flutter_kit.dart';
import 'package:provider/provider.dart';

class PaymentWebPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  Cart cart;

  Map<String, dynamic> address;

  dynamic shippingCost;

  String url = '';

  MyOrdersModel order;

  String uiText = ' ';

  String paymentMethod;
  Map<String, dynamic> body;

  PaymentWebPageModel({
    NotifierState state,
    this.api,
    this.auth,
    this.body,
    @required this.context,
    /* this.cart, this.address */
  }) : super(state: state) {
    address = body['shippingAddress'];
    cart = body['cart'];
    paymentMethod = body['paymentMethod'];

    shippingCost = body['shippingCost'];
  }

  initPayment({String promo}) async {
    setBusy();
    uiText = "Making your order";
    url = await payment(promo: promo);
    url != null && url != "" ? setIdle() : setError();
    print("URL : $url");
  }

  void pop(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1000));
    await Provider.of<CartService>(context, listen: false)
        .getCartsForUser(context);
    // UI.pushReplaceAll(context, Routes.home);
  }

  Future<String> payment({String promo}) async {
    var hesabePaymentHandler = HesabePaymentHandler(
        baseUrl: "https://api.hesabe.com",
        merchantCode: "13461319",
        secretKey: "v60zByOVZEnwaW0J3m0oYgXrNb1jp23L",
        ivKey: "ZEnwaW0J3m0oYgXr",
        accessCode: "e198f438-6c45-46e6-87ff-af36edbff537");

    // send request cart id , promocode

    Cart res = await Provider.of<CartService>(context, listen: false)
        .getCartsForUser(context, promo: promo);

    if (res != null) {
      cart = res;
    } else {
      setError();
      return null;
    }

    // Create a payment request if promocode != null
    var hesabePaymentRequest = HesabePaymentRequest(
        // amount: locator<CurrencyService>()
        //     .getPriceWithCurrncy(double.parse(cart.totalPrice) + shippingCost),
        amount: "${double.parse(cart.totalPrice) + shippingCost}",
        paymentType: body['payment'],
        version: "2.0",
        merchantCode: "13461319",
        // currency: locator<CurrencyService>().selectedCurrency.toUpperCase(),
        currency: "KWD",
        orderReferenceNumber: cart.id.toString(),

        // responseUrl: "Success",
        // failureUrl: "Failed"
        responseUrl: EndPoint.baseUrl +
            EndPoint.ORDER_PAYMENT +
            "${cart.id.toString()}?status=success&addressId=${address['id'].toString()}&paymentMethod=$paymentMethod",
        failureUrl: EndPoint.baseUrl +
            EndPoint.ORDER_PAYMENT +
            "${cart.id.toString()}?status=fail&addressId=${address['id'].toString()}&paymentMethod=$paymentMethod");

    String json = jsonEncode(hesabePaymentRequest);
    // var val;
    var paymentUrl = await hesabePaymentHandler.checkout(json);
    // .then((value) => {val = value, print(value + "Asdfasdfasdfasd")});

    return paymentUrl;
  }
}
