import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/favourite_model.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/taps/favorites_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/homePageService/home_page_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/location/locationService.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Scaffold(
      body: BaseWidget<FavoritesPageModel>(
          model: FavoritesPageModel(
              state: NotifierState.busy,
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              cartService: Provider.of(context),
              favouriteService: Provider.of(context)),
          initState: (model) => WidgetsBinding.instance.addPostFrameCallback(
              (_) => model.favouriteService.getFavourites(context)),
          builder: (context, model, child) {
            return Consumer<FavouriteService>(
              builder: (context, fsmodel, child) {
                return SafeArea(
                  child: Container(
                      height: ScreenUtil.screenHeightDp,
                      width: ScreenUtil.screenWidthDp,
                      color: AppColors.primaryBackground,
                      child: Column(
                        children: <Widget>[
                          logo(context),
                          appBar(context, locale),
                          fsmodel.busy
                              ? buildLoading()
                              : fsmodel.hasError
                                  ? buildError(context)
                                  : fsmodel.favourites == null ||
                                          fsmodel.favourites.lines == null ||
                                          fsmodel.favourites.lines.isEmpty
                                      ? buildEmpty(locale)
                                      : buildItemsList(fsmodel, model, locale),
                        ],
                      )),
                );
              },
            );
          }),
    );
  }

  Widget buildItemsList(FavouriteService fsmodel, FavoritesPageModel mainModel,
      AppLocalizations locale) {
    return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: fsmodel.favourites.lines.length,
          itemBuilder: (context, index) {
            var fav = fsmodel.favourites.lines[index];
            return listItems(fsmodel, mainModel, context, index, fav, locale);
          }),
    );
  }

  Widget listItems(FavouriteService fsmodel, FavoritesPageModel mainModel,
      BuildContext context, int index, Lines favLine, AppLocalizations locale) {
    return GestureDetector(
      onTap: () =>
          mainModel.openItem(context, fsmodel.favourites.lines[index].item),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 3.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 11, horizontal: 4),
            height: 140,
            width: double.infinity,
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(
                        cacheManager: CustomCacheManager.instance,
                        placeholder: (context, url) => LoadingIndicator(),
                        imageUrl: favLine.item.image ?? "",
                        errorWidget: (context, url, error) => GestureDetector(
                              onTap: () {
                                UI.pushReplaceAll(
                                    context, Routes.home); //* adding navigation
                              },
                              child: Center(
                                  child: Image.asset(
                                'assets/images/beautyLogo.png',
                                scale: 10,
                              )),
                            )),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Spacer(),
                        Text(favLine?.item?.name?.localized(context) ?? '',
                            maxLines: 1,
                            overflow: TextOverflow.clip,
                            style: TextStyle(fontSize: 20)),
                        Text(
                          favLine?.item?.description?.localized(context) ?? '',
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        Spacer(),
                        Text(
                            "${(num.parse(favLine?.item?.price)).toStringAsFixed(2)}" +
                                "  ",
                            style: TextStyle(
                                fontSize: 15,
                                color: AppColors.accentText,
                                fontWeight: FontWeight.bold)),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: IconButton(
                      icon: Icon(Icons.favorite),
                      onPressed: () {
                        mainModel.removeFromFavourites(context, favLine);
                      },
                      color: AppColors.accentText,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded buildEmpty(AppLocalizations locale) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.remove_shopping_cart),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Center(
                child: Text(locale.get(
                        "There is no favourites for you \n Start make it now") ??
                    "There is no favourites for you \n Start make it now"),
              ),
            )
          ],
        ),
      ),
    );
  }

  Expanded buildError(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Expanded(
      child: Center(
        child: Text(locale.get("Error") ?? "Error"),
      ),
    );
  }

  Expanded buildLoading() {
    return Expanded(
        child: Center(
            child: CircularProgressIndicator(
      color: AppColors.accentText,
    )));
  }

  Widget appBar(BuildContext context, AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
              onTap: () => Navigator.pop(context),
              child: Container(
                  child: Icon(Icons.arrow_back_ios,
                      size: 28, color: Colors.black))),
          Text(
            locale.get('Favorites') ?? 'Favorites',
            style: TextStyle(
              fontFamily: 'Josefin Sans',
              fontSize: 25,
              color: const Color(0xff313131),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
          Container(width: 28)
        ],
      ),
    );
  }

  Widget logo(context) {
    return GestureDetector(
      onTap: () {
        UI.pushReplaceAll(context, Routes.home); //* adding navigation
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 5,
            left: 20,
          ),
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
}
