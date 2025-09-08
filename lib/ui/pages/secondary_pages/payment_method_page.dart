import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/address.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/page_models/secondary_pages/payment_method_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/reactive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class PaymentMethodPage extends StatelessWidget {
  final Address address;
  final Cart cart;
  // double total;
  PaymentMethodPage({this.address, this.cart});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: Scaffold(
        backgroundColor: Color.fromRGBO(247, 247, 247, 1),
        body: BaseWidget<PaymentMethodPageModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),

            model: PaymentMethodPageModel(
              auth: Provider.of(context),
              api: Provider.of<Api>(context),
            ),
            builder: (context, model, child) {
              return model.busy
                  ? Center(child: LoadingIndicator())
                  : model.hasError
                      ? Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                              Text(
                                  "Error Happend!\nTry to pick location again "),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 200,
                                height: 45,
                                child: OutlinedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.secondaryElement)),
                                    onPressed: () async {},
                                    child: Text(
                                      "Pick Location",
                                      style: TextStyle(
                                        color: AppColors.secondaryText,
                                      ),
                                    )),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: 160,
                                height: 45,
                                child: OutlinedButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                AppColors.secondaryElement)),
                                    onPressed: () async {
                                      UI.pushReplaceAll(context, Routes.home);
                                    },
                                    child: Text(
                                      "Back Home",
                                      style: TextStyle(
                                        color: AppColors.secondaryText,
                                      ),
                                    )),
                              ),
                            ]))
                      : Container(
                          width: ScreenUtil.screenWidthDp,
                          height: ScreenUtil.screenHeightDp,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                appBar(
                                  context: context,
                                  name: 'Payment Method',
                                  locale: locale,
                                  verticalPadding: 20,
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8, bottom: 8),
                                      child: Text(
                                        locale.get("Your order info"),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16, top: 5),
                                      child: Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              ...List.generate(
                                                  cart?.lines?.length ?? 0,
                                                  (index) => Column(
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Container(
                                                                width: 150,
                                                                child: Text(cart
                                                                        .lines[
                                                                            index]
                                                                        .item
                                                                        .name
                                                                        .localized(
                                                                            context) +
                                                                    " x" +
                                                                    cart
                                                                        .lines[
                                                                            index]
                                                                        .quantity
                                                                        .toString()),
                                                              ),
                                                              Text((cart.lines[index].item.priceAfter !=
                                                                          "0.000"
                                                                      ? locator<CurrencyService>().getPriceWithCurrncy(num.tryParse(cart
                                                                          .lines[
                                                                              index]
                                                                          .item
                                                                          .priceAfter))
                                                                      : locator<CurrencyService>().getPriceWithCurrncy(num.tryParse(cart
                                                                          .lines[
                                                                              index]
                                                                          .item
                                                                          .price))) +
                                                                  " " +
                                                                  locale.get(locator<CurrencyService>()
                                                                      .selectedCurrency
                                                                      .toUpperCase())),
                                                            ],
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Divider(
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          )
                                                        ],
                                                      )),
                                              if (cart.giftWrapping != null)
                                                Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Container(
                                                          width: 150,
                                                          child: Text(locale.get(
                                                                  'Gift Wrapping Service') +
                                                              " x" +
                                                              cart.giftWrapping
                                                                  .qty
                                                                  .toString()),
                                                        ),
                                                        Text((locator<
                                                                    CurrencyService>()
                                                                .getPriceWithCurrncy(
                                                                    num.tryParse(cart
                                                                        .giftWrapping
                                                                        .wrapping
                                                                        .price)) +
                                                            " " +
                                                            locale.get(locator<
                                                                    CurrencyService>()
                                                                .selectedCurrency
                                                                .toUpperCase()))),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Divider(
                                                        color: Colors.grey,
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 16.0, right: 16),
                                      child: Container(
                                        color: Colors.white,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(locale.get(
                                                            "Order fees") ??
                                                        "Order fees"),
                                                    Text(
                                                        "${locator<CurrencyService>().getPriceWithCurrncy(num.tryParse(cart.totalPrice))} ${locator<CurrencyService>().selectedCurrency.toUpperCase()}"),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(locale.get(
                                                            "Shipping fees") ??
                                                        "Shipping fees"),
                                                    Text(locator<
                                                                CurrencyService>()
                                                            .getPriceWithCurrncy(double
                                                                    .parse(address
                                                                        .city
                                                                        .shippingCost) +
                                                                double.parse(address
                                                                    .country
                                                                    .shippingCost)) +
                                                        " " +
                                                        locale.get(locator<
                                                                CurrencyService>()
                                                            .selectedCurrency
                                                            .toUpperCase())),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(locale.get(
                                                            "Total price") ??
                                                        "Total price"),
                                                    Text(
                                                      model.total == null
                                                          ? locator<CurrencyService>().getPriceWithCurrncy(double
                                                                      .parse(cart
                                                                          .totalPrice) +
                                                                  double.parse(
                                                                      address
                                                                          .city
                                                                          .shippingCost) +
                                                                  double.parse(address
                                                                      .country
                                                                      .shippingCost)) +
                                                              " ${locator<CurrencyService>().selectedCurrency.toUpperCase()}"
                                                          : model.total
                                                              .toStringAsFixed(
                                                                  3),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      locale.get(
                                                              "Promo code : ") ??
                                                          "Promo code : ",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                    ReactiveForm(
                                                      formGroup: model.form,
                                                      child: Expanded(
                                                        child: Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          5),
                                                              child: Container(
                                                                  height: 100,
                                                                  width: ScreenUtil
                                                                      .screenWidthDp,
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              20),
                                                                  child:
                                                                      ReactiveField(
                                                                    type: ReactiveFields
                                                                        .TEXT,
                                                                    controllerName:
                                                                        'promoCode',
                                                                    borderColor:
                                                                        AppColors
                                                                            .accentText,
                                                                    hint: locale
                                                                            .get("Enter your promo code") ??
                                                                        "Enter your promo code",
                                                                  ))),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 5),
                                                    child: Container(
                                                      height: 50,
                                                      width: ScreenUtil
                                                          .screenWidthDp,
                                                      padding: EdgeInsets.only(
                                                          bottom: 20),
                                                      child: FlatButton(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        onPressed: () async {
                                                          String code =
                                                              model.form.value[
                                                                  'promoCode'];
                                                          if (code == null ||
                                                              code
                                                                  .trim()
                                                                  .isEmpty)
                                                            return;

                                                          await model
                                                              .applyPromoCode(
                                                                  context,
                                                                  locale,
                                                                  code,
                                                                  cart);
                                                        },
                                                        child: Text(
                                                          locale.get(
                                                              "apply promo code"),
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .amberAccent
                                                                  .shade700,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 20),
                                                        ),
                                                      ),
                                                    )),
                                              ),
                                              if (model.promoCode != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(locale.get(
                                                              "Total discount") ??
                                                          "Total discount"),
                                                      Text(locator<
                                                                  CurrencyService>()
                                                              .getPriceWithCurrncy(
                                                                  model
                                                                      .discount) +
                                                          locale.get(locator<
                                                                  CurrencyService>()
                                                              .selectedCurrency
                                                              .toUpperCase())),
                                                    ],
                                                  ),
                                                ),
                                              if (model.promoCode != null)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(locale.get(
                                                              "After discount") ??
                                                          "After discount"),
                                                      Text(locator<CurrencyService>().getPriceWithCurrncy((double.parse(
                                                                      cart
                                                                          .totalPrice) +
                                                                  double.parse(
                                                                      address
                                                                          .city
                                                                          .shippingCost) +
                                                                  double.parse(address
                                                                      .country
                                                                      .shippingCost)) -
                                                              model.discount) +
                                                          ' ' +
                                                          locale.get(locale.get(
                                                              locator<CurrencyService>()
                                                                  .selectedCurrency
                                                                  .toUpperCase()))),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ...List.generate(
                                        model.paymentMethods.length, (index) {
                                      return Padding(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 5),
                                          child: items(
                                              context, locale, model, index,
                                              title: locale.get(model
                                                      .paymentMethods[index]) ??
                                                  model.paymentMethods[index],
                                              // subtitle: "Pay with mastercard or visa",
                                              icon: Icons.payment));
                                    }),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 5),
                                      child: Container(
                                        height: 100,
                                        width: ScreenUtil.screenWidthDp,
                                        padding: EdgeInsets.all(20),
                                        child: FlatButton(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          onPressed: () {
                                            // Provider.of<CartService>(context,
                                            //         listen: false)
                                            //     .getCartsForUser(context);
                                            model.paymentRadVal == 3
                                                ? model.confirmDialog(
                                                    context, cart, address)
                                                : model.gotoPaymentWebView(
                                                    context,
                                                    cart,
                                                    address,
                                                    model.paymentRadVal,
                                                    promo: model.form
                                                        .control('promoCode')
                                                        .value,
                                                    shippingCost: double.parse(
                                                            address.city
                                                                .shippingCost) +
                                                        double.parse(address
                                                            .country
                                                            .shippingCost));

                                            // : UI.toast(locale.get("Coming soon") ??
                                            //     "Coming soon");
                                          },
                                          color: Colors.amberAccent,
                                          child: Text(
                                            locale.get("Confirm") ?? "Confirm",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                        );
            }),
      ),
    );
  }

  items(BuildContext context, AppLocalizations locale,
      PaymentMethodPageModel model, int index,
      {String title = ' ', String subtitle = ' ', IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: InkWell(
        onTap: () {
          // if (title == "Credit Card") {
          //   model.gotoPaymentWebView(context, cart, address);
          // }
        },
        child: RadioListTile(
          value: model.paymentValues[index],
          title: radioTitle(icon, title, subtitle),
          activeColor: Color.fromRGBO(222, 178, 87, 1),
          groupValue: model.paymentRadVal,
          onChanged: (val) {
            print(val);
            model.paymentRadVal = model.paymentValues[index];
            model.setState();
          },
        ),
      ),
    );
  }

  Widget radioTitle(IconData icon, String title, String subtitle) {
    return Container(
      width: ScreenUtil.screenWidthDp / 1.25,
      padding: EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(icon),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: Text(
                      title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  // Text(
                  //   subtitle,
                  //   overflow: TextOverflow.clip,
                  // )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
