import 'dart:io';

import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/main_pages_models/signup_page_model.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/router.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_in_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/privacy-policy.page.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/text_fields/custom_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localee = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: SafeArea(
          child: BaseWidget<SignUpPageModel>(
              model:
                  SignUpPageModel(auth: Provider.of(context), context: context),
              builder: (context, model, child) {
                return SingleChildScrollView(
                  child: Container(
                      height: ScreenUtil.screenHeightDp * 0.9,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            width: 160,
                            height: 120.0,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: const AssetImage(
                                    'assets/images/beautyLogo.png'),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          signUpForm(context, localee, model),
                        ],
                      )),
                );
              }),
        ),
      ),
    );
  }

  signUpForm(
      BuildContext context, AppLocalizations locale, SignUpPageModel model) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: model.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              ' ' + locale.get('Name'),
            ),
            CustomTextFormField(
              controller: model.userName,
              hint: locale.get('Name'),
              validator: (value) => model.namelValidator(value, context),
            ),
            SizedBox(height: 7),
            Text(
              ' ' + locale.get('Email address'),
            ),
            CustomTextFormField(
              controller: model.email,
              hint: locale.get('Email address'),
              keyboardType: TextInputType.emailAddress,
              // icon: Icon(Icons.alternate_email, size: 28.0),
              validator: (value) => model.emailValidator(value, context),
            ),
            SizedBox(height: 7),
            Text(
              ' ' + locale.get('mobile number'),
            ),
            InternationalPhoneNumberInput(
              onInputChanged: (PhoneNumber number) {
                // model.phone.text =
                //     number.phoneNumber.substring(0, number.dialCode.length);
                model.extinsion.text = number.dialCode;

                String currncy = 'KWD';
                switch (number.isoCode) {
                  case 'SA':
                    currncy = 'SAR';
                    break;
                  case 'OM':
                    currncy = 'OMR';
                    break;
                  case 'BH':
                    currncy = 'BHD';
                    break;
                  case 'AE':
                    currncy = 'AED';
                    break;
                  case 'QA':
                    currncy = 'QAR';
                    break;
                  default:
                    currncy = 'KWD';
                    break;
                }
                locator<CurrencyService>()
                    .selectCurrency(currncy.toLowerCase());
                model.setState();
              },
              selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  setSelectorButtonAsPrefixIcon: true),
              ignoreBlank: true,
              errorMessage: locale.get('Invalid Phone Number'),
              countries: ['KW', 'SA', 'OM', 'BH', 'AE', 'QA'],
              countrySelectorScrollControlled: true,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              textFieldController: model.phone,
              cursorColor: Theme.of(context).textTheme.bodyText1.color,
              inputDecoration: InputDecoration(
                hintStyle: TextStyle(fontSize: 16),
                // helperStyle: TextStyle(fontSize: 16, color: color),
                // labelStyle: TextStyle(fontSize: 16, color: Colors.white70),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 16, horizontal: 10),
                border: InputBorder.none,
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                      width: 0.4,
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                      width: 0.4,
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(width: 0.4, color: Colors.red),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                      width: 0.4,
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(
                      width: 0.4,
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
              ),
              formatInput: false,
              keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
              inputBorder: OutlineInputBorder(),
            ),
            // Row(
            //   children: [
            //     model.fetchingCountries
            //         ? Center(
            //             child: CircularProgressIndicator(
            //               color: AppColors.accentText,
            //             ),
            //           )
            //         : dropdownButton(model, locale),
            //     SizedBox(
            //       width: 10,
            //     ),
            //     Expanded(
            //       child: CustomTextFormField(
            //         validator: (val) => model.phoneValidator(val, context),
            //         hint: locale.get('Phone') ?? 'Phone',
            //         controller: model.phone,
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 7),
            Text(
              ' ' + locale.get('Password'),
              style: TextStyle(color: AppColors.secondaryText, fontSize: 18),
            ),
            CustomTextFormField(
              hint: locale.get('Password'),
              controller: model.password,
              secure: true,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => model.passwordValidator(value, context),
            ),
            signUpButton(context, locale, model),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    locale.get("By signing in, you agree to our"),
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  InkWell(
                    child: Text(
                      locale.get("Privacy Policy"),
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
            Center(
              child: RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: locale.get('Already Have Account ?'),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                TextSpan(text: '   '),
                TextSpan(
                  text: locale.get('Login'),
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.accentText,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => push(context, const SignInPage()),
                ),
              ])),
            )
          ],
        ),
      ),
    );
  }

  Widget dropdownButton(SignUpPageModel model, AppLocalizations locale) {
    var items = model.countries == null
        ? [965].map((val) {
            return new DropdownMenuItem<int>(
              value: val,
              child: new Text(val.toString()),
            );
          }).toList()
        : model.countries
            .map((e) => new DropdownMenuItem<int>(
                  value: int.tryParse(e.countryCode),
                  child: new Text(e.countryCode),
                ))
            .toList();

    return new DropdownButton(
      items: items,
      hint: model.selectedExtension == null
          ? Text(
              locale.get("Extension") ?? "Extension",
              style: TextStyle(color: Colors.white),
            )
          : Text(
              model.selectedExtension.toString(),
              style: TextStyle(
                fontFamily: 'Josefin Sans',
                fontSize: 20,
                color: Colors.white,
              ),
            ),
      onChanged: (newVal) {
        model.selectedExtension = newVal;
        model.setState();
      },
    );
  }

  signUpButton(
      BuildContext context, AppLocalizations locale, SignUpPageModel model) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedContainer(
        width: 233,
        height: 52,
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: AppColors.primaryBackground,
        ),
        child: model.busy
            ? LoadingIndicator()
            : FlatButton(
                color: AppColors.ternaryBackground,
                onPressed: () =>
                    model.busy ? {} : model.onPressSignup(context, locale),
                padding: EdgeInsets.all(0),
                child:
                    Text(locale.get('Sign Up'), style: TextStyle(fontSize: 16)),
              ),
      ),
    );
  }
}
