import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/homePageService/home_page_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/location/locationService.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_in_up_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/option_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class ItemCard extends StatelessWidget {
  final CategoryItems item;

  const ItemCard({
    Key key,
    this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BaseWidget<ItemCardModel>(
      model: ItemCardModel(
        api: Provider.of<Api>(context),
        context: context,
        auth: Provider.of(context),
        item: item,
        favService: Provider.of(context),
        cartService: Provider.of(context),
      ),
      builder: (context, model, child) => Container(
        padding: EdgeInsets.all(8),
        width: ScreenUtil.screenWidthDp / 2,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15),
                bottomRight: Radius.circular(15))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: ScreenUtil.screenHeightDp / 8,
                        child: Center(child: Image.network(model.item.image)
                            // CachedNetworkImage(
                            //   cacheManager: CustomCacheManager.instance,
                            //   placeholder: (context, url) => LoadingIndicator(),
                            //   errorWidget: (context, url, error) => Center(
                            //       child: Image.asset(
                            //     'assets/images/beautyLogo.png',
                            //     scale: 10,
                            //   )),

                            //   imageUrl: model.item.image,
                            //   fadeInCurve: Curves.easeIn,
                            //   // fit: BoxFit.cover,
                            // ),
                            ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RatingBar.builder(
                        initialRating: model.item.cRating.toDouble(),
                        minRating: 0,
                        direction: Axis.horizontal,
                        itemCount: 5,
                        ignoreGestures: true,
                        allowHalfRating: true,
                        onRatingUpdate: (rating) {},
                        itemSize: 20,
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: Text(
                          model.item.name.localized(context) ?? " ",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      model.item.discount == 0
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 3.0, bottom: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      locator<CurrencyService>()
                                              .getPriceWithCurrncy(
                                                  num.parse(model.item.price)) +
                                          "  " +
                                          locale.get(locator<CurrencyService>()
                                              .selectedCurrency
                                              .toUpperCase()),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.accentText,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(top: 3.0, bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      locator<CurrencyService>()
                                              .getPriceWithCurrncy(
                                                  num.parse(model.item.price)) +
                                          "  " +
                                          locale.get(locator<CurrencyService>()
                                              .selectedCurrency
                                              .toUpperCase()),
                                      style: TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontSize: 12,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600)),
                                  Text(
                                      locator<CurrencyService>()
                                              .getPriceWithCurrncy(num.parse(
                                                  model.item.priceAfter)) +
                                          "  " +
                                          locale.get(locator<CurrencyService>()
                                              .selectedCurrency
                                              .toUpperCase()),
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppColors.accentText,
                                          fontWeight: FontWeight.w600))
                                ],
                              ),
                            ),
                    ],
                  ),
                )),
            buildAddAndFavo(context, model),
          ],
        ),
      ),
    );
  }

  Widget buildAddAndFavo(BuildContext context, ItemCardModel model) {
    return Container(
      height: ScreenUtil.portrait
          ? ScreenUtil.screenHeightDp / 20
          : ScreenUtil.screenHeightDp / 11,
      // width: ScreenUtil.screenWidthDp / 1.13,
      decoration: BoxDecoration(
        color: model.item.availableQty != 0 ? Colors.black : Colors.grey[600],
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(12.5),
            bottomRight: Radius.circular(12.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: buildAddToCart(context, model),
          ),
          Container(
            width: 2,
            // height: ScreenUtil.screenHeightDp / 16,
            color: AppColors.accentText,
          ),
          buildFavouriteIcon(model)
        ],
      ),
    );
  }

  Widget buildFavouriteIcon(ItemCardModel model) {
    return Consumer<FavouriteService>(builder: (context, favService, child) {
      final authService = Provider.of<AuthenticationService>(context);
      return InkWell(
        onTap: () {
          authService.userLoged
              ? favService.favourites.lines.any((element) {
                  if (element.item.id == model.item.id) {
                    favService.lineId = element.id;
                    return true;
                  } else {
                    return false;
                  }
                })
                  ? model.removerFromFavourite(AppLocalizations.of(context))
                  : model.addToFavourite(AppLocalizations.of(context))
              : UI.push(context, Routes.signInUp);
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 3.0),
          child: Center(
              child: Icon(
            Icons.favorite,
            color: favService.favourites != null &&
                    favService.favourites.lines
                        .any((element) => element.item.id == item.id)
                ? AppColors.accentText
                : Colors.white,
          )),
        ),
      );
    });
  }

  Widget buildAddToCart(BuildContext context, ItemCardModel model) {
    final locale = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 7.0),
      child: model.item.availableQty > 0
          ? RaisedButton.icon(
              label: Text(
                locale.get("Add to cart") ?? "Add to cart",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: locale.locale == Locale("en") ? 15 : 10),
              ),
              color: Colors.transparent,
              padding: EdgeInsets.all(0),
              icon:
                  Icon(Icons.add_shopping_cart, size: 20, color: Colors.white),
              onPressed: () {
                if (model.auth.userLoged) {
                  if (model.item.availableQty > 0) {
                    model.addToCart();
                  } else {
                    UI.push(
                        context, Routes.item(item: model.item, cartItem: null));
                  }
                } else {
                  UI.push(context, SignInUp());
                }
              })
          : Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                locale.get("Out of quantity" ?? 'Out of quantity'),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}

class ItemCardModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  final FavouriteService favService;
  final CartService cartService;
  final CategoryItems item;

  FormArray form;

  bool clicked = false;

  ItemCardModel(
      {NotifierState state,
      this.api,
      this.auth,
      this.cartService,
      this.favService,
      this.item,
      this.context})
      : super(state: state) {
    if (item.haveOptions) {
      form = FormArray([]);
    }
  }

  addToCart() async {
    final locale = AppLocalizations.of(context);
    if (auth.userLoged) {
      if (clicked) {
        return;
      }
      var availableQuantity = 0;
      clicked = true;
      try {
        availableQuantity =
            await api.getAvailableQuantity(context, param: {'itemId': item.id});
      } catch (e) {
        setIdle();
        UI.toast(locale.get("Error") ?? "Error");
        return;
      }
      if (availableQuantity > 0) {
        Map<String, dynamic> body = {
          "user": {"id": auth.user.user.id},
          "item": {"id": item.id},
          "quantity": 1
        };

        if (item.haveOptions) {
          for (int i = 0; i < item.options.length; i++) {
            var formGroup = new FormGroup({
              'optionText': new FormControl(validators: [Validators.required]),
              'optionValue': new FormControl(validators: [Validators.required]),
              'itemOption': new FormControl(value: item.options[i]),
            }, validators: [
              Validators.required
            ]);
            form.insert(i, formGroup);
          }
          await showOptionsDialog().then((val) async {
            if (val is FormArray && val != null) {
              body['options'] = form.value;
              form = FormArray([]);
            } else {
              form = FormArray([]);
              return;
            }
          });

          if (!body.containsKey("options") || body["options"] == null) {
            clicked = false;
            setState();
            return;
          }
        }

        print(body);

        try {
          final cart = await cartService.addToCart(context, body: body);
          if (cart != null) {
            UI.toast(locale.get("Item added to cart successfully"));
          } else {
            UI.toast(locale.get("Error occured"));
          }
        } catch (e) {
          UI.toast(locale.get("Error") ?? "Error");
        }
      } else {
        UI.toast(locale.get("out of quantity"));
      }
    } else {
      UI.push(context, Routes.signInUp);
    }

    clicked = false;
    setState();
  }

  Future addItemToCart(
      Map<String, dynamic> body, AppLocalizations locale) async {
    try {
      final cart = await cartService.addToCart(context, body: body);
      if (cart != null) {
        UI.toast(locale.get("Item added to cart successfully"));
      } else {
        UI.toast(locale.get("Error occured"));
      }
    } catch (e) {
      UI.toast(locale.get("Error") ?? "Error");
    }
  }

  void addToFavourite(locale) async {
    bool res;
    if (!auth.userLoged) {
      UI.push(context, Routes.signIn);
    } else {
      try {
        res = await favService.addToFavourites(context, itemId: item.id);
      } catch (e) {
        setError();
      }

      if (res) {
        item.inFavorate = true;
        toast(locale.get('item added to favorite'));
        setState();
        setIdle();
      } else {
        setError();
      }
    }
  }

  removerFromFavourite(locale) async {
    bool res;
    try {
      res = await favService.removeFromFavourites(context,
          lineId: favService.favourites.lines
              .firstWhere((element) => element.item.id == item.id, orElse: null)
              ?.id);
    } catch (e) {
      setError();
    }

    if (res) {
      item.inFavorate = false;
      toast(
        locale.get('item removed to favorite'),
      );

      setState();
      setIdle();
    } else {
      setError();
    }
  }

  Future showOptionsDialog() {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation, secondaryAnimation) {},
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: Opacity(
              opacity: anim1.value,
              child: OptionsDialog(form: form, item: item)),
        );
      },
    );
  }
}
