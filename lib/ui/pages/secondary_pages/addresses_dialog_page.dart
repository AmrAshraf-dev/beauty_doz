import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/page_models/secondary_pages/address_dialog_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../shared/styles/colors.dart';

class AddressesDialogPage extends StatelessWidget {
  final Cart cart;
  AddressesDialogPage({this.cart});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BaseWidget<AddressDialogPageModel>(
            initState: (m) => WidgetsBinding.instance
                .addPostFrameCallback((_) => m.getUserAddress(context)),
            model: AddressDialogPageModel(
                auth: Provider.of(context),
                api: Provider.of<Api>(context),
                context: context),
            builder: (context, model, child) {
              return ListView(
                children: [
                  dialogAppBar(context, locale),
                  model.busy
                      ? Expanded(
                          child: Center(
                            child: LoadingIndicator(),
                          ),
                        )
                      : model.hasError
                          ? Expanded(
                              child: ListView(
                                children: [
                                  Icon(Icons.error_outline),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(locale.get(
                                            "There is no address in your profile") ??
                                        "There is no address in your profile"),
                                  )
                                ],
                              ),
                            )
                          : address(context, locale, model),
                  gotoPaymentButton(model, context, locale, cart),
                  createNewButton(context, model, locale),
                ],
              );
            }),
      ),
    );
  }

  Widget createNewButton(BuildContext context, AddressDialogPageModel model,
      AppLocalizations locale) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 12.0, bottom: 10, right: 50, left: 50),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: AppColors.secondaryBackground,
        onPressed: () {
          model.gotoAddresses(context);
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(
                locale.get("Create New Address") ?? "Create New Address",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget gotoPaymentButton(AddressDialogPageModel model, BuildContext context,
      AppLocalizations locale, Cart cart) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 12.0, bottom: 12.0, right: 50, left: 50),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: Color.fromRGBO(219, 170, 68, 1),
        disabledColor: AppColors.accentText,
        onPressed: () {
          model.radvalue != null
              ? model.gotoPayment(context, model.radvalue, cart)
              : UI.toast(locale.get("You must choose an address") ??
                  "You must choose an address");
        },
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Text(locale.get("GO TO PAYMENT") ?? "GO TO PAYMENT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          ),
        ),
      ),
    );
  }

  dialogAppBar(BuildContext context, AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(locale.get("Delivery Addresses") ?? "Delivery Addresses"),
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.close))
        ],
      ),
    );
  }

  address(BuildContext context, AppLocalizations locale,
      AddressDialogPageModel model) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              ...List.generate(model.addresses.length, (index) {
                return Container(
                    child: RadioListTile(
                  title: Text(
                      model.addresses[index].country.name.localized(context) +
                          ' - ' +
                          model.addresses[index].city.name.localized(context) +
                          ' - ' +
                          model.addresses[index].line1 +
                          ' - ' +
                          model.addresses[index].line2),
                  value: model.addresses[index].id,
                  groupValue: model.radvalue,
                  onChanged: (newVal) {
                    print(newVal);
                    model.radvalue = model.addresses[index].id;
                    model.setState();
                  },
                ));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
