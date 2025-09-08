import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/drawer.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/drawer/home_drawer.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/page_models/main_pages_models/home_page/home_page_model.dart';
import 'package:fancy_bar/fancy_bar.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: BaseWidget<HomePageModel>(
            model: HomePageModel(
                auth: Provider.of(context),
                api: Provider.of<Api>(context),
                categoryService: Provider.of(context),
                cartService: Provider.of(context),
                favouriteService: Provider.of(context)),
            initState: (model) => WidgetsBinding.instance
                .addPostFrameCallback((_) => model.loadData(context)),
            builder: (context, model, child) {
              return Scaffold(
                resizeToAvoidBottomInset: true,
                key: locator<DrawerService>().homeScaffoldKey,
                endDrawer: HomeDrawer(),
                bottomNavigationBar: bottomNavBar(context, model),
                body: model.pages[model.currentPageIndex],
              );
            }),
      ),
    );
  }

  bottomNavBar(BuildContext context, HomePageModel model) {
    final locale = AppLocalizations.of(context);
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color:
                    Theme.of(context).colorScheme.onSecondary.withOpacity(0.4),
                spreadRadius: 0,
                blurRadius: 20),
          ],
        ),
        child: FancyBottomBar(
          selectedIndex: model.currentPageIndex,
          type: FancyType.FancyV1, // Fancy Bar Type
          items: [
            FancyItem(
                textColor: AppColors.accentText,
                title: locale.get('Home'),
                icon: Icon(Icons.home_outlined)),
            FancyItem(
                textColor: AppColors.accentText,
                title: locale.get('Brands'),
                icon: Icon(Icons.sell_outlined)),
            FancyItem(
              textColor: AppColors.accentText,
              title: locale.get('Items'),
              icon: Icon(Icons.dashboard_outlined),
            ),
            FancyItem(
                textColor: AppColors.accentText,
                title: locale.get('Cart'),
                icon: Stack(
                  children: [
                    SvgPicture.string(SvgIcon.svga724mf,
                        allowDrawingOutsideViewBox: true,
                        color: model.currentPageIndex == 3
                            ? AppColors.secondaryElement
                            : Colors.grey),
                    model.cartService != null &&
                            model.cartService.cart != null &&
                            model.cartService.cart.lines.length > 0
                        ? new Positioned(
                            right: 0,
                            top: 1,
                            child: new Container(
                              padding: EdgeInsets.all(1),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 12,
                                minHeight: 12,
                              ),
                              child: new Text(
                                model.cartService.cart.totalItems.toString(),
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        : SizedBox()
                  ],
                )),
          ],
          onItemSelected: (i) {
            model.changeTap(context, i);
          },
        ));
  }
}
