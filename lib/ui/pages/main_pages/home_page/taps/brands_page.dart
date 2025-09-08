import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/home_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/drawer.service.dart';
import 'package:beautydoz/core/services/homePageService/home_page_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/location/locationService.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/drawer/home_drawer.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ui_utils/ui_utils.dart';
import '../../../../../core/page_models/secondary_pages/brands_page_model.dart';

class BrandsPage extends StatelessWidget {
  final bool isBottomNavIndex;
  const BrandsPage({Key key, this.isBottomNavIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          child: NewAppBar(
            title: 'Brands',
            returnBtn: false,
            onLanguageChanged: null,
          ),
          preferredSize: Size(ScreenUtil.screenWidthDp, 80),
        ),
        body: BaseWidget<BrandsPageModel>(
          initState: (model) =>
              WidgetsBinding.instance.addPostFrameCallback((_) {
            model.getBrands();
          }),
          model: BrandsPageModel(
              context: context,
              api: Provider.of<Api>(context),
              auth: Provider.of(context)),
          builder: (context, model, child) {
            final locale = AppLocalizations.of(context);
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // logo(context),
                  // buildAppBar(context, isBottomNavIndex: isBottomNavIndex),

                  searchBox(context, locale, model),
                  model.busy
                      ? Expanded(
                          child: Center(
                          child: LoadingIndicator(),
                        ))
                      : model.hasError
                          ? Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  UI.push(context, Routes.home,
                                      replace: true); //* adding navigation
                                },
                                child: Center(
                                    child: Image.asset(
                                  'assets/images/beautyLogo.png',
                                  scale: 6,
                                )),
                              ),
                            )
                          : model.brands != null && model.brands.isNotEmpty
                              ? buildGridBrands(context, model)
                              : Expanded(
                                  child: SingleChildScrollView(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.error_outline),
                                          Text(locale
                                                  .get("There is no brands") ??
                                              "There is no brands"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  SafeArea buildAppBar(BuildContext context, {bool isBottomNavIndex}) {
    final locale = AppLocalizations.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // back arrow
            InkWell(
              onTap: () {
                isBottomNavIndex
                    ? Provider.of<HomePageModel>(context, listen: false)
                        .changeTap(context, 0)
                    : Navigator.pop(context);
              },
              child: Container(
                child:
                    Icon(Icons.arrow_back_ios, size: 28, color: Colors.black),
              ),
            ),

            Text(
              locale.get("Brands") ?? "Brands",
              style: TextStyle(
                  fontSize: 25,
                  color: const Color(0xff313131),
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),

            Row(),
          ],
        ),
      ),
    );
  }

  Widget buildGridBrands(context, model) {
    return Expanded(
      child: GridView.builder(
          itemCount: model.brands.length ?? 0,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 1 / 1.2),
          itemBuilder: (ctx, index) {
            String brandName = model.brands[index].name.localized(context);
            return InkWell(
              onTap: () {
                UI.push(context, Routes.brandItems(brand: model.brands[index]));
              },
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: CachedNetworkImage(
                          cacheManager: CustomCacheManager.instance,
                          color: Colors.white,
                          colorBlendMode: BlendMode.multiply,
                          placeholder: (context, url) => LoadingIndicator(),
                          errorWidget: (context, url, error) => GestureDetector(
                            onTap: () {
                              UI.push(context, Routes.home,
                                  replace: true); //* adding navigation
                            },
                            child: Center(
                                child: Image.asset(
                              'assets/images/beautyLogo.png',
                              // height: 80,
                              width: 80,
                              scale: 2,
                            )),
                          ),
                          imageUrl: model.brands[index].image,
                          fadeInCurve: Curves.easeIn,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    /* brandName.length < 10
                        ?  */
                    SizedBox(
                      width: ScreenUtil.screenWidthDp / 4,
                      child: Text(
                        brandName,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
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
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: Container(
            width: 57.5,
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

  searchBox(
      BuildContext context, AppLocalizations locale, BrandsPageModel model) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil.portrait ? 44 : 75, vertical: 20),
      // width: 317.0,
      height: 42.0,
      // alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).primaryColor,
        border: Border.all(color: Colors.transparent),
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.search),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: TextFormField(
                // textDirection: TextDirection.ltr,
                // textAlign: TextAlign.start,
                controller: model.brandNameController,
                onChanged: (text) {
                  print("mDebug: $text");
                  // model.brandNameController.text = text;
                  model.search();
                },
                cursorColor: Theme.of(context).textTheme.bodyText1.color,

                decoration: InputDecoration(
                    // suffixIcon: InkWell(
                    //     onTap: () {
                    //       model.search();
                    //     },
                    //     child: Icon(Icons.send)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(bottom: 7, right: 15),
                    hintText: locale.get("Search") ?? "Search" + '...'),

                // padding: EdgeInsets.only(left: 10),
                // child: Text(locale.get("Search") ?? "Search" + '...'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding buildCards(CategoryItems item, int index, BuildContext context,
      AppLocalizations locale, model) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: ScreenUtil.screenWidthDp / 2.25,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                                  UI.push(context, Routes.home,
                                      replace: true); //* adding navigation
                                },
                                child: Center(
                                    child: Image.asset(
                                  'assets/images/beautyLogo.png',
                                  scale: 10,
                                )),
                              ),

                              imageUrl: item.image,
                              fadeInCurve: Curves.easeIn,
                              // fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RatingBar.builder(
                          initialRating: item.cRating.toDouble(),
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
                            item.name.localized(context) ?? " ",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                        item.discount == 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(top: 3.0, bottom: 8),
                                child: Text(
                                    "${(num.parse(item.price)).toStringAsFixed(2)}" +
                                        "  " +
                                        locale.get('KD'),
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
                                        "${(num.parse(item.price)).toStringAsFixed(2)}" +
                                            "  " +
                                            locale.get('KD'),
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 16,
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600)),
                                    Text(
                                        "${(num.parse(item.priceAfter)).toStringAsFixed(2)}" +
                                            "  " +
                                            locale.get('KD'),
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
              // buildAddAndFavo(context, model, items, index),
            ],
          ),
        ),
      ),
    );
  }
}
