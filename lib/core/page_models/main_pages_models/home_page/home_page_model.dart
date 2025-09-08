import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/categories.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/category/category_service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/taps/new_cart_page.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_in_up_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class HomePageModel extends BaseNotifier {
  final AuthenticationService auth;
  final HttpApi api;

  final CategoryService categoryService;

  // for badge count
  final FavouriteService favouriteService;
  final CartService cartService;

  List<Categories> categories;

  var userLogged;

  HomePageModel(
      {this.auth,
      this.api,
      this.categoryService,
      this.favouriteService,
      this.cartService}) {
    userLogged = auth.userLoged;
  }

  int currentPageIndex = 0;
  final List<Widget> pages = [
    Routes.shop,
    Routes.brandsPage(isBottomNavIndex: true),
    Routes.allItems(isBottomNavIndex: true),
    NewCartPage(),
    // Routes.cart(),
    Routes.profile,
  ];

  changeTap(BuildContext context, int i) {
    if (i != 0 && !auth.userLoged) {
      if (i == 2 || i == 1) {
        currentPageIndex = i;
        setState();
      } else {
        UI.push(context, SignInUp());
      }
    } else if (i != currentPageIndex) {
      currentPageIndex = i;
      setState();
    }
  }

  loadData(BuildContext context) {
    setBusy();
    categories = categoryService.categories;
    categories != null ? setIdle() : setError();
  }
}
