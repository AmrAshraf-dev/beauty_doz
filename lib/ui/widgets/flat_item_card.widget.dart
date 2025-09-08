import 'package:animated/animated.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_in_up_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/shared/styles/styles.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:animated_icon_button/animated_icon_button.dart';

import 'item_card.dart';

class FlatItemCard extends StatefulWidget {
  final CategoryItems item;

  const FlatItemCard({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  State<FlatItemCard> createState() => _FlatItemCardState();
}

class _FlatItemCardState extends State<FlatItemCard> {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BaseWidget<ItemCardModel>(
      model: ItemCardModel(
        api: Provider.of<Api>(context),
        context: context,
        auth: Provider.of(context),
        item: widget.item,
        favService: Provider.of(context),
        cartService: Provider.of(context),
      ),
      builder: (context, model, child) => InkWell(
        onTap: () =>
            UI.push(context, Routes.item(item: widget.item, cartItem: null)),
        radius: 15,
        child: Stack(
          children: [
            Container(
              // width: 180,
              height: 270,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onBackground,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      spreadRadius: 0,
                      color: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.1),
                    )
                  ]),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 180,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(15)),
                    ),
                    child: Center(
                      child: Container(
                        width: 120,
                        height: 130,
                        child: CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 250),
                          fadeOutCurve: Curves.bounceOut,
                          color: Colors.white,
                          colorBlendMode: BlendMode.darken,
                          placeholder: (context, url) => Container(
                            child: Center(
                              child: Image.asset('assets/images/beautyLogo.png',
                                  width: 105, height: 70, fit: BoxFit.contain),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            child: Center(
                              child: Image.asset('assets/images/beautyLogo.png',
                                  width: 105, height: 70, fit: BoxFit.contain),
                            ),
                          ),
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              backgroundBlendMode: BlendMode.darken,
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.bottomCenter),
                            ),
                          ),
                          imageUrl: model.item.image,
                          fadeInCurve: Curves.easeIn,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      model.item?.name?.localized(context) ?? " ",
                      overflow: TextOverflow.clip,
                      maxLines: 2,
                      style: GoogleFonts.almarai(
                          textStyle: TextStyle(
                        fontSize: 18,
                      )),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (model.item.discount == 0)
                            RichText(
                              text: new TextSpan(children: [
                                TextSpan(
                                    text: locator<CurrencyService>()
                                        .getPriceWithCurrncy(
                                            num.parse(model.item.price)),
                                    style: GoogleFonts.almarai(
                                        textStyle: TextStyle(
                                            fontSize: 18,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontWeight: FontWeight.bold)))
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
                                                num.parse(model.item.price)),
                                        style: GoogleFonts.almarai(
                                            textStyle: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey.shade400,
                                                fontWeight: FontWeight.bold))),
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
                                            num.parse(model.item.priceAfter)),
                                    style: GoogleFonts.almarai(
                                        textStyle: TextStyle(
                                            fontSize: 22,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            fontWeight: FontWeight.bold))),
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
                                        fontWeight: FontWeight.bold))),
                          ),
                        ],
                      ),
                      AnimatedIconButton(
                          duration: Duration(milliseconds: 200),
                          animationDirection: AnimationDirection.reverse(),
                          onPressed: () async {
                            if (model.auth.userLoged) {
                              model.cartService.cart != null &&
                                      model.cartService.cart.lines.isNotEmpty &&
                                      model.cartService.cart.lines.any(
                                          (element) =>
                                              element.item.id == model.item.id)
                                  ? await model.cartService.removeFromCart(
                                      context,
                                      userId: model.auth.user.user.id,
                                      lineId: model.cartService.cart.lines
                                          .firstWhere(
                                              (element) =>
                                                  element.item.id ==
                                                  model.item.id,
                                              orElse: null)
                                          ?.id)
                                  : await model.addToCart();
                              setState(() {});
                            } else
                              UI.push(context, Routes.signInUp);
                          },
                          icons: (model.auth.userLoged &&
                                  model.cartService.cart != null &&
                                  model.cartService.cart.lines.isNotEmpty &&
                                  model.cartService.cart.lines.any((element) =>
                                      element.item.id == model.item.id))
                              ? [
                                  AnimatedIconItem(
                                    icon: Icon(
                                      Icons.add_shopping_cart_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                    ),
                                  ),
                                  AnimatedIconItem(
                                    icon: Icon(
                                      Icons.add_shopping_cart_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                    ),
                                  ),
                                ]
                              : [
                                  AnimatedIconItem(
                                    icon: Icon(
                                      Icons.add_shopping_cart_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                    ),
                                  ),
                                  AnimatedIconItem(
                                    icon: Icon(
                                      Icons.add_shopping_cart_outlined,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryVariant,
                                    ),
                                  ),
                                ]),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.item.availableQty < 1)
              Container(
                // width: 180,
                height: 270,
                decoration: BoxDecoration(
                    color: Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.5),
                    gradient: Gradients.accentGradient,
                    borderRadius: BorderRadius.circular(15)),
                child: Center(
                  child: Text(locale.get('Sold Out'),
                      style: GoogleFonts.almarai(
                          textStyle: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ))),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
// 