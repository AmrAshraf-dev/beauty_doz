import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ui_utils/ui_utils.dart';
import 'dart:async';
import '../../../ui/routes/routes.dart';

class SearchPageModel extends BaseNotifier {
  final AuthenticationService auth;
  final HttpApi api;
  final AppLocalizations locale;
  final FavouriteService favouriteService;
  final CartService cartService;
  RefreshController refreshController = RefreshController();
  Timer searchOnStoppedTyping;

  Map<String, dynamic> param;

  SearchPageModel(
      {this.auth,
      this.api,
      this.locale,
      this.favouriteService,
      this.cartService});

  TextEditingController searchTextController = new TextEditingController();

  List<CategoryItems> items;

  bool searching = true;
  search(BuildContext context, text) async {
    param = {
      'page': 1,
      'lang': locale.locale.languageCode,
      'name': text,
    };

    if (searchTextController.text.isNotEmpty) {
      setBusy();
      try {
        items = await api.getCategoryItems(context, param: param);

        if (items != null) {
          setIdle();
          setState();
          return items;
        } else {
          setError();
        }
      } catch (e) {
        print("error");
        setError();
      }
    } else {
      UI.toast(locale.get("Search must not empty") ?? "Search must not empty");
    }
  }

  onChangeHandler(BuildContext context, value) async {
    const duration = Duration(
        milliseconds:
            800); // set the duration that you want call search() after that.
    if (searchOnStoppedTyping != null) {
      searchOnStoppedTyping.cancel();
      setState(); // clear timer
    }
    searchOnStoppedTyping =
        new Timer(duration, () => searchval(context, value));
  }

  searchval(context, value) async {
    print('hello world from search . the value is $value');
    search(context, value).then((all) {
      items = all;
      setState();
    });
  }

  onload(BuildContext context) async {
    if (searchTextController.text.isNotEmpty) {
      param['page'] = param['page'] + 1;
      print(param['page']);
      //setBusy();
      items..addAll(await api.getCategoryItems(context, param: param) ?? []);
      if (items != null && items.isNotEmpty) {
        // lastPage = param['page'] + 1;
        setIdle();
      }
      refreshController.loadComplete();
    } else {
      UI.toast(locale.get("Search must not empty") ?? "Search must not empty");
    }
  }

  onRefresh(BuildContext context, text) async {
    await search(context, text);
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

  removerFromFavourite(BuildContext context) async {
    bool res;
    try {
      res = await favouriteService.removeFromFavourites(context,
          lineId: favouriteService.lineId);
    } catch (e) {
      setError();
    }

    if (res) {
      favouriteService.favourites.lines
          .removeWhere((element) => element.id == favouriteService.lineId);
      setIdle();
    } else {
      setError();
    }
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
        UI.toast("Error");
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
