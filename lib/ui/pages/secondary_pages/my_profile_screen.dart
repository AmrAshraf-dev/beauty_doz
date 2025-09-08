import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/countries.dart';
import 'package:beautydoz/core/page_models/main_pages_models/change_password_dialog_model.dart';
import 'package:beautydoz/core/page_models/secondary_pages/my_profile_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class MyProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          child: NewAppBar(
            title: 'Profile',
            drawer: false,
            returnBtn: true,
            onLanguageChanged: null,
          ),
          preferredSize: Size(ScreenUtil.screenWidthDp, 80),
        ),
        body: BaseWidget<MyProfilePageModel>(
            initState: (m) => WidgetsBinding.instance
                .addPostFrameCallback((_) => m.getExtensions(context)),
            model: MyProfilePageModel(auth: Provider.of(context)),
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[userData(context, model, locale)],
                ),
              );
            }),
      ),
    );
  }

  userData(
      BuildContext context, MyProfilePageModel model, AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          // username
          Text(locale.get("NAME")),

          TextFormField(
            decoration: InputDecoration(
                hintText: locale.get('Username'),
                hintStyle:
                    TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            controller: model.nameController,
          ),

          // phone
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(locale.get("PHONE")),
          ),

          model.fetchingExtension
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.accentText))
              : model.countries != null
                  ? Row(
                      children: [
                        Expanded(
                          child: new DropdownButton(
                            items: model.countries.map((val) {
                              return new DropdownMenuItem<Countries>(
                                value: val,
                                child: new Text(
                                    "${val.name.localized(context)} ${val.countryCode}"),
                              );
                            }).toList(),
                            isDense: true,
                            isExpanded: true,
                            hint: model.selectedExtension == null
                                ? Text(locale.get("Extension"))
                                : Text(
                                    model.selectedExtension.toString(),
                                  ),
                            onChanged: (newVal) {
                              var countr = newVal as Countries;
                              model.selectedExtension = countr.countryCode;
                              model.setState();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: locale.get('Phone'),
                                hintStyle: TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w700)),
                            controller: model.phoneController,
                          ),
                        ),
                      ],
                    )
                  : Text(locale.get("Error")),

          // password
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(locale.get("PASSWORD")),
          ),

          Stack(
            children: <Widget>[
              TextFormField(
                obscureText: true,
                enabled: false,
                decoration: InputDecoration(
                    hintText: locale.get('Password'),
                    hintStyle:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
              Align(
                alignment: locale.locale.languageCode == 'en'
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: FlatButton(
                  child: Text(
                    locale.get('Change'),
                    style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 230, 201, 140)),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (c) => changePasswordDialog(context, locale));
                  },
                ),
              )
            ],
          ),

          // email
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(locale.get("EMAIL")),
          ),

          TextFormField(
            decoration: InputDecoration(
                hintText: locale.get('Email'),
                hintStyle:
                    TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
            controller: model.emailController,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: Color.fromRGBO(219, 170, 68, 1),
              onPressed: () {
                model.updateUserInfo(
                  context,
                );
              },
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(locale.get("SUBMIT"),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget changePasswordDialog(BuildContext context, AppLocalizations locale) {
    return BaseWidget<ChangePasswordDialogModel>(
      model: ChangePasswordDialogModel(
          api: Provider.of<Api>(context), auth: Provider.of(context)),
      builder: (context, model, child) => Dialog(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: model.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(Icons.close),
                    ),
                  ),
                  Text(locale.get("Current Password")),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: locale.get('Current Password'),
                        hintStyle: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    obscureText: true,
                    controller: model.currentPasswordController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(locale.get("New Password")),
                  ),
                  TextFormField(
                    validator: (value) =>
                        model.passwordValidator(value, context),
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: locale.get('New Password'),
                        hintStyle: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    controller: model.newPasswordController,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(locale.get("Retype New Password")),
                  ),
                  TextFormField(
                    validator: (value) =>
                        model.passwordValidator(value, context),
                    obscureText: true,
                    decoration: InputDecoration(
                        hintText: locale.get('Retype New Password'),
                        hintStyle: TextStyle(
                            fontSize: 13, fontWeight: FontWeight.w700)),
                    controller: model.retypeNewPassController,
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: AnimatedContainer(
                      width: model.busy ? 80 : 233,
                      height: 52,
                      duration: Duration(milliseconds: 400),
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(model.busy ? 28 : 10.0),
                        color: model.busy
                            ? AppColors.secondaryElement.withOpacity(.5)
                            : AppColors.secondaryElement,
                      ),
                      child: model.busy
                          ? LoadingIndicator()
                          : FlatButton(
                              onPressed: () =>
                                  model.changePassowrd(context, locale),
                              padding: EdgeInsets.all(0),
                              child: Text(locale.get("UPDATE"),
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  )),
                            ),
                    ),
                  )

                  // Padding(
                  //   padding:
                  //       const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  //   child: FlatButton(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10)),
                  //     color: Color.fromRGBO(219, 170, 68, 1),
                  //     onPressed: () {
                  //       model.changePassowrd(context, locale);
                  //     },
                  //     child: Center(
                  //       child: Text(locale.get("UPDATE") ?? "UPDATE",
                  //           style: TextStyle(color: Colors.white)),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
