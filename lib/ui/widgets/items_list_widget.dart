import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/flat_item_card.widget.dart';
import 'package:beautydoz/ui/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ui_utils/ui_utils.dart';

class PaginatedItemsWidget extends StatelessWidget {
  final List<CategoryItems> items;

  final Function onLoad;
  final Function onRefresh;
  final RefreshController refreshController;
  final bool enablePullDown;
  final bool enablePullUp;
  final int axisCount;

  const PaginatedItemsWidget(
      {@required this.items,
      @required this.onLoad,
      @required this.onRefresh,
      @required this.refreshController,
      this.axisCount = 2,
      this.enablePullDown = true,
      this.enablePullUp = true});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Expanded(
      child: SmartRefresher(
        onLoading: onLoad,
        onRefresh: onRefresh,
        controller: refreshController,
        enablePullDown: enablePullDown,
        enablePullUp: enablePullUp,
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
            child: buildItems(context, items, locale)),
      ),
    );
  }

  buildItems(BuildContext context, List<CategoryItems> items,
      AppLocalizations locale) {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      padding: EdgeInsets.only(bottom: 60),
      crossAxisCount: ScreenUtil.getDeviceType(MediaQuery.of(context)) ==
                  DeviceScreenType.Mobile &&
              MediaQuery.of(context).orientation == Orientation.portrait
          ? 2
          : 4,
      physics: NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (ctx, idx) {
        return FlatItemCard(
          item: items[idx],
        );
      },
      staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
      // ScreenUtil.getDeviceType(MediaQuery.of(context)) ==
      //             DeviceScreenType.Mobile &&
      //         MediaQuery.of(context).orientation == Orientation.portrait
      //     ? new StaggeredTile.count(1, index.isEven ? 1.4 : 1.4)
      //     : new StaggeredTile.count(1, index.isEven ? 1.4 : 1.4),
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
    );
  }

  addToCart(BuildContext context, CategoryItems item) async {
    final auth = locator<AuthenticationService>();
    final api = locator<HttpApi>();
    final cartService = locator<CartService>();
    auth.loadUser;
    final locale = AppLocalizations.of(context);
    if (auth.userLoged) {
      Map<String, dynamic> body = {
        "user": {"id": auth?.user?.user?.id},
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
}
