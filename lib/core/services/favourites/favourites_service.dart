import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/favourite_model.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

class FavouriteService extends BaseNotifier {
  final HttpApi api;

  FavouriteService({NotifierState state, this.api}) : super(state: state);

  FavouritesModel favourites, newFavourite;

  int lineId;

  getFavourites(BuildContext context) async {
    newFavourite = null;
    if (Provider.of<AuthenticationService>(context, listen: false).userLoged) {
      setBusy();

      newFavourite = await api.getFavourites(context,
          userId: Provider.of<AuthenticationService>(context, listen: false)
              .user
              .user
              .id);

      if (newFavourite != null) {
        favourites = newFavourite;
        setIdle();
        return favourites;
      } else {
        setError();
        return null;
      }
    }
  }

  addToFavourites(BuildContext context, {int itemId}) async {
    newFavourite = null;
    setBusy();

    Map<String, dynamic> body = {
      "user": {
        "id": Provider.of<AuthenticationService>(context, listen: false)
            .user
            .user
            .id
      },
      "item": {"id": itemId}
    };
    try {
      newFavourite = await api.addToFavourites(context, body: body);
    } catch (e) {
      setError();
      return false;
    }
    if (newFavourite != null) {
      favourites = newFavourite;
      Logger().i(favourites.toJson());
      newFavourite = null;
      setIdle();
      return true;
    } else {
      setError();
      return false;
    }
  }

  removeFromFavourites(BuildContext context, {int lineId}) async {
    setBusy();

    Map<String, dynamic> queryParam = {
      'userId': Provider.of<AuthenticationService>(context, listen: false)
          .user
          .user
          .id,
      'lineId': lineId
    };

    try {
      newFavourite =
          await api.removeFromFavourite(context, queryParam: queryParam);
    } catch (e) {
      setError();
      return false;
    }
    if (newFavourite != null) {
      favourites = newFavourite;
      newFavourite = null;
      setIdle();
      return true;
    } else {
      setError();
      return false;
    }
  }
}
