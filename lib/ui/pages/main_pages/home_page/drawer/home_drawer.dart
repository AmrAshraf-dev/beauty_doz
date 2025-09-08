import 'package:beautydoz/core/page_models/theme_provider.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/categories.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/home_page_model.dart';
import 'package:beautydoz/core/services/category/category_service.dart';
import 'package:beautydoz/core/services/drawer.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/choose_language_page.dart';
import 'package:beautydoz/ui/pages/main_pages/on_borading.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_in_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/my_orders_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/my_profile_screen.dart';
import 'package:beautydoz/ui/pages/secondary_pages/privacy-policy.page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/recovery_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/svg_icon.dart';
import 'package:day_night_switcher/day_night_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class HomeDrawer extends StatefulWidget {
  HomeDrawer({Key key}) : super(key: key);

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  @override
  void initState() {
    locator<CategoryService>().getCategories(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryService>(
      builder: (context, csmodel, child) {
        final locale = AppLocalizations.of(context);
        return Drawer(
          elevation: 9999,
          child: Container(
            height: ScreenUtil.screenHeightDp,
            width: ScreenUtil.screenWidthDp * 0.9,
            color: Theme.of(context).backgroundColor,
            child: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    header(context, locale),
                    ...pageTiles(context, csmodel),
                    // categories(context, csmodel),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  header(BuildContext context, AppLocalizations locale) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                UI.push(context, Routes.home,
                    replace: true); //* adding navigation
              },
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
            StreamBuilder<bool>(
                stream: locator<ThemeProvider>().isDark.stream,
                builder: (context, snapshot) {
                  return DayNightSwitcher(
                    isDarkModeEnabled: snapshot.data,
                    onStateChanged: (isDarkModeEnabled) {
                      locator<ThemeProvider>().switchTheme(isDarkModeEnabled);
                    },
                  );
                }),
            if (locator<AuthenticationService>().userLoged)
              InkWell(
                  onTap: () {
                    print("Sigining out ...");
                    locator<AuthenticationService>().signOut;
                    UI.pushReplaceAll(context, ChooseLanguagePage());
                  },
                  child: Icon(
                    Icons.power_settings_new,
                    color: AppColors.accentText,
                    size: 26,
                  ))
          ],
        ));
  }

  categories(BuildContext context, CategoryService model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: <Widget>[
          ...List.generate(model.categories?.length ?? 0, (index) {
            return categorieTile(
                context,
                model.categories[index].name.localized(context),
                model.categories[index]);
          }),
        ],
      ),
    );
  }

  Map<int, bool> expanded = {};

  categorieTile(BuildContext context, String text, Categories category) {
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: 200),
      elevation: 0,
      children: [
        ExpansionPanel(
          headerBuilder: (context, isExpanded) {
            return ListTile(
              title: Text(
                category.name?.localized(context) ?? '',
              ),
            );
          },
          body: Column(
              children: category.subCategories
                  .map((cat) => ListTile(
                        onTap: () =>
                            {UI.push(context, Routes.categoryItem(cat))},
                        title: Text(
                          cat.name?.localized(context) ?? '',
                          style: TextStyle(color: AppColors.accentText),
                        ),
                      ))
                  .toList()),
          isExpanded:
              expanded.containsKey(category.id) ? expanded[category.id] : false,
          canTapOnHeader: true,
        ),
      ],
      dividerColor: Colors.grey,
      expansionCallback: (panelIndex, isExpanded) {
        expanded[category.id] = !isExpanded;

        setState(() {});
        // _expanded = !_expanded;
        // model.setState();
      },
    );
  }

  bool _isExpanded = false;
  List<Widget> pageTiles(BuildContext context, model) {
    final locale = AppLocalizations.of(context);
    return <Widget>[
      ExpansionPanelList(
        animationDuration: Duration(milliseconds: 200),
        elevation: 0,
        children: [
          ExpansionPanel(
            headerBuilder: (context, isExpanded) {
              return tile(
                  leading: Icon(Icons.category, color: AppColors.accentText),
                  titel: locale.get('Categories'),
                  onPressed: () {
                    _isExpanded = !isExpanded;
                    setState(() {});
                  });
            },
            body: categories(context, model),
            isExpanded: _isExpanded,
            canTapOnHeader: false,
          ),
        ],
        dividerColor: Colors.grey,
        expansionCallback: (panelIndex, isExpanded) {
          _isExpanded = !isExpanded;
          setState(() {});
          // model.setState();
        },
      ),
      tile(
          leading:
              SvgPicture.string(SvgIcon.svgUser, color: AppColors.accentText),
          titel: locale.get('My profile') ?? "My Profile",
          onPressed: () => UI.push(
              context,
              locator<AuthenticationService>().userLoged
                  ? MyProfilePage()
                  : SignInPage())),
      tile(
          leading: Icon(Icons.description, color: AppColors.accentText),
          titel: locale.get('My orders') ?? "My orders",
          onPressed: () => UI.push(
              context,
              locator<AuthenticationService>().userLoged
                  ? MyOrderPage()
                  : SignInPage())),
      tile(
          leading: SvgPicture.string(SvgIcon.svgLocation,
              color: AppColors.accentText),
          titel: locale.get('Addresses'),
          onPressed: () => UI.push(
              context,
              locator<AuthenticationService>().userLoged
                  ? Routes.addresses
                  : SignInPage())),
      tile(
          leading: SvgPicture.string(SvgIcon.svgLanguage,
              color: AppColors.accentText),
          titel: locale.get('Language'),
          onPressed: () => UI.push(context, Routes.languages)),
      tile(
          leading: Icon(Icons.info_outline, color: AppColors.accentText),
          titel: locale.get('About'),
          onPressed: () => UI.push(context, Routes.about)),
      tile(
          leading:
              SvgPicture.string(SvgIcon.svgEmail, color: AppColors.accentText),
          titel: locale.get('Contact Us'),
          onPressed: () => UI.push(context, Routes.contact)),
      tile(
          leading: Icon(
            Icons.assignment_return,
            color: AppColors.accentText,
          ),
          titel: locale.get('Returns & Exchange Policy'),
          onPressed: () => UI.push(context, RecoveryPage())),
      tile(
          leading: Icon(
            Icons.privacy_tip,
            color: AppColors.accentText,
          ),
          titel: locale.get('Privacy Policy'),
          onPressed: () => UI.push(context, PrivacyPolicy())),
    ];
    ;
  }

  tile({Widget leading, String titel, Function onPressed}) {
    return ListTile(
      leading: leading,
      title: Text(titel),
      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      onTap: onPressed,
    );
  }
}
