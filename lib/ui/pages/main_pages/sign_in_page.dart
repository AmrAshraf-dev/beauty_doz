import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/main_pages_models/signIn_page_model.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/router.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_up_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/privacy-policy.page.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/text_fields/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ui_utils/ui_utils.dart';
import 'dart:io' show Platform;
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: BaseWidget<SignInPageModel>(
              model: SignInPageModel(
                  auth: Provider.of(context),
                  locale: AppLocalizations.of(context)),
              builder: (context, model, child) {
                return ListView(
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        width: 160,
                        height: 120.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: const AssetImage(
                                'assets/images/beautyLogo.png'),
                            // fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    signInForm(context, locale, model),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            locale.get("or continue using social media"),
                          ),
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
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  signInForm(
      BuildContext context, AppLocalizations local, SignInPageModel model) {
    final locale = AppLocalizations.of(context);
    return Form(
      key: model.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: ScreenUtil.screenWidthDp * 0.9,
              child: Align(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ' ' + local.get('Email address'),
                      style: TextStyle(fontSize: 18),
                    ),
                    CustomTextFormField(
                      controller: model.emailController,
                      color: AppColors.secondaryElement,

                      hint: local.get('Email address'),
                      keyboardType: TextInputType.emailAddress,
                      // icon: Icon(Icons.alternate_email, size: 28.0),
                      validator: (value) =>
                          model.emailValidator(value, context),
                    ),
                    Text(
                      ' ' + local.get('Password'),
                      style: TextStyle(fontSize: 18),
                    ),
                    CustomTextFormField(
                      hint: local.get('Password'),
                      keyboardType: TextInputType.emailAddress,
                      secure: true,
                      controller: model.passwordController,
                      validator: (value) =>
                          model.passwordValidator(value, context),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          model.resetPasswordPage(context);
                        },
                        child: Text(
                          locale.get("Forgot password ?"),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                    signInButton(context, local, model),
                  ],
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: SignInWithAppleButton(
            //     height: 45,
            //     onPressed: () async {
            //       await model.signInWithApple(context);

            //       // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
            //       // after they have been validated with Apple (see `Integration` section for more information on how to do this)
            //     },
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    local.get("By signing in, you agree to our"),
                    overflow: TextOverflow.clip,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    child: Text(
                      local.get("Privacy Policy"),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.accentText,
                      ),
                    ),
                    onTap: () {
                      UI.push(context, PrivacyPolicy());
                    },
                  ),
                ],
              ),
            ),
            Center(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: locale.get('New User ?'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                TextSpan(text: '   '),
                TextSpan(
                  text: locale.get('New Account'),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.accentText,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => push(context, const SignUpPage()),
                ),
              ])),
            )
          ],
        ),
      ),
    );
  }

  signInButton(
      BuildContext context, AppLocalizations local, SignInPageModel model) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedContainer(
        width: model.busy ? 80 : 350,
        height: 45,
        duration: Duration(milliseconds: 400),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(model.busy ? 28 : 10.0),
          color: model.busy
              ? AppColors.secondaryElement.withOpacity(.5)
              : AppColors.secondaryElement,
        ),
        child: model.busy
            ? LoadingIndicator()
            : FlatButton(
                onPressed: () => model.signIn(context),
                padding: EdgeInsets.all(0),
                child: Text(local.get('Sign In'),
                    style:
                        TextStyle(fontSize: 16, color: AppColors.primaryText)),
              ),
      ),
    );
  }
}
