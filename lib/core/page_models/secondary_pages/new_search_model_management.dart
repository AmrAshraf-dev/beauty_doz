import 'dart:async';

import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/models/new_search_model.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui_utils/ui_utils.dart';

class NewSearchModelManagement extends BaseNotifier {
  bool loading = false;
  final locale;
  int itemLength = 0, brandLength = 0;
  final auth = locator<AuthenticationService>();
  final api = locator<HttpApi>();
  final cartService = locator<CartService>();
  TextEditingController searchController = TextEditingController();
  NewSearchModel newSearchModel = NewSearchModel(itemsList: [], brandList: []);

  Timer searchOnStoppedTyping;

  NewSearchModelManagement(this.locale);
  bool searching = false;
  search(BuildContext context, String searchWord) async {
    if (!searching) {
      // setBusy();
      newSearchModel = await api.getNewSearchData(context, searchWord, () {
        searching = true;
      });
      if (newSearchModel != null) {
        itemLength = newSearchModel.itemsList.length;
        brandLength = newSearchModel.brandList.length;
        searching = false;

        setState();
        setIdle();
      } else {
        searching = false;

        setState();
        setError();
      }
    }
  }

  addToCart(BuildContext context, CategoryItems item) async {
    final locale = AppLocalizations.of(context);
    if (auth.userLoged) {
      var availableQuantity = 0;

      try {
        availableQuantity =
            await api.getAvailableQuantity(context, param: {'itemId': item.id});
      } catch (e) {
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
