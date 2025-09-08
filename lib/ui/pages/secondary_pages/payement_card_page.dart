import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/secondary_pages/payment_card_page_model.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/text_fields/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class PaymentCardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        body: BaseWidget<PaymentCardPageModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
            model: PaymentCardPageModel(auth: Provider.of(context)),
            builder: (context, model, child) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    appBar(
                      context: context,
                      locale: locale,
                      name: "Payment Method",
                      verticalPadding: 50,
                    ),
                    Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Image.asset('assets/images/payment.png'),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Text(
                            "Enter your credit card details",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ),
                        CustomTextFormField(
                          padding: const EdgeInsets.only(
                              left: 30, top: 20, bottom: 15),
                          hint: "Cardholder Name",
                          hintColor: Colors.grey,
                          textColor: Colors.black,
                        ),
                        CustomTextFormField(
                          padding: const EdgeInsets.only(
                              left: 30, top: 10, bottom: 15),
                          hint: "Cardholder Number",
                          hintColor: Colors.grey,
                          textColor: Colors.black,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 10, bottom: 15),
                                hint: "Expire Date",
                                hintColor: Colors.grey,
                                textColor: Colors.black,
                              ),
                            ),
                            Expanded(
                              child: CustomTextFormField(
                                padding: const EdgeInsets.only(
                                    left: 30, top: 10, bottom: 15),
                                hint: "CVV",
                                hintColor: Colors.grey,
                                textColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Checkbox(
                                value: true,
                                onChanged: (val) {
                                  print(val);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Expanded(
                                    child: Text(
                                        "Save this card for future Payment ?")),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, bottom: 10, right: 30, left: 30),
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            color: Color.fromRGBO(219, 170, 68, 1),
                            onPressed: () => onConfirm(context),
                            child: Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12.0),
                                child: Text(locale.get("Confirm") ?? "Confirm",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  onConfirm(BuildContext context) {
    UI.pushReplaceAll(context, ConfirmDialog());
  }
}

class ConfirmDialog extends StatefulWidget {
  ConfirmDialog({Key key}) : super(key: key);

  @override
  _ConfirmDialogState createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  @override
  void initState() {
    super.initState();
    pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 70,
                backgroundColor: Colors.white,
                child: Image.asset('assets/images/correct.png')),
            SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)
                      .get('Your Order was placed \nsuccessfully !') ??
                  'Your Order was placed \nsuccessfully !',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.grey),
            )
          ],
        ),
      ),
    );
  }

  void pop(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 1000));
    await Provider.of<CartService>(context, listen: false)
        .getCartsForUser(context);
    UI.pushReplaceAll(context, Routes.home);
  }
}
