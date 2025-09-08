import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/page_models/secondary_pages/home_page_see_more_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/homePageService/home_page_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/location/locationService.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_in_up_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/flat_item_card.widget.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class SeeMorePage extends StatelessWidget {
  final List<CategoryItems> items;

  SeeMorePage({this.items});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          child: BaseWidget<SeeMorePageModel>(
              initState: (m) => WidgetsBinding.instance
                  .addPostFrameCallback((_) => m.getOtherBanners()),
              model: SeeMorePageModel(
                api: Provider.of<Api>(context),
                auth: Provider.of(context),
                context: context,
                cartService: Provider.of(context),
                favouriteService: Provider.of(context),
              ),
              builder: (context, model, child) {
                return SingleChildScrollView(
                  child: Container(
                    height: ScreenUtil.screenHeightDp,
                    width: ScreenUtil.screenWidthDp,
                    child: Column(
                      // mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        SizedBox(
                          height: ScreenUtil.portrait ? 30 : 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Icon(Icons.arrow_back_ios,
                                      color: Colors.black)),
                              InkWell(
                                onTap: () {
                                  UI.push(context,
                                      Routes.allItems(isBottomNavIndex: false));
                                },
                                child: Text(
                                  locale.get("Show All") ?? "Show All",
                                  style: TextStyle(
                                      color: AppColors.accentText,
                                      fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.all(8),
                            child: buildItems(context, model, items)),
                        model.busy
                            ? Center(
                                child: LoadingIndicator(),
                              )
                            : model.banners != null && model.banners.isNotEmpty
                                ? Expanded(
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: List.generate(
                                          model.banners.length,
                                          (index) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: InkWell(
                                              onTap: () {
                                                UI.push(
                                                    context,
                                                    Routes.banner(
                                                        model.banners[index]));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: ScreenUtil.portrait
                                                      ? ScreenUtil
                                                              .screenHeightDp /
                                                          6
                                                      : ScreenUtil
                                                              .screenHeightDp /
                                                          4,
                                                  width:
                                                      ScreenUtil.screenWidthDp /
                                                          1.15,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            offset:
                                                                Offset(0, 0),
                                                            spreadRadius: 3,
                                                            color:
                                                                Colors.white54)
                                                      ]),
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: ScreenUtil
                                                                .portrait
                                                            ? ScreenUtil
                                                                    .screenHeightDp /
                                                                6
                                                            : ScreenUtil
                                                                    .screenHeightDp /
                                                                4,
                                                        width: ScreenUtil
                                                                .screenWidthDp /
                                                            1.15,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          cacheManager:
                                                              CustomCacheManager
                                                                  .instance,
                                                          placeholder: (context,
                                                                  url) =>
                                                              Center(
                                                                  child:
                                                                      LoadingIndicator()),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              GestureDetector(
                                                            onTap: () {
                                                              UI.push(context,
                                                                  Routes.home,
                                                                  replace:
                                                                      true); //* adding navigation
                                                            },
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey)),
                                                              child: Center(
                                                                  child: Image
                                                                      .asset(
                                                                'assets/images/beautyLogo.png',
                                                                scale: 5,
                                                              )),
                                                            ),
                                                          ),

                                                          imageUrl: model
                                                              .banners[index]
                                                              .image,
                                                          fit: BoxFit.cover,
                                                          fadeInCurve:
                                                              Curves.easeIn,
                                                          // fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 12.0,
                                                                horizontal: 12),
                                                        child: Align(
                                                            alignment: Alignment
                                                                .bottomLeft,
                                                            child: Text(
                                                                model
                                                                    .banners[
                                                                        index]
                                                                    .title
                                                                    .localized(
                                                                        context),
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        25,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold))),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Center(child: Text("")),
                                  )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }

  buildItems(BuildContext context, model, List<CategoryItems> items) {
    final locale = AppLocalizations.of(context);

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

  Padding buildCards(List<CategoryItems> items, int index, BuildContext context,
      AppLocalizations locale, model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: ScreenUtil.screenWidthDp / 2.25,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Column(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 150,
                        child: Center(
                          child: CachedNetworkImage(
                            cacheManager: CustomCacheManager.instance,
                            placeholder: (context, url) => LoadingIndicator(),
                            errorWidget: (context, url, error) =>
                                GestureDetector(
                              onTap: () {
                                UI.pushReplaceAll(
                                    context, Routes.home); //* adding navigation
                              },
                              child: Center(
                                  child: Image.asset(
                                'assets/images/beautyLogo.png',
                                scale: 10,
                              )),
                            ),

                            imageUrl: items[index].image,
                            fadeInCurve: Curves.easeIn,
                            // fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RatingBar.builder(
                        initialRating: items[index].cRating.toDouble(),
                        minRating: 0,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        ignoreGestures: true,
                        allowHalfRating: true,
                        onRatingUpdate: (rating) {},
                        itemSize: 25,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Text(
                          items[index].name.localized(context) ?? " ",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      items[index].discount == 0
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 3.0, bottom: 8),
                              child: Text(
                                  "${(num.parse(items[index].price)).toStringAsFixed(2)}" +
                                      "  ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.accentText,
                                      fontWeight: FontWeight.w600)),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 3.0, bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      "${(num.parse(items[index].price)).toStringAsFixed(2)}" +
                                          "  ",
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 16,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      "${(num.parse(items[index].priceAfter)).toStringAsFixed(2)}" +
                                          "  ",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.accentText,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                    ],
                  ),
                )),
            buildAddAndFavo(context, model, items, index),
          ],
        ),
      ),
    );
  }

  Widget buildAddAndFavo(BuildContext context, SeeMorePageModel model,
      List<CategoryItems> items, int index) {
    return Container(
      height: ScreenUtil.portrait
          ? ScreenUtil.screenHeightDp / 16
          : ScreenUtil.screenHeightDp / 11,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12.5),
            bottomRight: Radius.circular(12.5)),
      ),
      child: Row(
        mainAxisAlignment: ScreenUtil.portrait
            ? MainAxisAlignment.spaceEvenly
            : MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: buildAddToCart(model, context, items[index]),
          ),
          Container(
            width: 2,
            // height: ScreenUtil.screenHeightDp / 16,
            color: AppColors.accentText,
          ),
          buildFavouriteIcon(model, items[index])
        ],
      ),
    );
  }

  Widget buildFavouriteIcon(SeeMorePageModel model, CategoryItems item) {
    return Consumer<FavouriteService>(builder: (context, favService, child) {
      // final authService = Provider.of<AuthenticationService>(context);
      return InkWell(
        onTap: () {
          model.auth.userLoged
              ? favService.favourites.lines.any((element) {
                  if (element.item.id == item.id) {
                    favService.lineId = element.id;
                    return true;
                  } else {
                    return false;
                  }
                })
                  ? model.removeFromFavourite(context,
                      lineId: favService.lineId)
                  : model.addToFavourite(context, item.id)
              : UI.push(context, Routes.signInUp);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 3.0),
          child: Center(
              child: Icon(
            Icons.favorite,
            color: favService.favourites != null &&
                    favService.favourites.lines
                        .any((element) => element.item.id == item.id)
                ? AppColors.accentText
                : Colors.white,
          )),
        ),
      );
    });
  }

  Widget buildAddToCart(
      SeeMorePageModel model, BuildContext context, CategoryItems item) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: RaisedButton.icon(
          label: Text(
            locale.get("Add to cart") ?? "Add to cart",
            style: TextStyle(
                color: Colors.white,
                fontSize: locale.locale == Locale("en") ? 15 : 10),
          ),
          color: Colors.transparent,
          padding: EdgeInsets.all(0),
          icon: Icon(Icons.add_shopping_cart, size: 20, color: Colors.white),
          onPressed: () {
            if (model.auth.userLoged) {
              if (item.availableQty > 0) {
                model.addToCart(context, item);
              } else {
                UI.push(context, Routes.item(item: item, cartItem: null));
              }
            } else {
              UI.push(context, SignInUp());
            }
          }),
    );
    // ));
  }
}
