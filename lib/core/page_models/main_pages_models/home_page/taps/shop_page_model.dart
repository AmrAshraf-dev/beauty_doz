import 'package:beautydoz/core/models/home-list.model.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/models/home_page_items.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/category/category_service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/homePageService/home_page_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/location/locationService.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class ShopPageModel extends BaseNotifier {
  int currentBannerIndex = 0;

  final AuthenticationService auth;
  final CategoryService categoryService;
  final FavouriteService favouriteService;
  final CartService cartService;
  final HttpApi api;

  final BuildContext context;

  HomePageItems homePageItems = HomePageItems(
      banners: [],
      brands: [],
      nichPerfumes: [],
      recentlyAdded: [],
      topSellers: []);

  ShopPageModel(
      {this.auth,
      this.api,
      this.categoryService,
      NotifierState state,
      this.favouriteService,
      this.cartService,
      @required this.context})
      : super(state: state) {
    // if (homePageService.homePageItems == null) {
    // getHomeItemsAgain(context);
    // }
  }

  // loadHomePageItems(BuildContext context) async {
  //   setBusy();
  //   if (homePageService.homePageItems != null && homePageService.idle) {
  //     homePageItems = homePageService.homePageItems;
  //     setIdle();
  //   } else {
  //     if (homePageService.homePageItems == null && homePageService.hasError) {
  //       setError();
  //     }
  //   }
  // }
  // changeCurrencyBasedOnLocationData() async {
  //   await CurrencyLocationServices.changeCurrencyBasedOnCountry();
  // }

  List<HomeList> lists = [];

  getHomePageItems(BuildContext context) async {
    homePageItems = await api.getHomePageItems(context);
  }

  getHomeLists(BuildContext context) async {
    lists = await api.getHomeLists(context);
  }

  gotoSearch(BuildContext context) {
    // UI.push(context, Routes.search);
    UI.push(context, Routes.newSearch);
  }

  gotToItemDescription(BuildContext context, Brand brand) {
    UI.push(context, Routes.brandItems(brand: brand));
  }

  void tryAgain(BuildContext context) async {
    setBusy();
    await getHomePageItems(context);
    await getHomeLists(context);
    await categoryService.getCategories(context);
    setIdle();
  }

  void getHomeItemsAgain(BuildContext context) async {
    setBusy();
    await getHomePageItems(context);
    await getHomeLists(context);
    setIdle();
    await categoryService.getCategories(context);
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

  removeFromFavourite(BuildContext context) async {
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

  addToCart(BuildContext context, CategoryItems item) async {
    final locale = AppLocalizations.of(context);
    if (auth.userLoged) {
      // var availableQuantity = 0;

      // try {
      //   availableQuantity =
      //       await api.getAvailableQuantity(context, param: {'itemId': item.id});
      // } catch (e) {
      //   setIdle();
      //   UI.toast(locale.get("Error") ?? "Error");
      //   return;
      // }
      // if (availableQuantity > 0) {
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
      // } else {
      //   UI.toast(locale.get("out of quantity"));
      // }
    } else {
      UI.push(context, Routes.signInUp);
    }
  }
}
