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

class BrandItemsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final Brand brand;
  final CartService cartService;

  final AppLocalizations locale;

  final FavouriteService favouriteService;

  Map<String, dynamic> param;

  BrandItemsPageModel(
      {NotifierState state,
      this.locale,
      this.cartService,
      this.api,
      this.auth,
      this.brand,
      this.favouriteService})
      : super(state: state) {
    param = {
      'page': 1,
      'lang': locale.locale.languageCode,
      'brandId': brand.id,
    };
  }

  List<CategoryItems> items;

  getBrandItems(
    BuildContext context,
  ) async {
    param['page'] = 1;
    print(param);
    setBusy();
    try {
      items = await api.getCategoryItems(context, param: param);
      items != null ? setIdle() : setError();
    } catch (e) {
      print("error");
      setError();
    }
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

  void removerFromFavourite(BuildContext context, {int lineId}) async {
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

  RefreshController refreshController = RefreshController();

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
    await getBrandItems(context);
    refreshController.refreshCompleted();
  }

  void addToCart(BuildContext context, CategoryItems item) async {
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
