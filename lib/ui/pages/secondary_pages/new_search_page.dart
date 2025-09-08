import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/models/new_search_model.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/home_page_model.dart';
import 'package:beautydoz/core/page_models/secondary_pages/new_search_model_management.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/styles.dart';
import 'package:beautydoz/ui/widgets/flat_item_card.widget.dart';
import 'package:beautydoz/ui/widgets/item_card.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:logger/logger.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:provider/provider.dart';

class NewSearchPage extends StatefulWidget {
  @override
  State<NewSearchPage> createState() => _NewSearchPageState();
}

class _NewSearchPageState extends State<NewSearchPage> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FeatureDiscovery(
      recordStepsInSharedPreferences: false,
      child: BaseWidget<NewSearchModelManagement>(
          model: NewSearchModelManagement(locale),
          builder: (context, model, child) {
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: PreferredSize(
                child: NewAppBar(
                    title: 'Search',
                    returnBtn: false,
                    onLanguageChanged: () {
                      model.setState();
                    }),
                preferredSize: Size(ScreenUtil.screenWidthDp, 80),
              ),
              body: SingleChildScrollView(
                child: model.searchController.text.isEmpty ||
                        model.searchController.text.length < 3
                    ? Column(
                        children: [
                          buildSearchBar(context, model, locale),
                          buildNoItemsSearchText(model, locale),
                        ],
                      )
                    : FutureBuilder<NewSearchModel>(
                        initialData:
                            NewSearchModel(brandList: [], itemsList: []),
                        future: model.api.getNewSearchData(
                            context, model.searchController.text, () => null),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Column(
                              children: [
                                buildSearchBar(context, model, locale),
                                Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal:
                                            ScreenUtil.portrait ? 22 : 75),
                                    child: LinearProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                      backgroundColor:
                                          Theme.of(context).backgroundColor,
                                    )),
                                buildNoItemsSearchText(model, locale),
                              ],
                            );

                          if (snapshot.hasError) {
                            return Column(
                              children: [
                                buildSearchBar(context, model, locale),
                                buildNoItemsSearchText(model, locale),
                              ],
                            );
                          } else if (snapshot.hasData) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                buildSearchBar(context, model, locale),
                                if (snapshot.data.brandList != null?.isNotEmpty)
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 18.0),
                                        child: Text(
                                          locale.get('Brands'),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 22),
                                        ),
                                      ),
                                    ],
                                  ),
                                buildGridBrands(context, snapshot.data, locale),
                                if (snapshot.data.itemsList != null)
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(18),
                                        child: Text(
                                          locale.get('Items'),
                                          textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 22),
                                        ),
                                      ),
                                    ],
                                  ),
                                buildItems(context,
                                    snapshot.data.itemsList ?? [], locale)
                              ],
                            );
                          } else {
                            return Column(
                              children: [
                                buildSearchBar(context, model, locale),
                                buildNoItemsSearchText(model, locale),
                              ],
                            );
                          }
                        }),
              ),
            );
          }),
    );
  }

  Widget buildItems(BuildContext context, List<CategoryItems> items,
      AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StaggeredGridView.countBuilder(
        shrinkWrap: true,
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
          // }
        },
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        padding: EdgeInsets.only(bottom: 60),

        // ScreenUtil.getDeviceType(MediaQuery.of(context)) ==
        //             DeviceScreenType.Mobile &&
        //         MediaQuery.of(context).orientation == Orientation.portrait
        //     ? new StaggeredTile.count(1, index.isEven ? 1.4 : 1.4)
        //     : new StaggeredTile.count(1, index.isEven ? 1.4 : 1.4),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
    );
  }

  Widget buildGridBrands(context, data, AppLocalizations locale) {
    return Container(
      height: 80,
      margin: EdgeInsets.all(5),
      child: ListView.builder(
          itemCount: data?.brandList?.length ?? 0,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemBuilder: (ctx, index) {
            return Row(children: [
              InkWell(
                onTap: () {
                  UI.push(
                      context, Routes.brandItems(brand: data.brandList[index]));
                },
                child: Container(
                  margin: EdgeInsets.all(8),
                  height: ScreenUtil.screenWidthDp * .3,
                  width: ScreenUtil.screenWidthDp * .2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: CachedNetworkImage(
                    placeholder: (context, url) => LoadingIndicator(),
                    imageUrl: data.brandList[index].image,
                    errorWidget: (context, url, error) => Center(
                        child: Image.asset(
                      'assets/images/beautyLogo.png',
                      scale: 10,
                    )),
                  ),
                ),
              ),
              index != data.brandList.length - 1
                  ? Container(
                      width: 1,
                      padding: EdgeInsets.all(8),
                    )
                  : SizedBox()
            ]);
          }),
    );
  }

  Widget buildSearchText(AppLocalizations locale) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 28,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(locale.get("Search for what you want") ??
                    "Search for what you want"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNoItemsSearchText(model, AppLocalizations locale) {
    return Container(
      height: ScreenUtil.screenHeightDp,
      width: ScreenUtil.screenWidthDp,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.search,
              size: 28,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(locale.get("Search For anything")),
            ),
          ],
        ),
      ),
    );
  }

  Widget getFlagIcon(
      BuildContext context, String asset, String currency, model) {
    return IconButton(
        icon: ClipOval(
          child: Image.asset(
            'assets/images/flags/$asset',
            fit: BoxFit.cover,
            width: 40,
            height: 40,
            alignment: Alignment.centerLeft,
          ),
        ),
        onPressed: () {
          locator<CurrencyService>().selectCurrency(currency);
          locator<CurrencyService>().setState();
          model.setState();
          FeatureDiscovery.dismissAll(context);
        });
  }

  Widget searchBar(BuildContext context, AppLocalizations locale,
      NewSearchModelManagement model) {
    return TextField(
      autofocus: true,
      onSubmitted: (text) {
        model.setState();
      },
      onChanged: (text) {
        model.setState();
      },
      maxLines: 1,
      keyboardType: TextInputType.text,
      enableSuggestions: true,
      keyboardAppearance: Brightness.light,
      enableInteractiveSelection: true,
      textInputAction: TextInputAction.search,
      cursorColor: Theme.of(context).textTheme.bodyText1.color,
      decoration: InputDecoration(
        hintText: locale.get('Search') + '..',
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
      ),
      controller: model.searchController,
      style: Theme.of(context).textTheme.bodyText1,
    );
  }

  buildSearchBar(BuildContext context, NewSearchModelManagement model,
      AppLocalizations locale) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil.portrait ? 22 : 75),
      height: 45.0,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            spreadRadius: 0,
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.3),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: searchBar(context, locale, model),
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
