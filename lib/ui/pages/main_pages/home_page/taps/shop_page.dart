import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/home_page_model.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/taps/shop_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/category/category_service.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/drawer.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/flat_item_card.widget.dart';
import 'package:beautydoz/ui/widgets/item_card.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class ShopPage extends StatelessWidget {
  final CategoryItems item;

  ShopPage({Key key, this.item}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FeatureDiscovery(
      recordStepsInSharedPreferences: false,
      child: BaseWidget<ShopPageModel>(
          initState: (m) async {
            m.setBusy();
            await m.getHomePageItems(context);
            m.setIdle();
            await m.getHomeLists(context);
            await m.categoryService.getCategories(context);
            m.setState();
          },
          model: ShopPageModel(
            context: context,
            categoryService: Provider.of<CategoryService>(context),
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            cartService: Provider.of(context),
            favouriteService: Provider.of(context),
          ),
          builder: (context, model, child) {
            return Scaffold(
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: PreferredSize(
                child: NewAppBar(
                    title: '',
                    returnBtn: false,
                    onLanguageChanged: () {
                      model.setState();
                    }),
                preferredSize: Size(ScreenUtil.screenWidthDp, 80),
              ),
              body: Container(
                height: ScreenUtil.screenHeightDp,
                width: ScreenUtil.screenWidthDp,
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: model.busy
                        ? Container(
                            height: ScreenUtil.screenHeightDp,
                            child: Center(
                              child: LoadingIndicator(),
                            ),
                          )
                        : model.hasError || model.homePageItems == null
                            ? Container(
                                height: ScreenUtil.screenHeightDp,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Center(
                                      child:
                                          Text(locale.get("Error") ?? "Error"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        model.tryAgain(context);
                                      },
                                      child: Text(
                                        locale.get("Try again") ?? "Try again",
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : model.idle && model.homePageItems != null
                                ? Column(
                                    children: <Widget>[
                                      // header(context, locale, model),
                                      searchBox(context, locale, model),
                                      if (model
                                          .homePageItems.banners.isNotEmpty)
                                        banners(context, model, locale),
                                      if (model
                                          .homePageItems.brands.isNotEmpty) ...[
                                        buildTitle(context,
                                            title: "Brands",
                                            seeMoreOnClick: () => UI.push(
                                                context,
                                                Routes.brandsPage(
                                                    isBottomNavIndex: false))),
                                        buildBrandsItems(context, model),
                                      ],
                                      if (model.homePageItems.topSellers
                                          .isNotEmpty) ...[
                                        buildTitle(context,
                                            title: "Best Sellers",
                                            seeMoreOnClick: () => UI.push(
                                                context,
                                                Routes.homePageSeeMore(
                                                    items: model.homePageItems
                                                        .topSellers))),
                                        // if (item?.availableQty >= 1)
                                        //   Container()
                                        // else
                                        buildBestsellerItems(context, model)
                                      ],
                                      if (model.homePageItems.recentlyAdded
                                          .isNotEmpty) ...[
                                        buildTitle(context,
                                            title: "New Arrival",
                                            seeMoreOnClick: () => UI.push(
                                                context,
                                                Routes.homePageSeeMore(
                                                    items: model.homePageItems
                                                        .recentlyAdded))),
                                        // if (item?.availableQty <= 1)
                                        //   Container()
                                        // else
                                        buildRecentlyAddedItems(context, model)
                                      ],
                                      if (model.lists.isNotEmpty)
                                        ...model.lists.map((list) {
                                          return Column(
                                            children: [
                                              buildTitle(context,
                                                  title: list.title
                                                      .localized(context),
                                                  seeMore: true,
                                                  seeMoreOnClick: () => UI.push(
                                                      context,
                                                      Routes.homePageSeeMore(
                                                          items: list.items))),
                                              buildItems(
                                                  context, model, list.items)
                                            ],
                                          );
                                          // buildNichPerfumesItems(
                                          //     context, model, homePageService),
                                        }).toList(),
                                    ],
                                  )
                                : Container(
                                    height: ScreenUtil.screenHeightDp,
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(locale.get(
                                                  "There are no categories") ??
                                              "There are no Categories"),
                                        ],
                                      ),
                                    ),
                                  ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  Widget buildBestsellerItems(BuildContext context, ShopPageModel model) {
    final locale = AppLocalizations.of(context);
    return model.homePageItems?.topSellers != null
        ? buildItems(context, model, model.homePageItems.topSellers)
        : Text(locale.get("Error") ?? "Error");
  }

  Widget buildRecentlyAddedItems(BuildContext context, ShopPageModel model) {
    final locale = AppLocalizations.of(context);
    return model.busy
        ? LoadingIndicator()
        : model.homePageItems?.topSellers != null
            ? buildItems(context, model, model.homePageItems.recentlyAdded)
            : Text(locale.get("Error") ?? "Error");
  }

  Container buildBrandsItems(BuildContext context, ShopPageModel model) {
    final locale = AppLocalizations.of(context);
    return Container(
        height: ScreenUtil.screenHeightDp / 9,
        margin: EdgeInsets.all(5),
        child: model.busy
            ? LoadingIndicator()
            : model.homePageItems?.brands != null
                ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: model.homePageItems.brands.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          InkWell(
                            onTap: () {
                              model.gotToItemDescription(
                                  context, model.homePageItems.brands[index]);
                            },
                            child: Container(
                              height: 100,
                              width: 100,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              child: Center(
                                child: CachedNetworkImage(
                                  placeholder: (context, url) =>
                                      LoadingIndicator(),
                                  color: Colors.white,
                                  colorBlendMode: BlendMode.multiply,
                                  imageUrl:
                                      model.homePageItems.brands[index].image,
                                  errorWidget: (context, url, error) => Center(
                                      child: Image.asset(
                                    'assets/images/beautyLogo.png',
                                  )),
                                ),
                              ),
                            ),
                          ),
                          index != model.homePageItems.brands.length - 1
                              ? Container(
                                  width: 2,
                                  padding: EdgeInsets.all(8),
                                )
                              : SizedBox()
                        ],
                      );
                    })
                : Text(locale.get("Error") ??
                    "Error") //TODO but try again generic widget to fetch home page items again,
        );
  }

  buildItems(
      BuildContext context, ShopPageModel model, List<CategoryItems> items) {
    return Container(
      height: 300,
      alignment: Alignment.center,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.all(15.0),
        itemCount: items.length,
        itemBuilder: (context, index) => Container(
          width: 180,
          child: FlatItemCard(
            item: items[index],
          ),
        ),
        separatorBuilder: (context, index) => SizedBox(
          width: 15,
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context,
      {@required String title,
      @required Function() seeMoreOnClick,
      bool seeMore = true}) {
    final locale = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            locale.get(title).toUpperCase(),
            style: TextStyle(fontSize: 22),
          ),
          if (seeMore)
            InkWell(
              onTap: seeMoreOnClick,
              child: Text(
                locale.get('See more').toUpperCase(),
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 15),
              ),
            ),
        ],
      ),
    );
  }

  Widget banners(
      BuildContext context, ShopPageModel model, AppLocalizations locale) {
    return model.busy
        ? Container(child: Center(child: LoadingIndicator()))
        : model.hasError
            ? Center(
                child: Image.asset(
                  'assets/images/beautyLogo.png',
                  scale: 10,
                ),
              )
            : model.homePageItems.banners != null
                ? CarouselSlider(
                    items: model.homePageItems.banners
                        .map((banner) => InkWell(
                              onTap: () {
                                UI.push(context, Routes.banner(banner));
                              },
                              child: CachedNetworkImage(
                                cacheManager: CustomCacheManager.instance,
                                placeholder: (context, url) =>
                                    LoadingIndicator(),
                                imageUrl: banner.image,
                                fit: BoxFit.fitHeight,
                                errorWidget: (context, url, error) => Center(
                                    child: Image.asset(
                                  'assets/images/beautyLogo.png',
                                )),
                              ),
                            ))
                        .toList(),
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      height: ScreenUtil.screenHeightDp / 3,
                      autoPlay: true,
                      viewportFraction: 1,
                      scrollDirection: Axis.horizontal,
                    ),
                  )
                : Text(locale.get("Error") ?? "Error");
  }

  GlobalKey<EnsureVisibleState> ensureVisibleGlobalKey =
      GlobalKey<EnsureVisibleState>();

  searchBox(
      BuildContext context, AppLocalizations locale, ShopPageModel model) {
    return InkWell(
      onTap: () {
        model.gotoSearch(context);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: ScreenUtil.portrait ? 22 : 75),
        // width: 317.0,
        height: 42.0,
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.1),
              offset: Offset(0, 0),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.search),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(locale.get("Search") ?? "Search" + '...'),
            ),
          ],
        ),
      ),
    );
  }

  Widget getFlagIcon(BuildContext context, String asset, String currency,
      ShopPageModel model) {
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
}
