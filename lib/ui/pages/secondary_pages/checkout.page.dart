import 'package:beautydoz/core/models/address.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/home_page_model.dart';
import 'package:beautydoz/core/page_models/secondary_pages/payment_method_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/drawer.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/drawer/home_drawer.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/buttons/normal_button.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:beautydoz/ui/widgets/svg_icon.dart';
import 'package:beautydoz/ui/widgets/swiper_button.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reactive_dropdown_search/reactive_dropdown_search.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class Checkout extends StatefulWidget {
  final Cart cart;
  const Checkout({Key key, this.cart}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<PaymentMethodPageModel>(
          model: PaymentMethodPageModel(
            auth: Provider.of(context),
            api: Provider.of<Api>(context),
          ),
          initState: (m) =>
              {m.getUserAddress(context), m.loadCountries(context)},
          builder: (context, model, child) {
            return Scaffold(
                key: locator<DrawerService>().checkoutScaffoldKey,
                endDrawer: HomeDrawer(),
                appBar: PreferredSize(
                  child: NewAppBar(
                    title: 'Checkout',
                    returnHome: true,
                    returnBtn: true,
                    onLanguageChanged: () {
                      model.setState();
                    },
                  ),
                  preferredSize: Size(ScreenUtil.screenWidthDp, 80),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: Column(
                      children: [
                        Container(
                            child: buildCheckoutBody(
                                context, locale, model, widget.cart)),
                        Container(
                            height: 1, color: Theme.of(context).primaryColor),
                        buildTotalPrice(model, locale, widget.cart),
                        buildPromoCodeButton(
                            context, locale, model, widget.cart),
                        if (model.discount != null && model.discount > 0)
                          buildDiscount(model, locale),
                        buildAddressDropDown(
                            context, model, locale, widget.cart),
                        buildShippingCost(model, locale, widget.cart),
                        Container(
                            height: 1, color: Theme.of(context).primaryColor),
                        buildGrandPrice(model, locale, widget.cart),
                        buildPaymentMethds(context, model, locale, widget.cart),
                        buildCheckoutButton(context, model, locale, widget.cart)
                      ],
                    ),
                  ),
                ));
          }),
    );
  }

  Widget buildCheckoutBody(BuildContext context, AppLocalizations locale,
      PaymentMethodPageModel model, Cart cart) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      separatorBuilder: (context, index) =>
          Container(height: 1, color: Theme.of(context).primaryColor),
      itemCount: cart.lines.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            buildCartItem(model, context, cart.lines[index], index, locale),
            if (index + 1 == cart.lines.length &&
                cart?.giftWrapping != null) ...[
              Container(height: 1, color: Theme.of(context).primaryColor),
              Container(
                padding: EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                height: 90,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 100, height: 100,
                      // height: double.infinity,
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager.instance,
                        imageUrl: cart.giftWrapping.wrapping.image,
                        colorBlendMode: BlendMode.darken,
                        color: AppColors.accentBackground,
                        placeholder: (context, url) => LoadingIndicator(),
                        errorWidget: (context, url, error) => GestureDetector(
                          onTap: () {
                            UI.push(context, Routes.home,
                                replace: true); //* adding navigation
                          },
                          child: Center(
                              child: Image.asset(
                            'assets/images/beautyLogo.png',
                            scale: 10,
                          )),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Text(
                                locale.get('Gift Wrapping Service'),
                                style: GoogleFonts.almarai(
                                    textStyle: TextStyle(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color,
                                        fontWeight: FontWeight.w600)),
                                maxLines: 3,
                                overflow: TextOverflow.clip,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  RichText(
                                    text: new TextSpan(children: [
                                      TextSpan(
                                          text: locator<CurrencyService>()
                                              .getPriceWithCurrncy(num.parse(
                                                  cart.giftWrapping.wrapping
                                                      .price)),
                                          style: GoogleFonts.almarai(
                                              textStyle: TextStyle(
                                                  fontSize: 18,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .secondary,
                                                  fontWeight: FontWeight.w600)))
                                    ]),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                        locale.get(locator<CurrencyService>()
                                            .selectedCurrency
                                            .toUpperCase()),
                                        style: GoogleFonts.almarai(
                                            textStyle: TextStyle(
                                                // fontSize: 9,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .color,
                                                fontWeight: FontWeight.w600))),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                    Align(
                      alignment: locale.locale.languageCode == 'ar'
                          ? Alignment.bottomLeft
                          : Alignment.bottomRight,
                      child: Text('x ${cart.giftWrapping.qty}',
                          style: GoogleFonts.almarai(
                              textStyle: TextStyle(
                                  fontSize: 26,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontWeight: FontWeight.bold))),
                    )
                  ],
                ),
              ),
            ]
          ],
        );
      },
      padding: EdgeInsets.zero,
    );
  }

  buildCartItem(PaymentMethodPageModel model, BuildContext context, Lines item,
      int index, AppLocalizations locale) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 8),
      // color: index % 2 == 0 ? Theme.of(context).colorScheme.secondary.withOpacity(0.1) : null,
      height: 100,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 100, height: 100,
            // height: double.infinity,
            child: CachedNetworkImage(
              cacheManager: CustomCacheManager.instance,
              imageUrl: widget.cart.lines[index].item.image,
              colorBlendMode: BlendMode.darken,
              color: AppColors.accentBackground,
              placeholder: (context, url) => LoadingIndicator(),
              errorWidget: (context, url, error) => GestureDetector(
                onTap: () {
                  UI.push(context, Routes.home,
                      replace: true); //* adding navigation
                },
                child: Center(
                    child: Image.asset(
                  'assets/images/beautyLogo.png',
                  scale: 10,
                )),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      item.item.name.localized(context),
                      style: GoogleFonts.almarai(
                          textStyle: TextStyle(
                              fontSize: 16,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color,
                              fontWeight: FontWeight.w600)),
                      maxLines: 3,
                      overflow: TextOverflow.clip,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (item.item.discount == 0)
                          RichText(
                            text: new TextSpan(children: [
                              TextSpan(
                                  text: locator<CurrencyService>()
                                      .getPriceWithCurrncy(
                                          num.parse(item.price)),
                                  style: GoogleFonts.almarai(
                                      textStyle: TextStyle(
                                          fontSize: 18,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.w600)))
                            ]),
                          )
                        else
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                children: [
                                  Text(
                                      locator<CurrencyService>()
                                          .getPriceWithCurrncy(
                                              num.parse(item.price)),
                                      style: GoogleFonts.almarai(
                                          textStyle: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600))),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0),
                                    child: RotationTransition(
                                      turns:
                                          new AlwaysStoppedAnimation(-15 / 360),
                                      child: Container(
                                          height: 1,
                                          width: 30,
                                          color: Colors.redAccent,
                                          child: Text('1')),
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  locator<CurrencyService>()
                                      .getPriceWithCurrncy(
                                          num.parse(item.item.priceAfter)),
                                  style: GoogleFonts.almarai(
                                      textStyle: TextStyle(
                                          fontSize: 22,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                          fontWeight: FontWeight.w900))),
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                              locale.get(locator<CurrencyService>()
                                  .selectedCurrency
                                  .toUpperCase()),
                              style: GoogleFonts.almarai(
                                  textStyle: TextStyle(
                                      // fontSize: 9,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      fontWeight: FontWeight.w600))),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          Align(
            alignment: locale.locale.languageCode == 'ar'
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
            child: Text('X ${item.quantity}',
                style: GoogleFonts.almarai(
                    textStyle: TextStyle(
                        fontSize: 26,
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.bold))),
          )
        ],
      ),
    );
  }

  Widget buildPromoCodeButton(BuildContext context, AppLocalizations locale,
      PaymentMethodPageModel model, Cart cart) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: ReactiveForm(
          formGroup: model.form,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                        color: AppColors.ternaryBackground.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(60)),
                    child: ReactiveTextField<String>(
                      formControlName: 'promoCode',
                      autocorrect: false,
                      style: GoogleFonts.almarai(
                          textStyle: TextStyle(
                        color: Theme.of(context).textTheme.bodyText1.color,
                      )),
                      onSubmitted: model.form.control('promoCode').valid
                          ? () {
                              model.applyPromoCode(context, locale,
                                  model.form.control('promoCode').value, cart);
                            }
                          : null,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                          hintText: locale.get('Promo Code') + ' ...',
                          hintStyle: GoogleFonts.almarai(
                              textStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                          )),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 20),
                          border: InputBorder.none),
                    ),
                  ),
                  Align(
                    alignment: locale.locale.languageCode == 'ar'
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: AppColors.ternaryBackground,
                          borderRadius: BorderRadius.circular(60)),
                      child: IconButton(
                          disabledColor: Colors.blueGrey,
                          color: Colors.white,
                          onPressed: model.form.control('promoCode').valid
                              ? () {
                                  model.applyPromoCode(
                                      context,
                                      locale,
                                      model.form.control('promoCode').value,
                                      cart);
                                }
                              : null,
                          icon: Icon(Icons.done)),
                    ),
                  ),
                  if (model.applieng)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.ternaryBackground.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(60)),
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        child: LinearProgressIndicator(
                          color: Theme.of(context).colorScheme.secondary,
                          backgroundColor: AppColors.ternaryBackground,
                        ),
                      ),
                    )
                ],
              ),
              // if (model.applieng)
            ],
          )),
    );
  }

  Widget buildDiscount(PaymentMethodPageModel model, AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(locale.get('Discount'),
              style: GoogleFonts.almarai(
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyText1.color,
                      fontWeight: FontWeight.w600))),
          SizedBox(
            width: 10,
          ),
          Text(
              locator<CurrencyService>().getPriceWithCurrncy(model.discount) +
                  "  " +
                  locale.get(locator<CurrencyService>()
                      .selectedCurrency
                      .toUpperCase()),
              style: GoogleFonts.almarai(
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }

  Widget buildTotalPrice(
      PaymentMethodPageModel model, AppLocalizations locale, Cart cart) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(locale.get('TOTAL') + ":",
              style: GoogleFonts.almarai(
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyText1.color,
                      fontWeight: FontWeight.w600))),
          SizedBox(
            width: 10,
          ),
          Text(
              locator<CurrencyService>().getPriceWithCurrncy(
                      num.tryParse(cart?.totalPrice ?? '0') ?? 0) +
                  "  " +
                  locale.get(locator<CurrencyService>()
                      .selectedCurrency
                      .toUpperCase()),
              style: GoogleFonts.almarai(
                  textStyle: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }

  Widget buildShippingCost(
      PaymentMethodPageModel model, AppLocalizations locale, Cart cart) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(locale.get('Shipping') + ":",
              style: TextStyle(
                  color: Theme.of(context).textTheme.bodyText1.color,
                  fontWeight: FontWeight.w600)),
          SizedBox(
            width: 10,
          ),
          ReactiveForm(
            formGroup: model.form,
            child: ReactiveValueListenableBuilder(
              formControlName: 'shippingAddress',
              builder: (context, control, child) {
                return control.valid
                    ? Text(
                        locator<CurrencyService>()
                                .getPriceWithCurrncy(
                                    double.parse(model.form
                                                .control('shippingAddress')
                                                .value
                                                ?.city
                                                ?.shippingCost ??
                                            '0') +
                                        double.parse(model.form
                                                .control('shippingAddress')
                                                .value
                                                ?.country
                                                ?.shippingCost ??
                                            '0')) +
                            " " +
                            locale.get(locator<CurrencyService>()
                                .selectedCurrency
                                .toUpperCase()),
                        style: GoogleFonts.almarai(
                            textStyle: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        )))
                    : Text(locale.get('Please Select your address'),
                        style: TextStyle(color: Colors.red));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAddressDropDown(BuildContext context,
      PaymentMethodPageModel model, AppLocalizations locale, Cart cart) {
    return model.addresses == null || model.addresses.isEmpty
        ? Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: GestureDetector(
                onTap: () {
                  model.addNewAddress(context);
                },
                child: Container(
                    height: 50,
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 25,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSecondary
                                  .withOpacity(0.2),
                              spreadRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(60)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.local_shipping,
                          color: Theme.of(context).textTheme.bodyText1.color,
                        ),
                        SizedBox(width: 10),
                        Text(locale.get('Pick your Address'),
                            style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.bodyText1.color,
                                fontSize: 14))
                      ],
                    ))),
          )
        : Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: ReactiveForm(
                formGroup: model.form,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 25,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondary
                                    .withOpacity(0.2),
                                spreadRadius: 2)
                          ],
                          borderRadius: BorderRadius.circular(60)),
                      child: ReactiveDropdownSearch<Address, Address>(
                        formControlName: 'shippingAddress',
                        validationMessages: (control) {
                          return {
                            'required': '                  ' +
                                locale.get('Please Select your address')
                          };
                        },
                        compareFn: (Address item, Address selectedItem) =>
                            item.id == selectedItem.id,
                        searchFieldProps: TextFieldProps(
                            autocorrect: true,
                            decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              label: Text('search'),
                              border: InputBorder.none,
                            )),
                        showSearchBox: false,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.local_shipping),
                            border: InputBorder.none,
                            alignLabelWithHint: true,
                            labelStyle: TextStyle(fontSize: 18),
                            label: Text(locale.get('Pick your Address')),
                            errorStyle: TextStyle(color: Colors.red)),
                        dropdownBuilder: (context, Address selectedItem) =>
                            selectedItem != null
                                ? Text(
                                    selectedItem.country.name
                                            .localized(context) +
                                        ' - ' +
                                        selectedItem.city.name
                                            .localized(context) +
                                        ' - ' +
                                        selectedItem.line1 +
                                        ' - ' +
                                        selectedItem.line2 +
                                        ' - ' +
                                        (selectedItem.line3 ?? ''),
                                  )
                                : Text(''),
                        popupItemBuilder: (context, selectedItem, isSelected) =>
                            Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Text(
                              selectedItem.country.name.localized(context) +
                                  ' - ' +
                                  selectedItem.city.name.localized(context) +
                                  ' - ' +
                                  selectedItem.line1 +
                                  ' - ' +
                                  selectedItem.line2 +
                                  ' - ' +
                                  (selectedItem.line3 ?? ''),
                              style: TextStyle(
                                fontSize: 18,
                                color: isSelected
                                    ? Theme.of(context).colorScheme.secondary
                                    : Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color,
                              )),
                        ),
                        mode: Mode.BOTTOM_SHEET,
                        popupTitle: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Center(
                            child: Text(locale.get('Pick your Address'),
                                style: GoogleFonts.almarai(
                                    textStyle: TextStyle(
                                        fontSize: 20,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))),
                          ),
                        ),
                        popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                        showSelectedItems: true,
                        dropDownButton: Container(),
                        items: model.addresses,
                        onPopupDismissed: () => model.setState(),
                        showClearButton: false,
                      ),
                    ),

                    // if (model.applieng)
                  ],
                )),
          );
  }

  Widget buildGrandPrice(
      PaymentMethodPageModel model, AppLocalizations locale, Cart cart) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(locale.get('You Will Pay') + ":",
              style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            width: 10,
          ),
          Text(
              locator<CurrencyService>().getPriceWithCurrncy(
                      (double.parse(cart.totalPrice) +
                              double.parse(model.form
                                      .control('shippingAddress')
                                      .value
                                      ?.city
                                      ?.shippingCost ??
                                  '0.0') +
                              double.parse(model.form
                                      .control('shippingAddress')
                                      .value
                                      ?.country
                                      ?.shippingCost ??
                                  '0')) -
                          model.discount) +
                  ' ' +
                  locale.get(locale.get(locator<CurrencyService>()
                      .selectedCurrency
                      .toUpperCase())),
              style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget buildPaymentMethds(BuildContext context, PaymentMethodPageModel model,
      AppLocalizations locale, Cart cart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.get('Select Payment Method') + ":",
            style: GoogleFonts.almarai(
                textStyle: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).textTheme.bodyText1.color,
                    fontWeight: FontWeight.w600))),
        ReactiveForm(
            formGroup: model.form,
            child: ReactiveValueListenableBuilder(
              formControlName: 'paymentMethod',
              builder: (context, control, child) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          model.form.control('paymentMethod').updateValue(1);
                          model.setState();
                        },
                        child: Container(
                          width: ScreenUtil.screenWidthDp / 6,
                          height: ScreenUtil.screenWidthDp / 6,
                          decoration: BoxDecoration(
                              color: control.value == 1
                                  ? AppColors.ternaryBackground
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 25,
                                    color: Colors.blueGrey.withOpacity(0.2),
                                    spreadRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              'assets/images/knet.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          model.form.control('paymentMethod').updateValue(2);
                          model.setState();
                        },
                        child: Container(
                          width: ScreenUtil.screenWidthDp / 6,
                          height: ScreenUtil.screenWidthDp / 6,
                          decoration: BoxDecoration(
                              color: control.value == 2
                                  ? AppColors.ternaryBackground
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 25,
                                    color: Colors.blueGrey.withOpacity(0.2),
                                    spreadRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(12)),
                          child: Image.asset('assets/images/visa-logo.png',
                              fit: BoxFit.contain),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          model.form.control('paymentMethod').updateValue(3);
                          model.setState();
                        },
                        child: Container(
                          width: ScreenUtil.screenWidthDp / 6,
                          height: ScreenUtil.screenWidthDp / 6,
                          decoration: BoxDecoration(
                              color: control.value == 3
                                  ? AppColors.ternaryBackground
                                  : Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 25,
                                    color: Colors.blueGrey.withOpacity(0.2),
                                    spreadRadius: 2)
                              ],
                              borderRadius: BorderRadius.circular(12)),
                          child: Image.asset(
                              'assets/images/mastercard-logo.png',
                              fit: BoxFit.contain),
                        ),
                      ),
                      if (locator<CurrencyService>().selectedCurrency == 'kwd')
                        InkWell(
                          onTap: () {
                            model.form.control('paymentMethod').updateValue(4);
                            model.setState();
                          },
                          child: Container(
                            width: ScreenUtil.screenWidthDp / 6,
                            height: ScreenUtil.screenWidthDp / 6,
                            decoration: BoxDecoration(
                                color: control.value == 4
                                    ? AppColors.ternaryBackground
                                    : Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      blurRadius: 25,
                                      color: Colors.blueGrey.withOpacity(0.2),
                                      spreadRadius: 2)
                                ],
                                borderRadius: BorderRadius.circular(12)),
                            child: Image.asset('assets/images/cod.png',
                                colorBlendMode: BlendMode.darken,
                                color: control.value == 4
                                    ? AppColors.ternaryBackground
                                    : Colors.white,
                                fit: BoxFit.contain),
                          ),
                        ),
                    ],
                  ),
                );
              },
            )),
      ],
    );
  }

  Widget buildCheckoutButton(BuildContext context, PaymentMethodPageModel model,
      AppLocalizations locale, Cart cart) {
    return ReactiveForm(
        formGroup: model.form,
        child: ReactiveFormConsumer(
          builder: (context, formGroup, child) {
            return SwipingButton(
              text: locale.get('Confirm and Pay'),
              padding: EdgeInsets.all(10),

              icon: Icons.shopping_cart_outlined,
              buttonTextStyle: GoogleFonts.almarai(
                  textStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w600)),
              onSwipeCallback: () {
                if (formGroup.valid) {
                  formGroup.control('paymentMethod').value == 4
                      ? model.confirmDialog(context, cart,
                          formGroup.control('shippingAddress').value)
                      : model.gotoPaymentWebView(
                          context,
                          cart,
                          formGroup.control('shippingAddress').value,
                          formGroup.control('paymentMethod').value,
                          promo: model.form.control('promoCode').value,
                          shippingCost: double.parse(formGroup
                                  .control('shippingAddress')
                                  .value
                                  .city
                                  .shippingCost) +
                              double.parse(formGroup
                                  .control('shippingAddress')
                                  .value
                                  .country
                                  .shippingCost));
                } else {
                  UI.toast(locale.get(
                      'Please Select Shipping Address and Payment Method'));
                }
              },
              backgroundColor: AppColors.ternaryBackground,
              swipeButtonColor: Theme.of(context).colorScheme.secondary,
              swipePercentageNeeded: 0.6,
              height: 50,

              // width: 80,
            );
          },
        ));
  }
}
