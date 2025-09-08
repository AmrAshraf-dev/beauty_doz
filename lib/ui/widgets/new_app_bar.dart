import 'package:beautydoz/core/page_models/main_pages_models/home_page/home_page_model.dart';
import 'package:beautydoz/core/page_models/theme_provider.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/drawer.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/home_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class NewAppBar extends StatefulWidget {
  final String title;
  final bool returnBtn;
  final bool returnHome;
  final bool drawer;
  final Function() onLanguageChanged;
  final List<Widget> additionalWidgets;
  const NewAppBar(
      {Key key,
      this.title,
      this.returnBtn = true,
      this.drawer = true,
      this.returnHome = false,
      this.onLanguageChanged,
      this.additionalWidgets,
      Size preferredSize})
      : super(key: key);

  @override
  State<NewAppBar> createState() => _NewAppBarState();
}

class _NewAppBarState extends State<NewAppBar> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: AppBar(
        primary: true,
        elevation: 0,
        titleSpacing: 40,
        leading: widget.returnBtn
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                    onTap: () => !widget.returnHome
                        ? Navigator.of(context).pop()
                        : UI.pushReplaceAll(context, HomePage()),
                    child: Container(
                        child: Icon(Icons.arrow_back_ios,
                            size: 28,
                            color:
                                Theme.of(context).textTheme.bodyText1.color))),
              )
            : GestureDetector(
                onTap: () {
                  UI.push(context, Routes.home,
                      replace: true); //* adding navigation
                },
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 57.5,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.0),
                      image: DecorationImage(
                          image:
                              const AssetImage('assets/images/beautyLogo.png'),
                          fit: BoxFit.fitWidth),
                    ),
                  ),
                ),
              ),
        title: Text(locale.get(widget.title),
            style:
                TextStyle(color: Theme.of(context).textTheme.bodyText1.color)),
        actionsIconTheme: Theme.of(context).iconTheme,
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          if (widget.additionalWidgets != null &&
              widget.additionalWidgets.isNotEmpty)
            ...widget.additionalWidgets,
          if (widget.onLanguageChanged != null)
            DescribedFeatureOverlay(
              featureId: 'selectCountry',
              allowShowingDuplicate: true,
              tapTarget: Icon(Icons.language),
              backgroundColor: AppColors.accentText,
              contentLocation: ContentLocation.below,
              title: Text(locale.get('Select your country')),
              description: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: locator<CurrencyService>()
                      .getOtherCurrencies()
                      .map((curr) {
                    return getFlagIcon(context, '$curr.png', '$curr');
                  }).toList()),
              onComplete: () async {
                setState(() {});
                FeatureDiscovery.dismissAll(context);
                widget.onLanguageChanged();
                return true;
              },
              onOpen: () async {
                WidgetsBinding.instance
                    .addPostFrameCallback((Duration duration) {
                  return true;
                });
                print('The feature7 overlay is about to be displayed.');
                return true;
              },
              child: EnsureVisible(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: InkWell(
                    child: ClipOval(
                      clipBehavior: Clip.hardEdge,
                      child: Image.asset(
                        'assets/images/flags/${locator<CurrencyService>().selectedCurrency}.png',
                        fit: BoxFit.fill,
                        width: 36,
                        // height: 40,
                        alignment: Alignment.centerLeft,
                      ),
                    ),
                    onTap: () async {
                      FeatureDiscovery.discoverFeatures(
                        context,
                        const <String>{
                          'selectCountry',
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          if (widget.drawer)
            IconButton(
                icon: Icon(Icons.menu,
                    size: 30,
                    color: Theme.of(context).textTheme.bodyText1.color),
                onPressed: () {
                  final key = locator<DrawerService>().homeScaffoldKey;
                  key?.currentState?.openEndDrawer();
                  final brandsScaffoldKey =
                      locator<DrawerService>().brandsScaffoldKey;
                  brandsScaffoldKey?.currentState?.openEndDrawer();
                  final categoriesScaffoldKey =
                      locator<DrawerService>().categoriesScaffoldKey;
                  categoriesScaffoldKey?.currentState?.openEndDrawer();
                  final checkoutScaffoldKey =
                      locator<DrawerService>().checkoutScaffoldKey;
                  checkoutScaffoldKey?.currentState?.openEndDrawer();
                  final bannerScaffoldKey =
                      locator<DrawerService>().bannerScaffoldKey;
                  bannerScaffoldKey?.currentState?.openEndDrawer();
                }),
        ],
      ),
    );
  }

  Widget getFlagIcon(BuildContext context, String asset, String currency) {
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
          setState(() {});
          widget.onLanguageChanged();
          FeatureDiscovery.dismissAll(context);
        });
  }
}
