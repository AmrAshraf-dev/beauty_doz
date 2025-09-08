import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/home_page_items.dart';
import 'package:beautydoz/core/page_models/secondary_pages/banner_item_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/drawer.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/drawer/home_drawer.dart';
import 'package:beautydoz/ui/pages/secondary_pages/sort_dialog.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/items_list_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class BannerItemsPage extends StatelessWidget {
  final Banners banner;
  BannerItemsPage({this.banner});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<BannerItemsPageModel>(
          initState: (m) => WidgetsBinding.instance
              .addPostFrameCallback((_) => m.getBannerItems(
                    context,
                  )),
          model: BannerItemsPageModel(
              api: Provider.of<Api>(context),
              auth: Provider.of(context),
              cartService: Provider.of(context),
              favouriteService: Provider.of(context),
              locale: locale,
              banner: banner),
          builder: (context, model, child) {
            return Scaffold(
              key: locator<DrawerService>().bannerScaffoldKey,
              endDrawer: HomeDrawer(),
              backgroundColor: Theme.of(context).backgroundColor,
              appBar: PreferredSize(
                child: NewAppBar(
                  title: banner.title.localized(context),
                  drawer: true,
                  returnBtn: false,
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
                              print(param);

                              model.getBannerItems(
                                context,
                              );
                            }
                          });
                        },
                        child: Icon(
                          Icons.filter_list_alt,
                          size: 26,
                        ))
                  ],
                  onLanguageChanged: () => model.setState(),
                ),
                preferredSize: Size(ScreenUtil.screenWidthDp, 80),
              ),
              body: Container(
                height: ScreenUtil.screenHeightDp,
                width: ScreenUtil.screenWidthDp,
                child: Column(children: <Widget>[
                  bannerItems(context, model),
                ]),
              ),
            );
          }),
    );
  }

  Widget logo(context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context); //* adding navigation
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
      ),
    );
  }

  Widget bannerItems(BuildContext context, BannerItemsPageModel model) {
    final locale = AppLocalizations.of(context);
    return model.busy
        ? Expanded(
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.accentText,
              ),
            ),
          )
        : model.items == null || model.items.isEmpty
            ? Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.remove_shopping_cart),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                          locale.get("There is no Items in this banner") ??
                              "There is no Items in this banner"),
                    )
                  ],
                ),
              )
            : PaginatedItemsWidget(
                items: model.items,
                refreshController: model.refreshController,
                onLoad: () => model.onload(context),
                onRefresh: () => model.onRefresh(context),
                enablePullUp: true,
                enablePullDown: true,
              );
  }
}
