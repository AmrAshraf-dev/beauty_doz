import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/categories.dart';
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

class CategoryItemPageModel extends BaseNotifier {
  final AuthenticationService auth;
  final HttpApi api;

  final Categories category;

  List<CategoryItems> items;

  RefreshController refreshController = RefreshController();

  Map<String, dynamic> param;
  final FavouriteService favouriteService;
  final CartService cartService;

  final AppLocalizations locale;

  CategoryItemPageModel(
      {@required BuildContext context,
      this.favouriteService,
      this.auth,
      this.cartService,
      this.api,
      this.category,
      this.locale}) {
    param = {
      'page': 1,
      'lang': locale.locale.languageCode,
      'categoryId': category.id,
    };

    //getCategoryItems(context);
  }

  itemDetails(BuildContext context) {
    UI.push(context, Routes.item());
  }

  Future<List<CategoryItems>> getCategoryItems(
    BuildContext context,
  ) async {
    param['page'] = 1;
    setBusy();

    try {
      items = await api.getCategoryItems(context, param: param);
      items != null ? setIdle() : setError();
    } catch (e) {
      print("error");
      setError();
    }

    return items;
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
    await getCategoryItems(context);
    refreshController.refreshCompleted();
  }

  void addToFavourite(BuildContext context, int itemId) async {
    bool res;
    if (!auth.userLoged) {
      UI.push(context, Routes.signIn);
    } else {
      try {
        res = await favouriteService.addToFavourites(context, itemId: itemId);
        print("User :::::::::::: " + auth.user.token);
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

  gotoSignInUpPage(BuildContext context) {
    UI.push(context, Routes.signInUp);
  }

  addToCart(BuildContext context, CategoryItems item) async {
    final locale = AppLocalizations.of(context);
    if (auth.userLoged) {
      var availableQuantity = 0;

      try {
        availableQuantity =
            await api.getAvailableQuantity(context, param: {'itemId': item.id});
      } catch (e) {
        setIdle();
        UI.toast(locale.get("Error") ?? "Error");
        return;
      }
      if (availableQuantity > 0) {
        Map<String, dynamic> body = {
          "user": {"id": auth.user.user.id},
          "item": {"id": item.id},
          "quantity": 1
        };
        try {
          final cart = await cartService.addToCart(context, body: body);
          if (cart != null) {
            UI.toast(locale.get("Item added to cart successfully"));
          } else {
            UI.toast(locale.get("Error occured"));
          }
        } catch (e) {
          UI.toast(locale.get("Error") ?? "Error");
        }
      } else {
        UI.toast(locale.get("out of quantity"));
      }
    } else {
      UI.push(context, Routes.signInUp);
    }
  }
}
