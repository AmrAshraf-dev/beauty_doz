import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/taps/profile_page_model.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/pages/secondary_pages/privacy-policy.page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/recovery_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<ProfilePageModel>(
          model: ProfilePageModel(
            auth: Provider.of(context),
          ),
          builder: (context, model, _) {
            return SafeArea(
              child: Container(
                height: ScreenUtil.screenHeightDp,
                width: ScreenUtil.screenWidthDp,
                color: AppColors.primaryBackground,
                child: Column(
                  children: <Widget>[
                    header(context, locale, model),
                    pageTiles(context, locale, model)
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  header(BuildContext context, AppLocalizations local, ProfilePageModel model) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
         GestureDetector(
             onTap: (){
                UI.push(context, Routes.home,replace : true); //* adding navigation
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
          Text(
            local.get('Account') ?? 'Account',
            style: TextStyle(
              fontFamily: 'Josefin Sans',
              fontSize: 25,
              color: const Color(0xff313131),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
          InkWell(
              onTap: () {
                print("Sigining out ...");
                model.signOut(context);
              },
              child: Icon(
                Icons.power_settings_new,
                color: AppColors.accentText,
                size: 26,
              ))
          // Container(width: 34.5)
        ],
      ),
    );
  }

  pageTiles(
      BuildContext context, AppLocalizations local, ProfilePageModel model) {
    final locale = AppLocalizations.of(context);
    return Expanded(
        child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        child: Column(
          children: <Widget>[
            tile(
                context: context,
                local: local,
                model: model,
                leading: SvgPicture.string(SvgIcon.svgUser,
                    color: AppColors.accentText),
                titel: local.get('My profile') ?? "My Profile",
                onPressed: () => model.profileRoute(context)),
            tile(
                context: context,
                local: local,
                model: model,
                leading: Icon(Icons.description,
                    color: AppColors.accentText, size: 30),
                titel: locale.get('My orders') ?? "My orders",
                onPressed: () => model.orderRoute(context)),
            tile(
                context: context,
                local: local,
                model: model,
                leading:
                    Icon(Icons.favorite, color: AppColors.accentText, size: 30),
                titel: locale.get('Favorites') ?? 'Favorites',
                onPressed: () => model.favouriteRoute(context)),
            tile(
                context: context,
                local: local,
                model: model,
                leading: SvgPicture.string(SvgIcon.svgLocation,
                    color: AppColors.accentText),
                titel: locale.get('Addresses') ?? "Addresses",
                onPressed: () => model.addressRoute(context)),
            tile(
                context: context,
                local: local,
                model: model,
                leading: SvgPicture.string(SvgIcon.svgLanguage,
                    color: AppColors.accentText),
                titel: locale.get('Language') ?? "Language",
                onPressed: () => model.languageRoute(context)),
            tile(
                context: context,
                local: local,
                model: model,
                leading: Icon(Icons.info_outline,
                    color: AppColors.accentText, size: 30),
                titel: locale.get('About') ?? "About",
                onPressed: () => model.aboutRoute(context)),
            tile(
                context: context,
                local: local,
                model: model,
                leading: SvgPicture.string(SvgIcon.svgEmail,
                    color: AppColors.accentText),
                titel: locale.get('Contact Us') ?? "Contact Us",
                onPressed: () => model.contactRoute(context)),
            tile(
                context: context,
                local: local,
                model: model,
                leading: Icon(
                  Icons.assignment_return,
                  color: AppColors.accentText,
                ),
                titel: locale.get('Returns & Exchange Policy') ??
                    "Returns & Exchange Policy",
                onPressed: () => UI.push(context, RecoveryPage())),
            tile(
                context: context,
                local: local,
                model: model,
                leading: Icon(
                  Icons.privacy_tip,
                  color: AppColors.accentText,
                ),
                titel: locale.get('Privacy Policy'),
                onPressed: () => UI.push(context, PrivacyPolicy())),
          ],
        ),
      ),
    ));
  }

  tile(
      {BuildContext context,
      AppLocalizations local,
      ProfilePageModel model,
      Widget leading,
      String titel,
      Function onPressed}) {
    return InkWell(
      onTap: () => onPressed(),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
              margin: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
              padding: EdgeInsets.all(10),
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Color.fromARGB(60, 219, 170, 78)),
              child: leading),
          Text(titel, style: TextStyle(fontSize: 19)),
          Expanded(
              child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Icon(Icons.arrow_forward_ios))),
        ],
      ),
    );
  }
}
