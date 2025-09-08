import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/models/favourite_model.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class FavoritesPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final CartService cartService;
  final FavouriteService favouriteService;

  FavouritesModel favourites;

  FavoritesPageModel(
      {NotifierState state,
      this.api,
      this.auth,
      this.cartService,
      this.favouriteService})
      : super(state: state);

  openItem(BuildContext context, CategoryItems item) {
    UI.push(context, Routes.item(item: item));
  }

  loadFavourites(BuildContext context) async {
    setBusy();
    favourites = await favouriteService.getFavourites(context);
    favourites == null ? setError() : setIdle();
  }

  void removeFromFavourites(BuildContext context, Lines line) async {
    bool res;
    setBusy();
    try {
      res =
          await favouriteService.removeFromFavourites(context, lineId: line.id);
    } catch (e) {
      setError();
    }

    if (res) {
      //favourites.lines.remove(line);
      setIdle();
    } else {
      setError();
    }
  }
}
