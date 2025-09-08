import 'dart:async';
import 'dart:io';

import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/welcome_screen.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/category/category_service.dart';
import 'package:beautydoz/core/services/homePageService/home_page_service.dart';
import 'package:beautydoz/core/services/init/init_services.dart';
import 'package:beautydoz/core/services/notification/notification_service.dart';
import 'package:beautydoz/core/services/preference/preference.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/choose_language_page.dart';
import 'package:beautydoz/ui/pages/main_pages/delivery_boy_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/page_models/app_language_model.dart';
import '../../../core/page_models/theme_provider.dart';
import '../../../core/services/localization/localization.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool navigating = false;
  bool loading = true;
  bool online = true;
  StreamSubscription connectivitySubscription;

  @override
  void initState() {
    super.initState();

    locator<NotificationServices>().init(context);
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<AppLanguageModel>(context, listen: false).fetchLocale();

      // await Provider.of<NotificationServices>(context, listen: false).init();

      if (!locator<AuthenticationService>().userLoged) {
        try {
          await Provider.of<AuthenticationService>(context, listen: false)
              .getUserToken(context, 'MAC ADDRESS');
          // await locator<AuthenticationService>()

          Provider.of<CartService>(context, listen: false)
              .setState(state: NotifierState.idle, notifyListener: false);
        } catch (e) {
          Logger().e('error in  method $e');
        }
      } else {
        try {
          Provider.of<InitService>(context, listen: false)
              .initServices(context);
        } catch (e) {
          Logger().e('error in  method $e');
        }
      }

      if (Preference.getBool(PrefKeys.firstLaunch) == null) {
        UI.push(context, ChooseLanguagePage(), replace: true);
      } else if (Preference.getBool(PrefKeys.loggedIn) == null &&
          locator<AuthenticationService>().userLoged) {
        locator<AuthenticationService>().signOut;
        Preference.setBool(PrefKeys.loggedIn, false);
      }

      if (locator<AuthenticationService>().user != null &&
          locator<AuthenticationService>().user.user.userType == 'delivery') {
        UI.push(context, DeliveryBoyPage(), replace: true);
      } else {
        UI.pushReplaceAll(context, Routes.home);
      }
    });
  }

  @override
  void dispose() {
    connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        color: Colors.black,
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/beautyBlack.png',
              width: ScreenUtil.screenWidthDp / 2,
            ),
            Positioned(
              bottom: 1,
              child: Text(
                'Copyright@2020 beautydoz.com \n           All rights reserved.',
                style: TextStyle(
                  fontFamily: 'Josefin Sans',
                  fontSize: 12,
                  color: const Color(0xff979292),
                  letterSpacing: 0.431,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }

  offlineWidget(
      BuildContext context, AppLocalizations locale, ThemeProvider theme) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FloatingWidget(
          child: Icon(
            Icons.portable_wifi_off,
          ),
        ),
        Text(
          locale.get('Error connecting to the network'),
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 10),
        // NormalButton(height: 39, width: 190, text: 'try again', onPressed: () => navigate(context)),
      ],
    );
  }

  loadingWidget(ThemeProvider theme) {
    return Image.asset(
      "assets/images/logo.png",
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.height * 0.4,
    );
  }
}

class WelcomeScreensPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  PageController pageController = PageController();
  WelcomeScreensPageModel(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state);
}
