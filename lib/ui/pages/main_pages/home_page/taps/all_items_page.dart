import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/home_page_model.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/taps/all_items_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/pages/secondary_pages/sort_dialog.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/items_list_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class AllItemsPage extends StatelessWidget {
  final bool isBottomNavIndex;
  AllItemsPage({this.isBottomNavIndex});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<AllItemsPageModel>(
          initState: (m) =>
              WidgetsBinding.instance.addPostFrameCallback((_) => m.getAllItems(
                    context,
                  )),
          model: AllItemsPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              cartService: Provider.of(context),
              favouriteService: Provider.of(context),
              locale: locale),
          builder: (context, model, child) {
            return Scaffold(
                appBar: PreferredSize(
                  child: NewAppBar(
                      title: 'Items',
                      returnBtn: false,
                      onLanguageChanged: () {
                        model.setState();
                      },
                      additionalWidgets: [
                        InkWell(
                            onTap: () async {
                              await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return SortDialog(
                                      param: model.param,
                                    );
                                  }).then((param) {
                                if (param != null && param is Map) {
                                  model.param = param;

                                  model.getAllItems(
                                    context,
                                  );
                                }
                              });
                            },
                            child: Icon(
                              Icons.filter_list_alt,
                              size: 26,
                            ))
                      ]),
                  preferredSize: Size(ScreenUtil.screenWidthDp, 80),
                ),
                body: SingleChildScrollView(
                    child: Container(
                        width: ScreenUtil.screenWidthDp,
                        height: ScreenUtil.screenHeightDp,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // logo
                              //Appbar
                              // SizedBox(
                              //   height: 35,
                              // ),
                              // appBar(context, locale, model),
                              // search bar
                              searchBox(context, locale, model),
                              // brandItems
                              SizedBox(
                                height: 15,
                              ),
                              allItems(context, model, locale),
                            ]))));
          }),
    );
  }

  searchBox(
      BuildContext context, AppLocalizations locale, AllItemsPageModel model) {
    return InkWell(
      onTap: () {
        UI.push(context, Routes.search);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil.portrait ? 44 : 75),
        // width: 317.0,
        height: 42.0,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
              offset: Offset(0, 0),
              blurRadius: 6,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.search),
            SizedBox(
              width: 10,
            ),
            Container(
              child: Text(locale.get("Search")),
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar(
      BuildContext context, AppLocalizations locale, AllItemsPageModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          logo(context),
          Text(
            locale.get('All Items') ?? 'All Items',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget logo(context) {
    return GestureDetector(
      onTap: () {
        UI.push(context, Routes.home, replace: true); //* adding navigation
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(left: 0, top: 30),
          child: Container(
            width: 50.5,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0),
              image: DecorationImage(
                  image: const AssetImage('assets/images/beautyLogo.png'),
                  fit: BoxFit.fitWidth),
            ),
          ),
        ),
      ),
    );
  }

  Widget allItems(
      BuildContext context, AllItemsPageModel model, AppLocalizations locale) {
    return model.busy
        ? Center(
            child: CircularProgressIndicator(
            color: AppColors.accentText,
          ))
        : model.items == null || model.items.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_shopping_cart),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(locale.get("There is no Items") ??
                          "There is no Items"),
                    )
                  ],
                ),
              )
            : PaginatedItemsWidget(
                items: model.items,
                refreshController: model.refreshController,
                onLoad: () => model.onload(context),
                // addToCart: (item) => model.addToCart(context, item),
                // addToFavourite: (item) =>
                //     model.addToFavourite(context, item.id),
                // removeFromFavourite: () =>
                //     model.removerFromFavourite(context),
                onRefresh: () => model.onRefresh(context),
                enablePullUp: true,
                enablePullDown: true,
              );
  }
}
