import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/category/category_service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/homePageService/home_page_service.dart';
import 'package:beautydoz/core/services/notification/notification_service.dart';
import 'package:beautydoz/core/services/preference/preference.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InitService {
  final BuildContext context;

  InitService({this.context});

  String fcmToken;

  initServices(BuildContext context) async {
    // Provider.of<CategoryService>(context, listen: false).getCategories(context);

    Provider.of<CartService>(context, listen: false).getCartsForUser(context);

    Provider.of<FavouriteService>(context, listen: false)
        .getFavourites(context);
  }
}
