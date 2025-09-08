import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/main_pages_models/reset_password_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/text_fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class ResetPasswordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: BaseWidget<ResetPasswordPageModel>(
            // initState: (m) => WidgetsBinding.instance
            //     .addPostFrameCallback((_) => m.initializeProfileData()),
            model: ResetPasswordPageModel(
                api: Provider.of<Api>(context), auth: Provider.of(context)),
            builder: (context, model, child) {
              final locale = AppLocalizations.of(context);
              return Container(
                  height: ScreenUtil.screenHeightDp,
                  width: ScreenUtil.screenWidthDp,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                          width: 160.7,
                          height: 120.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: const AssetImage(
                                  'assets/images/beautyLogo.png'),
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                            child: resetPassword(context, locale, model)),
                      ],
                    ),
                  ));
            }),
      ),
    );
  }

  resetPassword(BuildContext context, AppLocalizations local,
      ResetPasswordPageModel model) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: model.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
                local.get(
                    'Enter your registerd email to send reset code to you'),
                style: Theme.of(context).textTheme.headline6),
            const SizedBox(
              height: 40,
            ),
            Text(
              local.get('Email') ?? 'Email',
              style: TextStyle(color: AppColors.accentText, fontSize: 18),
            ),
            CustomTextFormField(
              hint: local.get('Email') ?? "Email",
              keyboardType: TextInputType.emailAddress,
              color: AppColors.secondaryElement,
              controller: model.emailController,
              validator: (value) => model.emailValidator(value, context),
            ),
            SizedBox(height: 10),
            sendButtom(context, local, model)
          ],
        ),
      ),
    );
  }

  sendButtom(BuildContext context, AppLocalizations local,
      ResetPasswordPageModel model) {
    return Align(
      alignment: Alignment.center,
      child: AnimatedContainer(
        width: model.busy ? 80 : 233,
        height: 52,
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
                onPressed: () {
                  model.gotoResetForm(context);
                },
                padding: EdgeInsets.all(0),
                child: Text(local.get('Send') ?? 'Send',
                    style: TextStyle(fontSize: 16)),
              ),
      ),
    );
  }
}
