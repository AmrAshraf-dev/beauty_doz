import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/categories.dart';
import 'package:beautydoz/core/page_models/secondary_pages/category_item_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/drawer.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/drawer/home_drawer.dart';
import 'package:beautydoz/ui/pages/secondary_pages/sort_dialog.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../widgets/items_list_widget.dart';

class CategoryItemPage extends StatelessWidget {
  final Categories category;

  CategoryItemPage({this.category});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: BaseWidget<CategoryItemPageModel>(
          initState: (m) => WidgetsBinding.instance
              .addPostFrameCallback((_) => m.getCategoryItems(
                    context,
                  )),
          model: CategoryItemPageModel(
              context: context,
              auth: Provider.of(context),
              cartService: Provider.of(context),
              favouriteService: Provider.of(context),
              api: Provider.of<Api>(context),
              locale: locale,
              category: category),
          builder: (context, model, child) {
            return Scaffold(
              key: locator<DrawerService>().categoriesScaffoldKey,
              endDrawer: HomeDrawer(),
              appBar: PreferredSize(
                child: NewAppBar(
                  title: category.name.localized(context),
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
                              print(param);

                              model.getCategoryItems(
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
                ),
                preferredSize: Size(ScreenUtil.screenWidthDp, 80),
              ),
              body: Container(
                  width: ScreenUtil.screenWidthDp,
                  height: ScreenUtil.screenHeightDp,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        items(context, model),
                      ])),
            );
          }),
    );
  }

  Widget logo(context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          UI.push(context, Routes.home, replace: true); //* adding navigation
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Container(
              width: 57.5,
              height: 38.5,
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

  Widget items(BuildContext context, CategoryItemPageModel model) {
    final locale = AppLocalizations.of(context);
    return model.busy
        ? Expanded(
            child: Center(
                child: CircularProgressIndicator(
            color: AppColors.accentText,
          )))
        : model.items == null || model.items.isEmpty
            ? Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.remove_shopping_cart),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(locale.get("There is no items ") ??
                            "There is no items "),
                      )
                    ],
                  ),
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
