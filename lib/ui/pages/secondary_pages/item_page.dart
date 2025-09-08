import 'package:beautydoz/core/page_models/main_pages_models/home_page/home_page_model.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/page_models/secondary_pages/item_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_in_up_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/brand_items_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/new_search_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/recovery_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:beautydoz/ui/widgets/reactive_widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

@immutable
class ItemPage extends StatelessWidget {
  final int itemId;

  final Lines cartItem;

  ItemPage({this.itemId, this.cartItem});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return BaseWidget<ItemPageModel>(
        model: ItemPageModel(
            api: Provider.of<Api>(context),
            auth: Provider.of(context),
            categoryService: Provider.of(context),
            cartService: Provider.of(context),
            favouriteService: Provider.of(context),
            cartItem: cartItem,
            itemId: itemId),
        initState: (model) => model.getItemById(context),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            extendBodyBehindAppBar: true,
            // backgroundColor: AppColor,
            appBar: PreferredSize(
              child: NewAppBar(
                  title: '',
                  returnBtn: true,
                  drawer: false,
                  onLanguageChanged: () {
                    model.setState();
                  }),
              preferredSize: Size(ScreenUtil.screenWidthDp, 80),
            ),
            body: SafeArea(
              child: Container(
                  child: Column(children: <Widget>[
                if (model.busy) ...[
                  Expanded(
                      child: Center(
                          child: CircularProgressIndicator(
                    color: AppColors.accentText,
                  )))
                ] else ...[
                  buildItemBody(locale, context, model),
                  // buildAddAndFavo(context, model),
                  // Center(
                  //     child: Padding(
                  //   padding: EdgeInsets.all(8),
                  //   child: InkWell(
                  //     onTap: () {
                  //       UI.push(context, RecoveryPage());
                  //     },
                  //     child: Text(
                  //       locale.get("Returns & Exchange Policy") ??
                  //           "Returns & Exchange Policy",
                  //       style: TextStyle(
                  //           color: Theme.of(context).textTheme.bodyText1.color,
                  //           fontSize: 16,
                  //           fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // )),
                ],
              ])),
            ),
            extendBody: true,

            // bottomNavigationBar: buildAddAndFavo(context, model),
          );
        });
    // });
  }

  Widget buildItemBody(
      AppLocalizations locale, BuildContext context, ItemPageModel model) {
    return Expanded(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: ScreenUtil.screenWidthDp / 1.25,
                      child: Container(
                        decoration: BoxDecoration(
                            color: AppColors.accentBackground,
                            borderRadius: BorderRadius.circular(200)),
                        child: Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: CachedNetworkImage(
                              cacheManager: CustomCacheManager.instance,
                              placeholder: (context, url) => LoadingIndicator(),
                              imageUrl: model.item.image,
                              colorBlendMode: BlendMode.multiply,
                              color: AppColors.accentBackground,
                              width: ScreenUtil.screenWidthDp,
                              errorWidget: (context, url, error) =>
                                  GestureDetector(
                                    onTap: () {
                                      UI.pushReplaceAll(context,
                                          Routes.home); //* adding navigation
                                    },
                                    child: Center(
                                        child: Image.asset(
                                      'assets/images/beautyLogo.png',
                                      scale: 2,
                                    )),
                                  )),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: ScreenUtil.screenWidthDp,
                      padding: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(12.5)),
                          gradient: LinearGradient(
                              begin: FractionalOffset.topCenter,
                              end: FractionalOffset.bottomCenter,
                              colors: [
                                AppColors.accentText.withOpacity(0.3),
                                AppColors.accentText.withOpacity(0)
                              ],
                              stops: [
                                0.0,
                                1.0
                              ])),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    // model.item.categories != null &&
                                    //         model.item.categories.isNotEmpty
                                    //     ? model.item.categories
                                    //         .map((e) =>
                                    //             e.name.localized(context))
                                    //         .first
                                    //     : '' +
                                    ' ${locale.get('for').toUpperCase()} ${locale.get(model.item.gender).toUpperCase()}',
                                    style: GoogleFonts.almarai(
                                        textStyle: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                    ))),
                                Spacer(),
                                model.item.discount == 0
                                    ? RichText(
                                        text: new TextSpan(children: [
                                          TextSpan(
                                              text: locator<CurrencyService>()
                                                  .getPriceWithCurrncy(
                                                      num.parse(
                                                          model.item.price)),
                                              style: GoogleFonts.almarai(
                                                  textStyle: TextStyle(
                                                      fontSize: 35,
                                                      color:
                                                          AppColors.accentText,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          TextSpan(
                                              text: locale.get(
                                                  locator<CurrencyService>()
                                                      .selectedCurrency
                                                      .toUpperCase()),
                                              style: GoogleFonts.almarai(
                                                  textStyle: TextStyle(
                                                      fontSize: 9,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .color,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                        ]),
                                      )
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          clipBehavior: Clip.none,
                                          children: [
                                            Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    Text(
                                                        locator<CurrencyService>()
                                                            .getPriceWithCurrncy(
                                                                num.parse(model
                                                                    .item
                                                                    .price)),
                                                        style: GoogleFonts.almarai(
                                                            textStyle: TextStyle(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .grey
                                                                    .shade400,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600))),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 8.0),
                                                      child: RotationTransition(
                                                        turns:
                                                            new AlwaysStoppedAnimation(
                                                                -15 / 360),
                                                        child: Container(
                                                            height: 1,
                                                            width: 50,
                                                            color: Colors
                                                                .redAccent,
                                                            child: Text('1')),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                    locale.get(locator<
                                                            CurrencyService>()
                                                        .selectedCurrency
                                                        .toUpperCase()),
                                                    style: GoogleFonts.almarai(
                                                        textStyle: TextStyle(
                                                            fontSize: 15,
                                                            color: AppColors
                                                                .primaryText,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                              ],
                                            ),
                                            Positioned(
                                              bottom: 15,
                                              left: 5,
                                              child: Text(
                                                  locator<CurrencyService>()
                                                      .getPriceWithCurrncy(
                                                          num.parse(model.item
                                                              .priceAfter)),
                                                  style: GoogleFonts.almarai(
                                                      textStyle: TextStyle(
                                                          fontSize: 35,
                                                          color: AppColors
                                                              .accentText,
                                                          fontWeight: FontWeight
                                                              .w900))),
                                            )
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                            Text(model.item.name.localized(context),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.almarai(
                                    textStyle: TextStyle(
                                        fontSize: 24,
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1
                                            .color,
                                        fontWeight: FontWeight.w800))),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: RatingBar.builder(
                                initialRating:
                                    model?.item?.cRating?.toDouble() ?? 0,
                                minRating: 0,
                                direction: Axis.horizontal,
                                itemCount: 5,
                                ignoreGestures: true,
                                allowHalfRating: true,
                                onRatingUpdate: (rating) {},
                                itemSize: 30,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: AppColors.accentText,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                    width: 72,
                                    height: 72,
                                    decoration: BoxDecoration(
                                        color: AppColors.primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: InkWell(
                                      onTap: () {
                                        UI.push(
                                            context,
                                            BrandItemsPage(
                                              brand: model.item.brand,
                                            ));
                                      },
                                      child: CachedNetworkImage(
                                        cacheManager:
                                            CustomCacheManager.instance,
                                        placeholder: (context, url) =>
                                            LoadingIndicator(),
                                        errorWidget: (context, url, error) =>
                                            GestureDetector(
                                          onTap: () {
                                            UI.push(
                                                context,
                                                Routes
                                                    .home); //* adding navigation
                                          },
                                          child: Center(
                                              child: Image.asset(
                                            'assets/images/beautyLogo.png',
                                            scale: 10,
                                          )),
                                        ),
                                        colorBlendMode: BlendMode.multiply,
                                        color: AppColors.primaryBackground,
                                        imageUrl: model.item.brand.image,
                                        fadeInCurve: Curves.easeIn,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: InkWell(
                                    onTap: () {
                                      UI.push(
                                          context,
                                          BrandItemsPage(
                                            brand: model.item.brand,
                                          ));
                                    },
                                    child: Text(
                                        model.item.brand.name
                                            .localized(context),
                                        style: GoogleFonts.almarai(
                                            textStyle: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color,
                                        ))),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                  model.item.description?.localized(context) ??
                                      '',
                                  style: GoogleFonts.almarai(
                                      textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyText1
                                        .color
                                        .withOpacity(0.8),
                                  ))),
                            )
                          ],
                        ),
                      ),
                    ),
                    buildAddAndFavo(context, model)

                    // Container(
                    //   padding: EdgeInsets.only(
                    //       left: 5,
                    //       top: locale.locale == Locale("en") ? 10 : 5,
                    //       bottom: 15),
                    //   width: ScreenUtil.screenWidthDp * 0.85,
                    //   child: Text(
                    //     model.item.name.localized(context),
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       fontFamily: 'Josefin Sans',
                    //       fontSize: 25,
                    //       color: const Color(0xff313131),
                    //       fontWeight: FontWeight.w700,
                    //     ),
                    //   ),
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     model.item.discount == 0
                    //         ? Padding(
                    //             padding: EdgeInsets.symmetric(horizontal: 14),
                    //             child: Text(
                    //                 locator<CurrencyService>()
                    //                         .getPriceWithCurrncy(
                    //                             num.parse(model.item.price)) +
                    //                     " " +
                    //                     locator<CurrencyService>()
                    //                         .selectedCurrency
                    //                         .toUpperCase(),
                    //                 style: TextStyle(
                    //                     fontSize: 20,
                    //                     color: AppColors.accentText)),
                    //           )
                    //         : Row(
                    //             children: [
                    //               Padding(
                    //                 padding:
                    //                     EdgeInsets.symmetric(horizontal: 10),
                    //                 child: Text(
                    //                     locator<CurrencyService>()
                    //                             .getPriceWithCurrncy(num.parse(
                    //                                 model.item.price)) +
                    //                         " " +
                    //                         locator<CurrencyService>()
                    //                             .selectedCurrency
                    //                             .toUpperCase(),
                    //                     style: TextStyle(
                    //                         fontSize: 14,
                    //                         decoration:
                    //                             TextDecoration.lineThrough,
                    //                         color: Colors.grey)),
                    //               ),
                    //               Padding(
                    //                 padding:
                    //                     EdgeInsets.symmetric(horizontal: 8),
                    //                 child: Text(
                    //                     locator<CurrencyService>()
                    //                             .getPriceWithCurrncy(num.parse(
                    //                                 model.item.priceAfter)) +
                    //                         " " +
                    //                         locator<CurrencyService>()
                    //                             .selectedCurrency
                    //                             .toUpperCase(),
                    //                     style: TextStyle(
                    //                         fontSize: 18,
                    //                         color: AppColors.accentText)),
                    //               )
                    //             ],
                    //           ),
                    //     Padding(
                    //       padding: EdgeInsets.symmetric(horizontal: 10),
                    //       child: Text(
                    //           locale.get(model.item.gender) ??
                    //               model.item.gender,
                    //           style: TextStyle(
                    //               fontSize: 14, color: AppColors.accentText)),
                    //     )
                    //   ],
                    // ),
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //     left: 50,
                    //     right: 50,
                    //     top: 8,
                    //   ),
                    //   child: Divider(
                    //     color: AppColors.accentText,
                    //     thickness: 0.7,
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(vertical: 16.0),
                    //   child: Text(
                    //     locale.get("Delivery Within 24 Hours") ??
                    //         "Delivery Within 24 Hours",
                    //     style: TextStyle(
                    //         fontSize: 18, color: AppColors.accentText),
                    //   ),
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Row(
                    //       children: [
                    //         Padding(
                    //           padding: EdgeInsets.symmetric(horizontal: 16),
                    //           child: Container(
                    //               width: 30,
                    //               height: 30,
                    //               child: CachedNetworkImage(
                    //                 cacheManager: CustomCacheManager.instance,
                    //                 placeholder: (context, url) =>
                    //                     LoadingIndicator(),
                    //                 errorWidget: (context, url, error) =>
                    //                     GestureDetector(
                    //                   onTap: () {
                    //                     UI.push(context,
                    //                         Routes.home); //* adding navigation
                    //                   },
                    //                   child: Center(
                    //                       child: Image.asset(
                    //                     'assets/images/beautyLogo.png',
                    //                     scale: 10,
                    //                   )),
                    //                 ),
                    //                 imageUrl: model.item.brand.image,
                    //                 fadeInCurve: Curves.easeIn,
                    //                 fit: BoxFit.cover,
                    //               )),
                    //         ),
                    //         Padding(
                    //           padding: EdgeInsets.symmetric(horizontal: 8),
                    //           child: Text(
                    //               model.item.brand.name.localized(context),
                    //               style: TextStyle(
                    //                   fontSize: 20,
                    //                   color: AppColors.accentText)),
                    //         )
                    //       ],
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         UI.push(context,
                    //             Routes.brandItems(brand: model.item.brand));
                    //       },
                    //       child: Padding(
                    //         padding: EdgeInsets.symmetric(horizontal: 16),
                    //         child: Text(locale.get("More" ?? "More"),
                    //             style: TextStyle(
                    //                 fontSize: 18,
                    //                 fontFamily: 'Josefin Sans',
                    //                 fontStyle: FontStyle.normal,
                    //                 fontWeight: FontWeight.normal,
                    //                 color: AppColors.accentText)),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: RatingBar.builder(
                    //     initialRating: model?.item?.cRating?.toDouble() ?? 0,
                    //     minRating: 0,
                    //     direction: Axis.horizontal,
                    //     itemCount: 5,
                    //     ignoreGestures: true,
                    //     allowHalfRating: true,
                    //     onRatingUpdate: (rating) {},
                    //     itemSize: 25,
                    //     itemBuilder: (context, _) => Icon(
                    //       Icons.star,
                    //       color: Colors.amber,
                    //     ),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       left: 16.0, right: 16, bottom: 8),
                    //   child: Text(model.item.description.localized(context),
                    //       style: TextStyle(fontSize: 20, color: Theme.of(context).textTheme.bodyText1.color)),
                    // ),
                    // if (model.item.haveOptions &&
                    //     model.item.options != null &&
                    //     model.item.options.isNotEmpty) ...[
                    //   buildOptionsSection(model, model.item)
                    // ],
                    // if (model.item.reviews != null &&
                    //     model.item.reviews.isNotEmpty) ...[
                    //   buildReviewSection(model, model.item)
                    // ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildOptionsSection2(ItemPageModel model, CategoryItems item) {
    return ReactiveFormArray(
      formArray: model.form,
      builder: (context, formArray, child) => ListView.builder(
          shrinkWrap: true,
          itemCount: formArray.controls.length ?? 0,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return buildOptionsContainer(context, index, model, item);
          }),
    );
  }

  buildOptionsContainer(BuildContext context, int index, ItemPageModel model,
      CategoryItems item) {
    final locale = AppLocalizations.of(context);
    return Padding(
      padding:
          const EdgeInsets.only(left: 12.0, right: 12, top: 15, bottom: 12),
      child: Container(
        // height: ScreenUtil.screenHeightDp / 4.5,
        // width: ScreenUtil.screenWidthDp / 1.25,
        child: Row(
          // crossAxisAlignment: CrossAxisAlignment.,
          children: [
            Text(model.item.options[index].name.localized(context)),
            Text(" : "),
            if (model.form.controls[index].value['itemOption'].isText) ...[
              Expanded(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ReactiveField(
                      type: ReactiveFields.TEXT,
                      controllerName: "$index.optionText",
                      borderColor: AppColors.accentText,
                      hint:
                          model.form.control("$index.optionText").value != null
                              ? model.form.control("$index.optionText").value
                              : locale.get("Enter option") ?? "Enter option",
                    )),
              )
            ] else ...[
              Expanded(
                  child: ReactiveField(
                type: ReactiveFields.DROP_DOWN,
                context: context,
                borderColor: AppColors.accentText,
                filled: true,
                fillColor: Colors.white,
                controllerName: "$index.optionValue",
                items: model.form.value[index]["itemOption"].values,
                hint: model.form.control("$index.optionValue").value != null
                    ? model.form
                        .control("$index.optionValue")
                        .value
                        .name
                        .localized(context)
                    : locale.get("Select an option") ?? "Select an option",
              ))
            ]
          ],
        ),
      ),
    );
  }

  Widget buildReviewSection(ItemPageModel model, CategoryItems item) {
    return Container(
      height: ScreenUtil.screenHeightDp / 4.5,
      width: double.infinity,
      child: ListView.builder(
          itemCount: item.reviews.length ?? 0,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return buildReviewCard(context, index, model, item);
          }),
    );
  }

  Widget buildReviewCard(BuildContext context, int index, ItemPageModel model,
      CategoryItems item) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 12.0, right: 12, top: 15, bottom: 12),
      child: Container(
        height: ScreenUtil.screenHeightDp / 4.5,
        width: ScreenUtil.screenWidthDp / 1.25,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .color
                    .withOpacity(0.2),
                offset: Offset(0, 0),
                blurRadius: 10,
              )
            ],
            borderRadius: BorderRadius.circular(5),
            color: AppColors.primaryBackground),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.reviews[index].user.name,
                    overflow: TextOverflow.visible,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: RatingBar.builder(
                      initialRating:
                          item?.reviews[index]?.rating?.toDouble() ?? 0,
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
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 8.0,
                bottom: 8.0,
                right: 8.0,
              ),
              child: Text(
                item.reviews[index].comment,
                maxLines: 3,
                overflow: TextOverflow.clip,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAddAndFavo(BuildContext context, ItemPageModel model) {
    final locale = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Align(
              alignment: locale.locale.languageCode == 'en'
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20, right: 20, left: 20),
                child: Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.accentText.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (model.selectedQuantity > 1) {
                                model.selectedQuantity--;
                                model.setState();
                              }
                            },
                            icon: Icon(Icons.remove,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                          ),
                          Text(model.selectedQuantity.toString(),
                              style: GoogleFonts.almarai(
                                  textStyle: TextStyle(
                                      fontSize: 26,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1
                                          .color,
                                      fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),
                    Positioned(
                      right: locale.locale.languageCode == 'en' ? 0 : null,
                      left: locale.locale.languageCode != 'en' ? 0 : null,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () {
                          if (model.selectedQuantity <
                              model.item.availableQty) {
                            model.selectedQuantity++;
                            model.setState();
                          }
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppColors.accentText,
                              borderRadius: BorderRadius.circular(25)),
                          child: Icon(Icons.add, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ?
              buildAddToCart(context, model.item, model),
              // model.item.availableQty != 0
              //     : Text(
              //         locale.get("Out of quantity" ?? 'Out of quantity'),
              //         style: TextStyle(
              //             color: Colors.white,
              //             fontSize: 18,
              //             fontWeight: FontWeight.bold),
              //       ),
              // Container(
              //   width: 2,
              //   // height: ScreenUtil.screenHeightDp / 16,
              //   color: Colors.white,
              // ),
              buildBuyNow(context, model, model.item)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBuyNow(
      BuildContext context, ItemPageModel model, CategoryItems item) {
    final locale = AppLocalizations.of(context);
    return Consumer<FavouriteService>(builder: (context, favService, child) {
      final authService = Provider.of<AuthenticationService>(context);

      return InkWell(
        focusColor: Colors.blueGrey,
        highlightColor: Colors.blueGrey.withOpacity(0.2),
        splashColor: Colors.blueGrey,
        hoverColor: Colors.blueGrey,
        borderRadius: BorderRadius.horizontal(
            right: locale.locale.languageCode == 'en'
                ? Radius.circular(25)
                : Radius.zero,
            left: locale.locale.languageCode != 'en'
                ? Radius.circular(25)
                : Radius.zero),
        onTap: () {
          model.buyNow(context);
        },
        child: Container(
          width: ScreenUtil.screenWidthDp / 2.75,
          height: 60,
          decoration: BoxDecoration(
              color: item.availableQty > 0
                  ? AppColors.accentText.withOpacity(0.4)
                  : Colors.blueGrey.withOpacity(0.4),
              borderRadius: BorderRadius.horizontal(
                  right: locale.locale.languageCode == 'en'
                      ? Radius.circular(25)
                      : Radius.zero,
                  left: locale.locale.languageCode != 'en'
                      ? Radius.circular(25)
                      : Radius.zero)),
          child: Center(
              child: Text(locale.get(item.availableQty > 0 ? 'Buy Now' : '-'),
                  style: GoogleFonts.almarai(
                      textStyle: TextStyle(
                          fontSize: 18,
                          color: Theme.of(context).textTheme.bodyText1.color,
                          fontWeight: FontWeight.bold)))),
        ),
      );
    });
  }

  Widget buildAddToCart(
      BuildContext context, CategoryItems item, ItemPageModel model) {
    final locale = AppLocalizations.of(context);
    return Consumer<CartService>(builder: (context, cartService, child) {
      return InkWell(
        focusColor: Colors.blueGrey,
        highlightColor: Colors.blueGrey.withOpacity(0.2),
        splashColor: Colors.blueGrey,
        hoverColor: Colors.blueGrey,
        radius: 25,
        borderRadius: BorderRadius.horizontal(
            left: locale.locale.languageCode == 'en'
                ? Radius.circular(25)
                : Radius.zero,
            right: locale.locale.languageCode != 'en'
                ? Radius.circular(25)
                : Radius.zero),
        onTap: () {
          model.addToCart2(context);
        },
        child: Container(
          width: ScreenUtil.screenWidthDp / 2,
          height: 60,
          decoration: BoxDecoration(
              color: item.availableQty > 0
                  ? AppColors.accentText
                  : Colors.blueGrey,
              borderRadius: BorderRadius.horizontal(
                  left: locale.locale.languageCode == 'en'
                      ? Radius.circular(25)
                      : Radius.zero,
                  right: locale.locale.languageCode != 'en'
                      ? Radius.circular(25)
                      : Radius.zero)),
          child: Center(
              child: Text(
                  locale
                      .get(item.availableQty > 0 ? 'Add To Cart' : 'Sold Out'),
                  style: GoogleFonts.almarai(
                      textStyle: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)))),
        ),
      );
    });
  }
}
