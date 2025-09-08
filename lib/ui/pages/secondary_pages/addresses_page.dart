import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/secondary_pages/address_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/pages/secondary_pages/create_new_address_dialog.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class AdressesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
        child: BaseWidget<AdressesPageModel>(
            initState: (m) => WidgetsBinding.instance
                .addPostFrameCallback((_) => m.getUserAddress()),
            model: AdressesPageModel(
                context: context,
                auth: Provider.of(context),
                api: Provider.of<Api>(context),
                state: NotifierState.busy),
            builder: (context, model, child) {
              return Container(
                color: Theme.of(context).backgroundColor,
                child: SafeArea(
                  child: Scaffold(
                    backgroundColor: Theme.of(context).backgroundColor,
                    appBar: PreferredSize(
                      child: NewAppBar(
                        title: 'Adresses',
                        drawer: false,
                        returnBtn: true,
                        onLanguageChanged: null,
                      ),
                      preferredSize: Size(ScreenUtil.screenWidthDp, 80),
                    ),
                    bottomNavigationBar: addNewAddress(context, model),
                    body: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          children: <Widget>[
                            model.busy
                                ? Expanded(
                                    child: Center(child: LoadingIndicator()))
                                : model.addresses == null ||
                                        model.addresses.length == 0
                                    ? buildEmptyAddress(locale)
                                    : addresses(context, model, locale)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  Expanded buildEmptyAddress(AppLocalizations locale) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(locale.get("There is no address in your profile") ??
                "There is no address in your profile"),
          )
        ],
      ),
    );
  }

  addresses(
      BuildContext context, AdressesPageModel model, AppLocalizations locale) {
    return Expanded(
        child: Container(
            padding: const EdgeInsets.all(15.0),
            margin: EdgeInsets.only(bottom: 50),
            child: ListView.separated(
              separatorBuilder: (c, i) => Divider(height: 1, thickness: 1.3),
              padding: EdgeInsets.all(0),
              itemCount: model.addresses.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final address = model.addresses[index];
                return Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(address.city.name.localized(context) +
                          '-' +
                          address.country.name.localized(context) +
                          '-' +
                          address.line1 +
                          '-' +
                          address.line2 +
                          '-' +
                          (address.line3 ?? '')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(5),
                              child: InkWell(
                                  onTap: () {
                                    UI
                                        .dialog(
                                      context: context,
                                      title: locale.get("Delete address") ??
                                          "Delete address",
                                      msg: locale.get(
                                              "Are you sure to delete this address") ??
                                          "Are you sure to delete this address",
                                      accept: true,
                                      acceptMsg: locale.get("Yes") ?? "Yes",
                                      cancelMsg: locale.get("No") ?? "No",
                                    )
                                        .then((value) {
                                      if (value == true)
                                        model.deleteAddress(context, address);
                                    });
                                  },
                                  child: Text(locale.get('delete') ?? 'delete',
                                      style: TextStyle(
                                          color: AppColors.accentText)))),
                          InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AddressDialogPage(
                                          context,
                                          addresses: model.addresses[index],
                                          update: true,
                                          countries: model.countries,
                                        )).then((value) {
                                  if (value != null && value == true)
                                    model.getUserAddress();
                                });
                              },
                              child: Text(locale.get('Update') ?? "Update",
                                  style:
                                      TextStyle(color: AppColors.accentText))),
                        ],
                      )
                    ],
                  ),
                );
              },
            )));
  }

  addNewAddress(BuildContext context, AdressesPageModel model) {
    final locale = AppLocalizations.of(context);

    return Padding(
      padding:
          const EdgeInsets.only(top: 12.0, bottom: 10, right: 30, left: 30),
      child: Container(
        width: ScreenUtil.screenWidthDp,
        child: FlatButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          color: Color.fromRGBO(219, 170, 68, 1),
          onPressed: () {
            model.busy
                ? null
                : showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    constraints: BoxConstraints(
                        minHeight: ScreenUtil.screenHeightDp * 0.4),
                    builder: (context) => AddressDialogPage(
                          context,
                          countries: model.countries,
                          update: false,
                        )).then((value) => model.getUserAddress());
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(locale.get("Create New") ?? "Create New",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
