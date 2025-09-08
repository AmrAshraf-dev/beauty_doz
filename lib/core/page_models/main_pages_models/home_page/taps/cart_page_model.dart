import 'package:beautydoz/core/models/wrapping-model.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/category/category_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class CartPageModel extends BaseNotifier {
  final AuthenticationService auth;
  final HttpApi api;
  final CategoryService categoryService;
  final CartService cartService;

  Cart cart;

  FormArray form;

  FormGroup wrappingForm;
  Wrapping selectedWrapping;
  CartPageModel(
      {this.auth,
      this.api,
      this.categoryService,
      this.cartService,
      NotifierState state})
      : super(state: state) {
    form = FormArray([]);
    wrappingForm = new FormGroup({
      'from': FormControl(
          value: auth?.user?.user?.name, validators: [Validators.required]),
      'to': FormControl(value: '', validators: []),
      'message': FormControl(value: '', validators: []),
      'wrapping': FormControl(validators: [Validators.required]),
      'qty': FormControl(
          value: 1, validators: [Validators.required, Validators.min(1)]),
    });
  }

  getCartsforUser(BuildContext context) async {
    final locale = AppLocalizations.of(context);
    setBusy();
    try {
      cart = await cartService.getCartsForUser(context);
    } catch (e) {
      print(e);
      setError();
      UI.toast(locale.get("Error") ?? "Error");
    }
    cart != null ? setIdle() : setError();
  }

  updateCart(BuildContext context, int index, Lines item) async {
    final locale = AppLocalizations.of(context);
    if (cart.lines[index].options != null)
      form.updateValue(cart.lines[index].options);
    Map<String, dynamic> body = {
      "user": {"id": auth.user.user.id},
      "item": {"id": item.item.id},
      "options": form.value,
      "quantity": item.quantity
    };
    print(body);

    try {
      cart = await cartService.addToCart(context, body: body);
    } catch (e) {
      UI.toast(locale.get("Error") ?? "Error");
    }
    if (cart != null && !cartService.hasError) {
      UI.toast(locale.get("Item Updated successfully") ??
          "Item Updated successfully");
    } else {
      UI.toast(locale.get("Error in updating Item cart ") ??
          "Error in updating Item cart ");
    }
    setState();
  }

  openItem(BuildContext context, {CategoryItems item, Lines cartItem}) {
    UI.push(context, Routes.item(item: item, cartItem: cartItem));
  }

  void remove(BuildContext context, AppLocalizations locale,
      {int lineId, int userid}) async {
    // setBusy();
    try {
      cart = await cartService.removeFromCart(context,
          userId: auth.user.user.id, lineId: lineId);
      setState();
    } catch (e) {
      setError();
      UI.toast(locale.get("Error") ?? "Error");
    }
    if (cart != null && !cartService.hasError) {
      setState();
    } else {
      UI.toast(locale.get("Error in updating Item cart ") ??
          "Error in updating Item cart ");
      setState();
      setError();
    }
  }
}
