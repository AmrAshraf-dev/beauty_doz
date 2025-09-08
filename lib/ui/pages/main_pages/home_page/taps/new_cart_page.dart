import 'package:beautydoz/core/models/wrapping-model.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/home_page_model.dart';
import 'package:beautydoz/core/page_models/main_pages_models/home_page/taps/cart_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/secondary_pages/addresses_dialog_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/checkout.page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/shared/styles/text_styles.dart';
import 'package:beautydoz/ui/widgets/buttons/normal_button.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:beautydoz/ui/widgets/reactive_widgets.dart';
import 'package:beautydoz/ui/widgets/swiper_button.widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class NewCartPage extends StatelessWidget {
  AuthenticationService auth;
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BaseWidget<CartPageModel>(
        model: CartPageModel(
          state: NotifierState.busy,
          auth: Provider.of(context),
          api: Provider.of<Api>(context),
          categoryService: Provider.of(context),
          cartService: Provider.of(context),
        ),
        initState: (model) => WidgetsBinding.instance
            .addPostFrameCallback((_) => model.getCartsforUser(context)),
        builder: (context, model, child) {
          return Consumer<CartService>(builder: (context, csmodel, child) {
            return Scaffold(
              appBar: PreferredSize(
                child: NewAppBar(
                    title: 'Cart',
                    returnBtn: false,
                    onLanguageChanged: () {
                      model.setState();
                    }),
                preferredSize: Size(ScreenUtil.screenWidthDp, 80),
              ),
              body: SafeArea(
                child: Container(
                    width: ScreenUtil.screenWidthDp,
                    height: ScreenUtil.screenHeightDp,
                    color: Theme.of(context).backgroundColor,
                    child: Column(
                      children: <Widget>[
                        model.busy
                            ? buildLoading()
                            : model.hasError
                                ? buildErrorWidget(locale)
                                : Expanded(
                                    child: Stack(
                                      fit: StackFit.expand,
                                      alignment: Alignment.topCenter,
                                      children: <Widget>[
                                        model.cart.lines.isEmpty
                                            ? buildEmptyIndicator(locale)
                                            : buildCartItemsList(context,
                                                csmodel, model, locale),
                                        // buildCheckoutWidget(
                                        //     locale, csmodel, context, model)
                                      ],
                                    ),
                                  ),
                      ],
                    )),
              ),
              persistentFooterButtons: [
                if (model.cart != null && model.cart.lines.isNotEmpty) ...[
                  Container(
                    width: double.infinity,
                    height: 60,
                    // height: ScreenUtil.screenHeightDp / 12,
                    color: Theme.of(context).backgroundColor.withOpacity(0.9),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(locale.get('TOTAL'),
                            style: GoogleFonts.almarai(
                                textStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600))),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                            locator<CurrencyService>().getPriceWithCurrncy(
                                    num.tryParse(
                                            model?.cart?.totalPrice ?? '0') ??
                                        0) +
                                "  " +
                                locale.get(locator<CurrencyService>()
                                    .selectedCurrency
                                    .toUpperCase()),
                            style: GoogleFonts.almarai(
                                textStyle:
                                    TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)))
                      ],
                    ),
                  ),
                  SwipingButton(
                    text: locale.get('Go To Payment'),
                    padding: EdgeInsets.all(10),
                    icon: Icons.shopping_cart_outlined,
                    buttonTextStyle: GoogleFonts.almarai(
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    onSwipeCallback: () {
                      if (model.cart != null && model.cart.lines.length != 0) {
                        UI.push(context, Checkout(cart: model.cart));
                        // showDialog(
                        //     context: context,
                        //     builder: (BuildContext context) {
                        //       return AddressesDialogPage(cart: model.cart);
                        //     });
                      } else {
                        UI.toast(locale.get("Cart is empty"));
                      }
                    },
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.8),
                    swipeButtonColor: Theme.of(context).colorScheme.secondary,
                    swipePercentageNeeded: 0.4,
                    height: 50,

                    // width: 80,
                  ),
                ]
                // checkOutButton(context, locale, model, csmodel.cart)
              ],
            );
          });
        });
  }

  Widget buildCartItemsList(BuildContext context, CartService csmodel,
      CartPageModel model, AppLocalizations locale) {
    int selectedWrapping;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          if (csmodel?.cart?.lines?.isNotEmpty ?? false)
            ...csmodel.cart.lines
                .map((line) => buildCartItem(model, context, line,
                    csmodel.cart.lines.indexOf(line), csmodel, locale))
                .toList(),
          if (model.cart?.giftWrapping == null)
            InkWell(
              onTap: () async {
                model.setBusy();
                // get wrappings
                List<Wrapping> wrappings =
                    await locator<HttpApi>().getWrappings(context);
                model.setIdle();

                // show modal bottom sheet
                showModalBottomSheet(
                  context: context,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  builder: (context) {
                    return Container(
                      height: ScreenUtil.screenHeightDp * 0.9,
                      width: ScreenUtil.screenWidthDp,
                      decoration:
                          BoxDecoration(color: Theme.of(context).backgroundColor
                              // borderRadius: BorderRadius.only(
                              //   topLeft: const Radius.circular(50.0),
                              //   topRight: const Radius.circular(50.0),
                              // ),
                              ),
                      padding: EdgeInsets.all(16),
                      child: StatefulBuilder(
                          builder: (BuildContext context, innerSetState) {
                        return ReactiveForm(
                          formGroup: model.wrappingForm,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                    locale.get('Select Wrapping Design'),
                                    style: TextStyles.subHeaderStyle
                                        .copyWith(fontSize: 14)),
                              ),
                              Container(
                                height: 120,
                                child: ListView.separated(
                                  itemCount: wrappings.length,
                                  scrollDirection: Axis.horizontal,
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    width: 8,
                                  ),
                                  itemBuilder: (context, index) {
                                    Wrapping wrapping = wrappings[index];
                                    return Column(
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: wrapping.image,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  InkWell(
                                            onTap: () {
                                              model.wrappingForm
                                                  .control('wrapping')
                                                  .updateValue(
                                                      wrapping.toJson());
                                              selectedWrapping = wrapping.id;
                                              model.selectedWrapping = wrapping;
                                              innerSetState(() {});
                                            },
                                            child: Container(
                                              height: 80,
                                              width: 80,
                                              decoration: BoxDecoration(
                                                border: selectedWrapping ==
                                                        wrapping.id
                                                    ? Border.all(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .secondary,
                                                        style:
                                                            BorderStyle.solid,
                                                        width: 2)
                                                    : Border.all(width: 0),
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              GestureDetector(
                                            onTap: () {
                                              UI.push(context, Routes.home,
                                                  replace:
                                                      true); //* adding navigation
                                            },
                                            child: SvgPicture.asset(
                                              "assets/images/beautyLogo.svg",
                                              width: ScreenUtil.screenWidthDp,
                                              // height: ScreenUtil.screenHeightDp,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                            locator<CurrencyService>()
                                                    .getPriceWithCurrncy(
                                                        num.tryParse(
                                                            wrapping.price)) +
                                                " " +
                                                locale.get(
                                                    locator<CurrencyService>()
                                                        .selectedCurrency
                                                        .toUpperCase()),
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    );
                                  },
                                ),
                              ),
                              ReactiveValueListenableBuilder(
                                formControlName: 'wrapping',
                                builder: (context, control, child) {
                                  return control.hasError('required') &&
                                          model.wrappingForm.touched
                                      ? Row(
                                          children: [
                                            Text(
                                                locale.get(
                                                    'Please Select Wrapping Design'),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                        color: Colors.red,
                                                        fontSize: 15)),
                                          ],
                                        )
                                      : SizedBox();
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ReactiveField(
                                  context: context,
                                  controllerName: 'from',
                                  label: locale.get("From"),
                                  type: ReactiveFields.TEXT,
                                  hint: locale.get("From"),
                                  filled: true,
                                  validationMesseges: {
                                    'required':
                                        locale.get('Sender Name is Required')
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ReactiveField(
                                  context: context,
                                  controllerName: 'to',
                                  type: ReactiveFields.TEXT,
                                  label: locale.get("To"),
                                  hint: locale.get("To"),
                                  validationMesseges: {
                                    'required':
                                        locale.get('Reciver Name is Required')
                                  },
                                  filled: true,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ReactiveField(
                                  context: context,
                                  controllerName: 'message',
                                  label: locale.get("Message"),
                                  type: ReactiveFields.TEXT,
                                  maxLines: 5,
                                  hint: locale.get("Message"),
                                  validationMesseges: {
                                    'required':
                                        locale.get('Message is Required')
                                  },
                                  filled: true,
                                ),
                              ),
                              ReactiveFormConsumer(
                                builder: (context, formGroup, child) =>
                                    NormalButton(
                                  gradient: formGroup.valid
                                      ? LinearGradient(
                                          begin: FractionalOffset.centerLeft,
                                          end: FractionalOffset.centerRight,
                                          colors: [
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary
                                                  .withOpacity(0.4),
                                              Theme.of(context)
                                                  .colorScheme
                                                  .secondary,
                                            ],
                                          stops: [
                                              0.0,
                                              1.0
                                            ])
                                      : null,
                                  text: locale.get('Confirm'),
                                  onPressed: formGroup.valid
                                      ? () async {
                                          Cart cart = await locator<HttpApi>()
                                              .addWrapping(context,
                                                  body: formGroup.value);
                                          model.cart = cart;
                                          model.setState();
                                          Navigator.pop(context);
                                        }
                                      : null,
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                        begin: FractionalOffset.topRight,
                        end: FractionalOffset.bottomLeft,
                        colors: [
                          Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.8),
                          Theme.of(context).colorScheme.secondary,
                          Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.4)
                        ],
                        stops: [
                          0.0,
                          0.7,
                          1
                        ]),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.card_giftcard,
                        color: Theme.of(context).textTheme.bodyText1.color,
                      ),
                      Text(
                        locale.get('Add Gift Wrapping'),
                        style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1.color,
                            fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            )
          else
            Dismissible(
              // onTap: () => model.openItem(context,
              //     item: item.item, cartItem: model.cart.lines[index]),
              direction: DismissDirection.horizontal,
              confirmDismiss: (direction) async {
                return await UI.dialog(
                  context: context,
                  title: locale.get("Delete Gift Wrapping ?"),
                  msg: locale
                      .get("Are you sure to delete gift wrapping service"),
                  accept: true,
                  dismissible: false,
                  acceptMsg: locale.get("Yes") ?? "Yes",
                  cancelMsg: locale.get("No") ?? "No",
                );
              },
              onDismissed: (direction) async {
                Cart cart = await locator<HttpApi>().removeWrapping(context);
                model.cart = cart;
                model.setState();
                // model.remove(context, locale,
                //     lineId: model.cart.lines[index].id);
              },
              key: UniqueKey(),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 11, horizontal: 8),
                color: model.cart.lines.length % 2 == 0
                    ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
                    : null,
                height: 120,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: 100, height: 100,
                      // height: double.infinity,
                      child: CachedNetworkImage(
                        cacheManager: CustomCacheManager.instance,
                        imageUrl: model.cart.giftWrapping.wrapping.image,
                        color: model.cart.lines.length % 2 == 0
                            ? Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.1)
                            : Theme.of(context).backgroundColor,
                        colorBlendMode: BlendMode.multiply,
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
                                                  model.cart.giftWrapping
                                                      .wrapping.price)),
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
                                                fontWeight: FontWeight.w600))),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () async {
                              if (model.cart.giftWrapping.qty > 1) {
                                GiftWrapping gw = model.cart.giftWrapping;
                                gw.qty--;
                                Cart cart = await locator<HttpApi>()
                                    .addWrapping(context, body: gw.toJson());
                                model.cart = cart;
                                model.setState();
                              }
                            },
                            child: Icon(
                              Icons.remove,
                            ),
                          ),
                          Text(model.cart.giftWrapping.qty.toString(),
                              style: GoogleFonts.almarai(
                                  textStyle: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold))),
                          InkWell(
                            borderRadius: BorderRadius.circular(25),
                            onTap: () async {
                              if (model.cart.giftWrapping.qty <
                                  model.cart.totalItems) {
                                GiftWrapping gw = model.cart.giftWrapping;
                                gw.qty++;
                                Cart cart = await locator<HttpApi>()
                                    .addWrapping(context, body: gw.toJson());
                                model.cart = cart;
                                model.setState();
                                //   item.quantity++;
                                //   model.updateCart(context, index, item);
                              }
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(25)),
                              child: Icon(Icons.add),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          SizedBox(),
          SizedBox(
            height: 10,
          ),
          Container(
              height: 1,
              width: ScreenUtil.screenWidthDp / 3,
              color: Colors.blueGrey),
        ],
      ),
    );
  }

  Widget buildCartItem(CartPageModel model, BuildContext context, Lines item,
      int index, CartService csmodel, AppLocalizations locale) {
    return Dismissible(
      // onTap: () => model.openItem(context,
      //     item: item.item, cartItem: model.cart.lines[index]),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        return await UI.dialog(
          context: context,
          title: locale.get("Delete From Cart"),
          msg: locale.get("Are you sure to delete this item from cart"),
          accept: true,
          dismissible: false,
          acceptMsg: locale.get("Yes") ?? "Yes",
          cancelMsg: locale.get("No") ?? "No",
        );
      },
      onDismissed: (direction) {
        model.remove(context, locale,
            lineId: model.cart.lines[index].id /*, userid: auth.user.user.id*/);
      },
      key: UniqueKey(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 11, horizontal: 8),
        color: index % 2 == 0
            ? Theme.of(context).colorScheme.secondary.withOpacity(0.1)
            : null,
        height: 120,
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              width: 100, height: 100,
              // height: double.infinity,
              child: CachedNetworkImage(
                cacheManager: CustomCacheManager.instance,
                imageUrl: model.cart.lines[index].item.image,
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
                                fontSize: 16, fontWeight: FontWeight.w600)),
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
                                                color: Colors.grey.shade400,
                                                fontWeight: FontWeight.w600))),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: RotationTransition(
                                        turns: new AlwaysStoppedAnimation(
                                            -15 / 360),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                                locale.get(locator<CurrencyService>()
                                    .selectedCurrency
                                    .toUpperCase()),
                                style: GoogleFonts.almarai(
                                    textStyle: TextStyle(
                                        // fontSize: 9,
                                        fontWeight: FontWeight.w600))),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
            Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.blueGrey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      if (item.quantity > 1) {
                        item.quantity--;
                        model.updateCart(context, index, item);
                      }
                    },
                    child: Icon(Icons.remove),
                  ),
                  Text(item.quantity.toString(),
                      style: GoogleFonts.almarai(
                          textStyle: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.bold))),
                  InkWell(
                    borderRadius: BorderRadius.circular(25),
                    onTap: () {
                      if (item.quantity < item.availableQty) {
                        item.quantity++;
                        model.updateCart(context, index, item);
                      }
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(25)),
                      child: Icon(Icons.add),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildEmptyIndicator(AppLocalizations locale) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.remove_shopping_cart),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              locale.get("There is no items in your card") ??
                  "There is no items in your card",
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              locale.get("Start shopping now") ?? "Start shopping now",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  Expanded buildErrorWidget(AppLocalizations locale) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(locale.get("There is no items in your card") ??
                "There is no items in your card"),
          )
        ],
      ),
    );
  }

  Expanded buildLoading() => Expanded(
      child: Center(
          child: CircularProgressIndicator(color: AppColors.accentText)));

  Padding buildHeader(BuildContext context, AppLocalizations locale) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
              onTap: () => Provider.of<HomePageModel>(context, listen: false)
                  .changeTap(context, 0),
              child: Container(child: Icon(Icons.arrow_back_ios, size: 28))),
          Text(
            locale.get('My Cart') ?? 'My Cart',
            style: TextStyle(
              fontFamily: 'Josefin Sans',
              fontSize: 25,
              color: const Color(0xff313131),
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
          Container(width: 28)
        ],
      ),
    );
  }

  checkOutButton(BuildContext context, AppLocalizations local,
      CartPageModel model, Cart cart) {
    return Container(
      width: 255,
      height: 40,
      margin: EdgeInsets.all(10),
      child: FlatButton(
        onPressed: () {
          // Preference.setString(PrefKeys.token, '1' + model.auth.user.token);
          if (model.cart != null && model.cart.lines.length != 0) {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                constraints:
                    BoxConstraints(minHeight: ScreenUtil.screenHeightDp * 0.4),
                builder: (BuildContext context) {
                  return AddressesDialogPage(cart: cart);
                });
          } else {
            UI.toast(local.get("Cart is empty") ?? "Cart is empty");
          }
        },
        padding: EdgeInsets.all(0),
        color: Theme.of(context).colorScheme.secondary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(local.get('Check out now') ?? 'Check out now',
                style: TextStyle(fontSize: 16, color: const Color(0xffffffff))),
            Text('>',
                style: TextStyle(fontSize: 16, color: const Color(0xffffffff))),
          ],
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(15),
        )),
      ),
    );
  }
}
