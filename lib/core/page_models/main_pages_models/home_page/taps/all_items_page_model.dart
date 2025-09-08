import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ui_utils/ui_utils.dart';

class AllItemsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final AppLocalizations locale;
  final FavouriteService favouriteService;
  final CartService cartService;

  Map<String, dynamic> param;

  AllItemsPageModel(
      {NotifierState state,
      this.cartService,
      this.favouriteService,
      this.api,
      this.auth,
      this.locale})
      : super(state: state) {
    param = {'page': 1, 'lang': locale.locale.languageCode};
  }

  List<CategoryItems> items;

  RefreshController refreshController = RefreshController();

  getAllItems(context) async {
    param['page'] = 1;
    print(param);
    setBusy();
    try {
      items = await api.getCategoryItems(context, param: param);
      items != null ? setIdle() : setError();
      // print(items.toList());
      print(items.length);

      // items.removeLast();
      print(items.length);
    } catch (e) {
      print("error");
      setError();
    }
  }

  onload(BuildContext context) async {
    param['page'] = param['page'] + 1;
    print(param['page']);
    //setBusy();
    items..addAll(await api.getCategoryItems(context, param: param) ?? []);
    if (items != null && items.isNotEmpty) {
      // lastPage = param['page'] + 1;
      setIdle();
    }
    refreshController.loadComplete();
  }

  onRefresh(BuildContext context) async {
    await getAllItems(context);
    refreshController.refreshCompleted();
  }

  void addToFavourite(BuildContext context, int itemId) async {
    bool res;
    if (!auth.userLoged) {
      UI.push(context, Routes.signIn);
    } else {
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

  addToCart(BuildContext context, CategoryItems item) async {
    final locale = AppLocalizations.of(context);
    if (auth.userLoged) {
      Map<String, dynamic> body = {
        "user": {"id": auth.user.user.id},
        "item": {"id": item.id},
        "quantity": 1
      };
      try {
        final cart = await cartService.addToCart(context, body: body);
        if (cart != null) {
          UI.toast(locale.get("Item added to cart successfully"));
        }
      } catch (e) {
        UI.toast(locale.get("Error") ?? "Error");
      }
    } else {
      UI.push(context, Routes.signInUp);
    }
  }

  gotoSignInUpPage(BuildContext context) {
    UI.push(context, Routes.signInUp);
  }
}
