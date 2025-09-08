import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/category/category_service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/ui/pages/secondary_pages/addresses_dialog_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/checkout.page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/option_dialog.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class ItemPageModel extends BaseNotifier {
  final AuthenticationService auth;
  final HttpApi api;
  final CategoryService categoryService;
  final CartService cartService;
  final FavouriteService favouriteService;
  final Lines cartItem;

  final int itemId;

  double rating;

  ItemPageModel(
      {this.api,
      this.auth,
      this.categoryService,
      this.favouriteService,
      this.itemId,
      this.cartService,
      this.cartItem});
  var form = FormArray([]);

  int availableQuantity;

  int selectedQuantity = 1;

  CategoryItems item;

  Cart cart;

  getItemById(BuildContext context) async {
    setBusy();
    item = await api.getItemById(context, itemId: itemId);

    if (item != null) {
      if (item.haveOptions) {
        // If navigating from cart to item then update item
        if (cartItem != null) {
          makeForm();
          updateItem();
          print("test");
        } else {
          // create option form for item
          makeForm();
        }
      }
      setIdle();
    } else {
      setError();
    }
  }

  void makeForm() {
    if (cartItem != null) {
      for (int i = 0; i < cartItem.options.length; i++) {
        var formGroup = new FormGroup({
          'optionText': new FormControl(
              value: cartItem.options[i].optionText,
              validators: [Validators.required]),
          'optionValue': new FormControl(
              value: cartItem.options[i].optionValue,
              validators: [Validators.required]),
          'itemOption': new FormControl(value: cartItem.options[i].itemOption),
        });
        form.insert(i, formGroup);
      }
    } else {
      for (int i = 0; i < item.options.length; i++) {
        var formGroup = new FormGroup({
          'optionText': new FormControl(validators: [Validators.required]),
          'optionValue': new FormControl(validators: [Validators.required]),
          'itemOption': new FormControl(value: item.options[i]),
        });
        form.insert(i, formGroup);
      }
    }
  }

  updateItem() {
    availableQuantity = cartItem.availableQty;
    selectedQuantity = cartItem.quantity;
  }

  Future showOptionsDialog(context) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {},
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
              opacity: anim1.value,
              child: OptionsDialog(form: form, item: item)),
        );
      },
    );
  }

  // bool clicked = false;
  addToCart2(BuildContext context) async {
    bool error = false;
    final locale = AppLocalizations.of(context);
    var availableQuantity = 0;
    // clicked = true;
    try {
      if (!auth.userLoged) {
        UI.pushReplaceAll(context, Routes.signIn);
        return;
      }

      // availableQuantity =
      //     await api.getAvailableQuantity(context, param: {'itemId': item.id});
      print('mDebug: ${item.options.length}');
      // if (availableQuantity > 0) {
      Map<String, dynamic> body = {
        "user": {"id": auth.user.user.id},
        "item": {"id": item.id},
        "quantity": selectedQuantity
      };

      if (item.haveOptions) {
        // for (int i = 0; i < item.options.length; i++) {
        //   print('mDebug: ${item.options.length}  i=$i');
        //   var formGroup = new FormGroup({
        //     'optionText': new FormControl(validators: [Validators.required]),
        //     'optionValue': new FormControl(validators: [Validators.required]),
        //     'itemOption': new FormControl(value: item.options[i]),
        //   }, validators: [
        //     Validators.required
        //   ]);
        //   form.insert(i, formGroup);
        // }

        await showOptionsDialog(context).then((val) async {
          if (val is FormArray && val != null) {
            body['options'] = form.value;
            form = FormArray([]);
          } else {
            error = true;
            form = FormArray([]);
            return;
          }
        });

        // if (!body.containsKey("options") || body["options"] == null) {
        //   // clicked = false;
        //   setState();
        //   return;
        // }
      }

      print(body);

      try {
        final cart = await cartService.addToCart(context, body: body);
        if (cart != null && !error) {
          UI.toast(locale.get("Item added to cart successfully"));
          Navigator.pop(context);
        }
        //  else {
        //   UI.toast(locale.get("Error occured"));
        // }
      } catch (e) {
        UI.toast(locale.get("Error") ?? "Error");
      }
      // } else {
      //   UI.toast(locale.get("out of quantity"));
      // }
    } catch (e) {
      setIdle();
      UI.toast(locale.get("Error") ?? "Error");
      return;
    }
    setState();
  }

  buyNow(BuildContext context) async {
    bool error = false;
    final locale = AppLocalizations.of(context);
    if (!auth.userLoged) {
      UI.pushReplaceAll(context, Routes.signIn);
      return;
    }

    // clicked = true;
    try {
      // availableQuantity =
      //     await api.getAvailableQuantity(context, param: {'itemId': item.id});
      print('mDebug: ${item.options.length}');
      // if (availableQuantity > 0) {
      Map<String, dynamic> body = {
        "user": {"id": auth.user.user.id},
        "item": {"id": item.id},
        "quantity": selectedQuantity
      };

      if (item.haveOptions) {
        await showOptionsDialog(context).then((val) async {
          if (val is FormArray && val != null) {
            body['options'] = form.value;
            form = FormArray([]);
          } else {
            error = true;
            form = FormArray([]);
            return;
          }
        });
      }

      print(body);

      try {
        final cart = await cartService.addToCart(context, body: body);
        if (cart != null && !error) {
          UI.push(
              context,
              Checkout(
                cart: cart,
              ));
        }
        //  else {
        //   UI.toast(locale.get("Error occured"));
        // }
      } catch (e) {
        UI.toast(locale.get("Error") ?? "Error");
      }
      // } else {
      //   UI.toast(locale.get("out of quantity"));
      // }
    } catch (e) {
      setIdle();
      UI.toast(locale.get("Error") ?? "Error");
      return;
    }
    setState();
  }

  addToCart(BuildContext context) async {
    final locale = AppLocalizations.of(context);
    if (auth.userLoged) {
      if (selectedQuantity > 0) {
        Map<String, dynamic> body = {
          "user": {"id": auth.user.user.id},
          "item": {"id": itemId},
          "options": form.value,
          "quantity": selectedQuantity
        };
        print(body);
        setBusy();
        try {
          cart = await cartService.addToCart(context, body: body);
        } catch (e) {
          setError();
          UI.toast(locale.get("Error") ?? "Error");
        }
        if (cart != null) {
          UI.toast(locale.get("Item added to cart successfully") ??
              "Item added to cart successfully");
          setIdle();
          Navigator.pop(context);
        } else {
          UI.toast(locale.get("Error in adding Item to cart") ??
              "Error in adding Item to cart ");
          setError();
        }
      } else {
        UI.toast(locale.get("Something is empty") ?? "Something is empty");
      }
    } else {
      UI.push(context, Routes.signInUp);
    }
  }

  void addToFavourite(BuildContext context, int itemId) async {
    bool res;
    if (!auth.userLoged) {
      UI.push(context, Routes.signIn);
    } else {
      setBusy();
      try {
        res = await favouriteService.addToFavourites(context, itemId: itemId);
      } catch (e) {
        setError();
      }

      if (res) {
        setIdle();
      } else {
        setError();
      }
    }
  }

  removerFromFavourite(BuildContext context, {int lineId}) async {
    bool res;
    setBusy();
    try {
      res =
          await favouriteService.removeFromFavourites(context, lineId: lineId);
    } catch (e) {
      setError();
    }

    if (res) {
      favouriteService.favourites.lines
          .removeWhere((element) => element.id == lineId);
      setIdle();
    } else {
      setError();
    }
  }

  gotoSignInUpPage(BuildContext context) {
    UI.push(context, Routes.signInUp);
  }
}
