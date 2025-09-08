import 'package:beautydoz/core/models/countries.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/address.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/models/myorders.dart';
import 'package:beautydoz/core/models/promocode.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/location/locationService.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/secondary_pages/create_new_address_dialog.dart';
import 'package:beautydoz/ui/pages/secondary_pages/payement_card_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class PaymentMethodPageModel extends BaseNotifier {
  final AuthenticationService auth;
  final HttpApi api;
  PromoCode promoCode;
  FormGroup form;

  TextEditingController promoController = TextEditingController();
  PaymentMethodPageModel({this.auth, this.api}) {
    form = FormGroup({
      'promoCode': FormControl<String>(),
      'shippingAddress':
          FormControl<Address>(validators: [Validators.required]),
      'paymentMethod': FormControl<int>(validators: [Validators.required]),
    });
  }

  List<Address> addresses;

  getUserAddress(BuildContext context) async {
    addresses =
        await api.getUserAddress(userId: auth.user.user.id, context: context);
    addresses == null ? setError() : setIdle();
  }

  MyOrdersModel order;

  List<String> paymentMethods =
      locator<CurrencyService>().selectedCurrency == 'kwd'
          ? ['KNET', 'VISA / Master Card', 'Cash on delivery']
          : ['KNET', 'VISA / Master Card'];

  List<int> paymentValues = [1, 2, 3];
  int paymentRadVal = 1;

  void confirmDialog(BuildContext context, Cart cart, Address address) async {
    final locale = AppLocalizations.of(context);
    Map<String, dynamic> body = {
      'cart': {
        'id': cart.id,
      },
      'totalPrice': double.parse(cart.totalPrice),
      'shippingAddress': form.control("shippingAddress").value,
      // 'promoCode': promoController.text,
      'promoCode': form.control("promoCode").value,
      'paymentMethod': 'cashOnDelievery'
    };
    print(body);

    setBusy();

    order = await api.payment(context, body: body);
    if (order != null) {
      UI.push(context, ConfirmDialog());
    } else {
      setError();
      UI.toast(locale.get("Error") ?? "Error");
    }
  }

  void gotoPaymentWebView(
      BuildContext context, Cart cart, Address address, int paymentMethod,
      {dynamic shippingCost, String promo}) {
    String paymentMethodText;
    int payment = 1;
    switch (paymentMethod) {
      case 1:
        paymentMethodText = "KNET";
        payment = 1;
        break;
      case 2:
        paymentMethodText = "creditCard";
        payment = 2;
        break;
      case 3:
        paymentMethodText = "creditCard";
        payment = 2;
        break;
      default:
        paymentMethodText = "cashOnDelievery";
    }
    Map<String, dynamic> body = {
      'cart': cart,
      'shippingAddress': address.toJson(),
      'paymentMethod': paymentMethodText,
      'shippingCost': shippingCost,
      'promo': promo,
      'payment': payment.toString(),
      // 'promoCode': promoController.text,
      'promoCode': promoController.text,
    };

    UI.push(context, Routes.paymentWebView(body: body));
  }

  double total;
  num discount = 0;

  bool applieng = false;
  applyPromoCode(
      context, AppLocalizations locale, String code, Cart cart) async {
    applieng = true;
    setState();
    if (code != null && code.isNotEmpty) {
      PromoCode promoCode = await api.getPromoCode(code).catchError((e) {
        Logger().e(e);
        applieng = false;
        setState();
      });
      FocusScope.of(context).unfocus();
      num totalPrice = num.tryParse(cart.totalPrice);
      if (promoCode != null &&
          promoCode?.id != null &&
          (promoCode.expireDate == null ||
              !promoCode.expireDate.isBefore(DateTime.now()))) {
        if (promoCode.categories != null && promoCode.categories.isNotEmpty) {
          if (!cart.lines.any((line) => line.item.categories.any(
              (itemCategory) => promoCode.categories.any(
                  (promoCategory) => promoCategory.id == itemCategory.id)))) {
            UI.toast(locale.get('this code only for specified categories'));
          } else {
            num totalCategoryItemsPrice;

            totalCategoryItemsPrice = cart.lines.fold(0, (prev, line) {
              num current = 0;

              if (line.item.categories.any((itemCategory) =>
                  promoCode.categories.any((promoCategory) =>
                      itemCategory.id == promoCategory.id))) {
                current += (num.tryParse(line.price));
              }
              return prev + current;
            });

            if (promoCode.discountPercent == 0 && promoCode.discountValue > 0) {
              if (promoCode.discountValue <= totalCategoryItemsPrice) {
                discount = promoCode.discountValue;
              } else {
                discount = totalCategoryItemsPrice;
              }
              print('mDebug: new value  $discount');
            } else {
              discount =
                  (totalCategoryItemsPrice * (promoCode.discountPercent / 100));
              print('mDebug: new percent $discount');
            }

            this.promoCode = promoCode;
            UI.toast(
              locale.get('Promo code applied'),
            );
          }
        } else {
          this.promoCode = promoCode;

          if (promoCode.discountPercent == 0 && promoCode.discountValue > 0) {
            if (promoCode.discountValue <= totalPrice) {
              discount = promoCode.discountValue;
            } else {
              discount = totalPrice;
            }
            print('mDebug: new value  $discount');
          } else {
            discount = (totalPrice * (promoCode.discountPercent / 100));
            print('mDebug: new percent $discount');
          }

          UI.toast(
            locale.get('Promo code applied'),
          );
        }
      }
    } else {
      toast(locale.get('Please Enter a correct promo code'),
          duration: Duration(seconds: 3), context: context);
    }
    applieng = false;
    setState();
    setIdle();
  }

  List<Countries> countries;
  loadCountries(BuildContext context) async {
    setBusy();
    countries = await api.getCountries(context);
    setIdle();
  }

  void addNewAddress(BuildContext context) {
    final locale = AppLocalizations.of(context);

    showDialog(
        context: context,
        builder: (context) => AddressDialogPage(
              context,
              countries: countries,
              update: false,
            )).then((value) async {
      await getUserAddress(context);
      setState();
    });
  }
}
