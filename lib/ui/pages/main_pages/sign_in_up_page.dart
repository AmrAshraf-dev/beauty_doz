import 'dart:io';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/main_pages_models/signIn_page_model.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_in_page.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_up_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/privacy-policy.page.dart';
import 'package:beautydoz/ui/shared/styles/borders.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ui_utils/ui_utils.dart';

class SignInUp extends StatelessWidget {
  const SignInUp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: BaseWidget<SignInPageModel>(
            model: SignInPageModel(
                auth: Provider.of(context),
                locale: AppLocalizations.of(context)),
            builder: (context, model, child) {
              return Container(
                width: ScreenUtil.screenWidthDp,
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/beautyLogo.png', width: 100),
                        SizedBox(height: 10),
                        Text(
                          local.get('get started'),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 10),
                        signUpButton(context, local),
                        signInButton(context, local),
                        SizedBox(height: 40),
                        Text(
                          local.get("or continue using social media"),
                        ),
                        if (Platform.isIOS) ...[
                          Container(
                            width: ScreenUtil.screenWidthDp * 0.9,
                            margin: const EdgeInsets.all(8.0),
                            child: SignInWithAppleButton(
                              height: 50,
                              onPressed: () async {
                                await model.signInWithApple(context);

                                // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
                                // after they have been validated with Apple (see `Integration` section for more information on how to do this)
                              },
                            ),
                          )
                        ],
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GoogleAuthButton(
                            style: AuthButtonStyle(
                              height: 50,
                              width: ScreenUtil.screenWidthDp * 0.9,
                            ),
                            onPressed: () async {
                              await model.signInWithGoogle(context);
                            },
                            darkMode: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FacebookAuthButton(
                            style: AuthButtonStyle(
                              height: 50,
                              width: ScreenUtil.screenWidthDp * 0.9,
                            ),
                            onPressed: () async {
                              await model.signInWithFacbook(context);
                            },
                            darkMode: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                local.get("By signing in, you agree to our"),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              InkWell(
                                child: Text(
                                  local.get("Privacy Policy"),
                                  style: TextStyle(
                                      color: AppColors.accentText,
                                      decoration: TextDecoration.underline),
                                ),
                                onTap: () {
                                  UI.push(context, PrivacyPolicy());
                                },
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              );
            }),
      ),
    );
  }

  signUpButton(BuildContext context, AppLocalizations local) {
    return Container(
      width: 233,
      height: 52,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: const Color(0xffdbaa44),
        boxShadow: [
          BoxShadow(
            color: const Color(0x99dbaa44),
            offset: Offset(0, 0),
            blurRadius: 10,
          ),
        ],
      ),
      child: FlatButton(
        onPressed: () => UI.push(context, SignUpPage()),
        padding: EdgeInsets.all(0),
        color: AppColors.secondaryElement,
        child: Text(local.get('Sign Up') ?? 'Sign Up',
            style: TextStyle(fontSize: 16, color: const Color(0xffffffff))),
        shape: RoundedRectangleBorder(
            side: Borders.primaryBorder,
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }

  signInButton(BuildContext context, AppLocalizations local) {
    return Container(
      width: 233,
      height: 52,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
      ),
      child: FlatButton(
        onPressed: () => UI.push(context, SignInPage()),
        padding: EdgeInsets.all(0),
        // color: AppColors.secondaryElement,
        child: Text(local.get('Log In') ?? 'Log In',
            style: TextStyle(fontSize: 16, color: AppColors.accentText)),
        shape: RoundedRectangleBorder(
            side: Borders.primaryBorder,
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}
