import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/models/welcome_screen.dart';
import '../../../core/services/api/api.dart';
import '../../../core/services/api/http_api.dart';
import '../../../core/services/auth/authentication_service.dart';
import '../../../core/services/localization/localization.dart';
import '../../routes/routes.dart';
import '../../shared/styles/colors.dart';

class OnBoradingScreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BaseWidget<OnBoradingScreensModel>(
      model: OnBoradingScreensModel(
          api: Provider.of<Api>(context),
          auth: Provider.of(context),
          context: context),
      builder: (ctx, model, _) => Scaffold(
        backgroundColor: Theme.of(ctx).backgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: model.busy
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.accentText),
                )
              : model.hasError
                  ? Center(
                      child: Text("Error"),
                    )
                  : Column(
                      children: [
                        Expanded(
                          child: PageView.builder(
                              controller: model.pageController,
                              onPageChanged: (index) {
                                model.pageIndex = index;
                                model.setState();
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: model?.screens?.length ?? 0,
                              itemBuilder: (context, index) {
                                return PagesForOnboarding(
                                  image: model.screens[index].image,
                                  header: model.screens[index].title
                                      .localized(context),
                                  description: model.screens[index].body
                                      .localized(context),
                                );
                              }),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // width: ScreenUtil.screenWidth * .1,
                                height: ScreenUtil.screenHeightDp * .07,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: AppColors.secondaryElement),
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FlatButton(
                                    onPressed: () {
                                      UI.push(context, Routes.signInUp,
                                          replace: true);
                                    },
                                    padding: EdgeInsets.all(0),
                                    child: Text(
                                        locale.get('Register') ?? 'Register',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppColors.primaryText)),
                                  ),
                                ),
                              ),
                              Container(
                                width: ScreenUtil.screenWidth * .1,
                                height: ScreenUtil.screenHeightDp * .07,
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: AppColors.secondaryElement,
                                ),
                                child: FlatButton(
                                  onPressed: () {
                                    if (model.pageIndex ==
                                        model.screens.length - 1) {
                                      UI.push(context, Routes.home);
                                    } else {
                                      double ind =
                                          model.pageIndex.toDouble() + 1;
                                      int indInt = model.pageIndex + 1;
                                      print(ind);
                                      model.pageController.animateToPage(indInt,
                                          duration: Duration(milliseconds: 200),
                                          curve: Curves.easeIn);

                                      model.setState();
                                    }
                                  },
                                  padding: EdgeInsets.all(0),
                                  child:
                                      Text(locale.get('Continue') ?? 'Continue',
                                          style: TextStyle(
                                            fontSize: 16,
                                          )),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
        ),
      ),
    );
  }
}

class PagesForOnboarding extends StatelessWidget {
  final image;
  final String header;
  final String description;

  PagesForOnboarding({this.header, this.description, this.image});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              height: ScreenUtil.screenHeightDp * 0.5,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            header ?? locale.get("We have the best dentists"),
            style: TextStyle(fontSize: 19),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            description,
            // style: TextStyles.textInOnBoarding,
          )
        ],
      ),
    );
  }
}

class OnBoradingScreensModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  OnBoradingScreensModel(
      {NotifierState state, this.api, this.auth, this.context})
      : super(state: state) {
    getWelcomeScreens();
  }

  int pageIndex = 0;

  List<WelcomeScreen> screens;

  PageController pageController = PageController();

  void getWelcomeScreens() async {
    setBusy();
    screens = await api.getWelcomeScreens(context);
    screens != null ? setIdle() : setError();
  }
}
