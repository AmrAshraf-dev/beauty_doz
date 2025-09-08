import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/main_pages_models/reset_form_page_model.dart';
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

class ResetFormPage extends StatelessWidget {
  final String email;
  ResetFormPage({this.email});
  @override
  Widget build(BuildContext context) {
    return FocusWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: BaseWidget<ResetFormPageModel>(
            model: ResetFormPageModel(
                email: email,
                api: Provider.of<Api>(context),
                auth: Provider.of(context)),
            builder: (context, model, child) {
              final locale = AppLocalizations.of(context);
              return SingleChildScrollView(
                child: Container(
                    height: ScreenUtil.screenHeightDp,
                    width: ScreenUtil.screenWidthDp,
                    child: SafeArea(
                      child: Column(
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
                          resetForm(context, locale, model),
                        ],
                      ),
                    )),
              );
            }),
      ),
    );
  }

  resetForm(
      BuildContext context, AppLocalizations local, ResetFormPageModel model) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Form(
        key: model.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              local.get('Code') ?? 'Code',
              style: TextStyle(color: AppColors.accentText, fontSize: 18),
            ),
            CustomTextFormField(
              hint: local.get('Code') ?? "Code",
              keyboardType: TextInputType.emailAddress,
              color: AppColors.secondaryElement,
              controller: model.codeController,
              validator: (value) => value.length > 3
                  ? null
                  : local.get('Code must be exceed 3 characters') ??
                      "Code must be exceed 3 characters",
            ),
            Text(
              local.get('New Password') ?? 'New Password',
              style: TextStyle(color: AppColors.accentText, fontSize: 18),
            ),
            CustomTextFormField(
              hint: local.get('New Password') ?? "New Password",
              keyboardType: TextInputType.emailAddress,
              secure: true,
              color: AppColors.secondaryElement,
              controller: model.newPasswordControlelr,
              validator: (value) => model.passwordValidator(value, context),
            ),
            Text(
              local.get('Retype new password') ?? 'Retype new password',
              style: TextStyle(color: AppColors.accentText, fontSize: 18),
            ),
            CustomTextFormField(
              hint: local.get('Retype new password') ?? "Retype new password",
              keyboardType: TextInputType.emailAddress,
              secure: true,
              color: AppColors.secondaryElement,
              controller: model.retypeNewPasswordControlelr,
              validator: (value) => model.passwordValidator(value, context),
            ),
            SizedBox(height: 10),
            sendButtom(context, local, model)
          ],
        ),
      ),
    );
  }

  sendButtom(
      BuildContext context, AppLocalizations local, ResetFormPageModel model) {
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
                  model.resetPassword(context);
                },
                padding: EdgeInsets.all(0),
                child: Text(local.get('Send') ?? 'Send',
                    style:
                        TextStyle(fontSize: 16, color: AppColors.primaryText)),
              ),
      ),
    );
  }
}
