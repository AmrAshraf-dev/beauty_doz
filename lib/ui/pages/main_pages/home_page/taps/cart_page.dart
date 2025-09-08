// import 'package:beautydoz/core/models/wrapping-model.dart';
// import 'package:beautydoz/core/services/api/http_api.dart';
// import 'package:beautydoz/core/services/base_notifier.dart';
// import 'package:beautydoz/core/models/carts.dart';
// import 'package:beautydoz/core/page_models/main_pages_models/home_page/home_page_model.dart';
// import 'package:beautydoz/core/page_models/main_pages_models/home_page/taps/cart_page_model.dart';
// import 'package:beautydoz/core/services/api/api.dart';
// import 'package:beautydoz/core/services/base_widget.dart';
// import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
// import 'package:beautydoz/core/services/cart/cart_service.dart';
// import 'package:beautydoz/core/services/currency/currency.service.dart';
// import 'package:beautydoz/core/services/homePageService/home_page_service.dart';
// import 'package:beautydoz/core/services/localization/localization.dart';
// import 'package:beautydoz/core/services/location/locationService.dart';
// import 'package:beautydoz/core/services/screen_util.dart';
// import 'package:beautydoz/core/utils/provider_setup.dart';
// import 'package:beautydoz/ui/pages/secondary_pages/addresses_dialog_page.dart';
// import 'package:beautydoz/ui/routes/routes.dart';
// import 'package:beautydoz/ui/shared/styles/colors.dart';
// import 'package:beautydoz/ui/shared/styles/text_styles.dart';
// import 'package:beautydoz/ui/widgets/buttons/normal_button.dart';
// import 'package:beautydoz/ui/widgets/loading_widget.dart';
// import 'package:beautydoz/ui/widgets/reactive_widgets.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';
// import 'package:reactive_forms/reactive_forms.dart';
// import 'package:ui_utils/ui_utils.dart';

// class CartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final locale = AppLocalizations.of(context);

//     return BaseWidget<CartPageModel>(
//         model: CartPageModel(
//           state: NotifierState.busy,
//           auth: Provider.of(context),
//           api: Provider.of<Api>(context),
//           categoryService: Provider.of(context),
//           cartService: Provider.of(context),
//         ),
//         initState: (model) => WidgetsBinding.instance
//             .addPostFrameCallback((_) => model.getCartsforUser(context)),
//         builder: (context, model, child) {
//           return Consumer<CartService>(builder: (context, csmodel, child) {
//             return SafeArea(
//               child: Container(
//                   width: ScreenUtil.screenWidthDp,
//                   height: ScreenUtil.screenHeightDp,
//                   color: AppColors.primaryBackground,
//                   child: Column(
//                     children: <Widget>[
//                       logo(context),
//                       buildHeader(context, locale),
//                       model.busy
//                           ? buildLoading()
//                           : model.hasError
//                               ? buildErrorWidget(locale)
//                               : Expanded(
//                                   child: Stack(
//                                     fit: StackFit.expand,
//                                     alignment: Alignment.topCenter,
//                                     children: <Widget>[
//                                       Container(
//                                         margin: EdgeInsets.only(bottom: 40),
//                                         padding: const EdgeInsets.symmetric(
//                                             horizontal: 10),
//                                         child: model.cart.lines.isEmpty
//                                             ? buildEmptyIndicator(locale)
//                                             : buildCartItemsList(context,
//                                                 csmodel, model, locale),
//                                       ),
//                                       buildCheckoutWidget(
//                                           locale, csmodel, context, model)
//                                     ],
//                                   ),
//                                 ),
//                     ],
//                   )),
//             );
//           });
//         });
//   }

//   Widget buildCheckoutWidget(AppLocalizations locale, CartService csmodel,
//       BuildContext context, CartPageModel model) {
//     return model?.cart != null && model.cart?.id != null
//         ? Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: ScreenUtil.screenHeightDp / 4,
//               alignment: Alignment.bottomCenter,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: <Widget>[
//                   Container(
//                     width: double.infinity,
//                     height: 60,
//                     // height: ScreenUtil.screenHeightDp / 12,
//                     color: AppColors.accentBackground.withOpacity(0.5),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: <Widget>[
//                         Text(locale.get('TOTAL') ?? 'TOTAL'),
//                         Text(locator<CurrencyService>().getPriceWithCurrncy(
//                                 num.tryParse(model?.cart?.totalPrice ?? '0') ??
//                                     0) +
//                             " " +
//                             locale.get(locator<CurrencyService>()
//                                 .selectedCurrency
//                                 .toUpperCase()))
//                       ],
//                     ),
//                   ),
//                   checkOutButton(context, locale, model, csmodel.cart)
//                 ],
//               ),
//             ),
//           )
//         : SizedBox();
//   }

//   ListView buildCartItemsList(BuildContext context, CartService csmodel,
//       CartPageModel model, AppLocalizations locale) {
//     int selectedWrapping;
//     //int index;
//     return ListView(
//       children: [
//         if (csmodel?.cart?.lines?.isNotEmpty ?? false)
//           ...csmodel.cart.lines
//               .map((line) => buildCartItem(model, context, line,
//                   csmodel.cart.lines.indexOf(line), csmodel, locale))
//               .toList(),
//         if (model.cart?.giftWrapping == null)
//           InkWell(
//             onTap: () async {
//               model.setBusy();
//               // get wrappings
//               List<Wrapping> wrappings =
//                   await locator<HttpApi>().getWrappings(context);
//               model.setIdle();

//               // show modal bottom sheet
//               showModalBottomSheet(
//                 context: context,
//                 elevation: 0,
//                 backgroundColor: Colors.transparent,
//                 barrierColor: Colors.black.withOpacity(0.5),
//                 isScrollControlled: true,
//                 builder: (context) {
//                   return Container(
//                     height: ScreenUtil.screenHeightDp * 0.9,
//                     width: ScreenUtil.screenWidthDp,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       // borderRadius: BorderRadius.only(
//                       //   topLeft: const Radius.circular(50.0),
//                       //   topRight: const Radius.circular(50.0),
//                       // ),
//                     ),
//                     padding: EdgeInsets.all(16),
//                     child: StatefulBuilder(
//                         builder: (BuildContext context, innerSetState) {
//                       return ReactiveForm(
//                         formGroup: model.wrappingForm,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(locale.get('Select Wrapping Design'),
//                                   style: TextStyles.subHeaderStyle
//                                       .copyWith(fontSize: 14)),
//                             ),
//                             Container(
//                               height: 120,
//                               child: ListView.separated(
//                                 itemCount: wrappings.length,
//                                 scrollDirection: Axis.horizontal,
//                                 separatorBuilder: (context, index) => SizedBox(
//                                   width: 8,
//                                 ),
//                                 itemBuilder: (context, index) {
//                                   Wrapping wrapping = wrappings[index];
//                                   return Column(
//                                     children: [
//                                       CachedNetworkImage(
//                                         imageUrl: wrapping.image,
//                                         imageBuilder:
//                                             (context, imageProvider) => InkWell(
//                                           onTap: () {
//                                             model.wrappingForm
//                                                 .control('wrapping')
//                                                 .updateValue(wrapping.toJson());
//                                             selectedWrapping = wrapping.id;
//                                             model.selectedWrapping = wrapping;
//                                             innerSetState(() {});
//                                           },
//                                           child: Container(
//                                             height: 80,
//                                             width: 80,
//                                             decoration: BoxDecoration(
//                                               border: selectedWrapping ==
//                                                       wrapping.id
//                                                   ? Border.all(
//                                                       color:
//                                                           AppColors.accentText,
//                                                       style: BorderStyle.solid,
//                                                       width: 2)
//                                                   : Border.all(width: 0),
//                                               image: DecorationImage(
//                                                   image: imageProvider,
//                                                   fit: BoxFit.cover),
//                                             ),
//                                           ),
//                                         ),
//                                         placeholder: (context, url) =>
//                                             CircularProgressIndicator(
//                                           color: AppColors.accentText,
//                                         ),
//                                         errorWidget: (context, url, error) =>
//                                             GestureDetector(
//                                           onTap: () {
//                                             UI.push(context, Routes.home,
//                                                 replace:
//                                                     true); //* adding navigation
//                                           },
//                                           child: SvgPicture.asset(
//                                             "assets/images/beautyLogo.svg",
//                                             width: ScreenUtil.screenWidthDp,
//                                             // height: ScreenUtil.screenHeightDp,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                       ),
//                                       SizedBox(
//                                         height: 10,
//                                       ),
//                                       Text(
//                                           locator<CurrencyService>()
//                                                   .getPriceWithCurrncy(
//                                                       num.tryParse(
//                                                           wrapping.price)) +
//                                               " " +
//                                               locale.get(
//                                                   locator<CurrencyService>()
//                                                       .selectedCurrency
//                                                       .toUpperCase()),
//                                           style: TextStyle(
//                                               fontSize: 15,
//                                               color: AppColors.accentText,
//                                               fontWeight: FontWeight.bold)),
//                                     ],
//                                   );
//                                 },
//                               ),
//                             ),
//                             ReactiveValueListenableBuilder(
//                               formControlName: 'wrapping',
//                               builder: (context, control, child) {
//                                 return control.hasError('required') &&
//                                         model.wrappingForm.touched
//                                     ? Row(
//                                         children: [
//                                           Text(
//                                               locale.get(
//                                                   'Please Select Wrapping Design'),
//                                               style: Theme.of(context)
//                                                   .textTheme
//                                                   .caption
//                                                   .copyWith(
//                                                       color: Colors.red,
//                                                       fontSize: 15)),
//                                         ],
//                                       )
//                                     : SizedBox();
//                               },
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: ReactiveField(
//                                 context: context,
//                                 controllerName: 'from',
//                                 label: locale.get("From"),
//                                 type: ReactiveFields.TEXT,
//                                 hint: locale.get("From"),
//                                 filled: true,
//                                 validationMesseges: {
//                                   'required':
//                                       locale.get('Sender Name is Required')
//                                 },
//                                 fillColor: Colors.white,
//                                 enabledBorderColor: Colors.grey,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: ReactiveField(
//                                 context: context,
//                                 controllerName: 'to',
//                                 type: ReactiveFields.TEXT,
//                                 label: locale.get("To"),
//                                 hint: locale.get("To"),
//                                 validationMesseges: {
//                                   'required':
//                                       locale.get('Reciver Name is Required')
//                                 },
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 enabledBorderColor: Colors.grey,
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: ReactiveField(
//                                 context: context,
//                                 controllerName: 'message',
//                                 label: locale.get("Message"),
//                                 type: ReactiveFields.TEXT,
//                                 maxLines: 5,
//                                 hint: locale.get("Message"),
//                                 validationMesseges: {
//                                   'required': locale.get('Message is Required')
//                                 },
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 enabledBorderColor: Colors.grey,
//                               ),
//                             ),
//                             ReactiveFormConsumer(
//                               builder: (context, formGroup, child) =>
//                                   NormalButton(
//                                 gradient: formGroup.valid
//                                     ? LinearGradient(
//                                         begin: FractionalOffset.centerLeft,
//                                         end: FractionalOffset.centerRight,
//                                         colors: [
//                                             AppColors.accentText
//                                                 .withOpacity(0.4),
//                                             AppColors.accentText
//                                           ],
//                                         stops: [
//                                             0.0,
//                                             1.0
//                                           ])
//                                     : null,
//                                 text: locale.get('Confirm'),
//                                 onPressed: formGroup.valid
//                                     ? () async {
//                                         Cart cart = await locator<HttpApi>()
//                                             .addWrapping(context,
//                                                 body: formGroup.value);
//                                         model.cart = cart;
//                                         model.setState();
//                                         Navigator.pop(context);
//                                       }
//                                     : null,
//                               ),
//                             )
//                           ],
//                         ),
//                       );
//                     }),
//                   );
//                 },
//               );
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: Container(
//                 height: 70,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   gradient: LinearGradient(
//                       begin: FractionalOffset.topRight,
//                       end: FractionalOffset.bottomLeft,
//                       colors: [
//                         AppColors.accentText.withOpacity(0.8),
//                         AppColors.accentText,
//                         AppColors.accentText.withOpacity(0.4)
//                       ],
//                       stops: [
//                         0.0,
//                         0.7,
//                         1
//                       ]),
//                 ),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Icon(
//                       Icons.card_giftcard,
//                       color: Colors.white,
//                     ),
//                     Text(
//                       locale.get('Add Gift Wrapping'),
//                       style: TextStyle(color: Colors.white, fontSize: 20),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           )
//         else
//           Container(
//             padding: EdgeInsets.symmetric(vertical: 11, horizontal: 0),
//             height: 120,
//             width: double.infinity,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 Container(
//                   width: ScreenUtil.screenWidthDp / 3,
//                   // height: double.infinity,
//                   child: Card(
//                     elevation: 3.5,
//                     clipBehavior: Clip.antiAlias,
//                     margin: EdgeInsetsDirectional.only(end: 10),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8.0)),
//                     child: CachedNetworkImage(
//                       cacheManager: CustomCacheManager.instance,
//                       imageUrl: model.cart.giftWrapping.wrapping.image,
//                       placeholder: (context, url) => LoadingIndicator(),
//                       errorWidget: (context, url, error) => GestureDetector(
//                         onTap: () {
//                           UI.push(context, Routes.home,
//                               replace: true); //* adding navigation
//                         },
//                         child: Center(
//                           child: Image.asset(
//                             'assets/images/beautyLogo.png',
//                             scale: 10,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Expanded(
//                   child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Spacer(),
//                         Text(
//                           locale.get('Gift Wrapping Service'),
//                           style: TextStyle(fontSize: 20),
//                           maxLines: 1,
//                           overflow: TextOverflow.clip,
//                         ),
//                         Spacer(),
//                         Container(
//                           height: 35,
//                           width: 120,
//                           decoration: BoxDecoration(
//                               color: Colors.grey[400],
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(15))),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: <Widget>[
//                               IconButton(
//                                 onPressed: () async {
//                                   if (model.cart.giftWrapping.qty > 1) {
//                                     GiftWrapping gw = model.cart.giftWrapping;
//                                     gw.qty--;
//                                     Cart cart = await locator<HttpApi>()
//                                         .addWrapping(context,
//                                             body: gw.toJson());
//                                     model.cart = cart;
//                                     model.setState();
//                                   }
//                                 },
//                                 color: AppColors.secondaryText,
//                                 icon: Icon(Icons.remove, size: 19),
//                               ),
//                               Text(model.cart.giftWrapping.qty.toString(),
//                                   style: TextStyle(
//                                       fontSize: 14,
//                                       color: AppColors.secondaryText,
//                                       fontWeight: FontWeight.bold)),
//                               IconButton(
//                                 onPressed: () async {
//                                   if (model.cart.giftWrapping.qty <
//                                       model.cart.totalItems) {
//                                     GiftWrapping gw = model.cart.giftWrapping;
//                                     gw.qty++;
//                                     Cart cart = await locator<HttpApi>()
//                                         .addWrapping(context,
//                                             body: gw.toJson());
//                                     model.cart = cart;
//                                     // model.setState();
//                                     //   item.quantity++;
//                                     //   model.updateCart(context, index, item);
//                                   }
//                                 },
//                                 color: AppColors.secondaryText,
//                                 icon: Icon(
//                                   Icons.add,
//                                   size: 19,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         Spacer(),
//                       ]),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: <Widget>[
//                     IconButton(
//                       onPressed: () async {
//                         Cart cart =
//                             await locator<HttpApi>().removeWrapping(context);
//                         model.cart = cart;
//                         model.setState();
//                         // model.remove(context, locale,
//                         //     lineId: model.cart.lines[index].id);
//                       },
//                       color: AppColors.accentText,
//                       icon: Icon(Icons.remove_shopping_cart),
//                     ),
//                     Text(
//                         locator<CurrencyService>().getPriceWithCurrncy(
//                                 num.tryParse(
//                                     model.cart.giftWrapping.wrapping.price)) +
//                             " " +
//                             locale.get(locator<CurrencyService>()
//                                 .selectedCurrency
//                                 .toUpperCase()),
//                         style: TextStyle(
//                             fontSize: 15,
//                             color: AppColors.accentText,
//                             fontWeight: FontWeight.bold)),
//                   ],
//                 )
//               ],
//             ),
//           )
//       ],
//     );
//     // return ListView.builder(
//     //     shrinkWrap: true,
//     //     itemCount: csmodel.cart.lines.length,
//     //     itemBuilder: (context, index) {
//     //       final item = csmodel.cart.lines[index];

//     //       return buildCartItem(model, context, item, index, csmodel, locale);
//     //     });
//   }

//   Widget buildCartItem(CartPageModel model, BuildContext context, Lines item,
//       int index, CartService csmodel, AppLocalizations locale) {
//     return GestureDetector(
//       onTap: () => model.openItem(context,
//           item: item.item, cartItem: model.cart.lines[index]),
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: 11, horizontal: 0),
//         // margin: index + 1 == csmodel.cart.lines.length
//         //     ? EdgeInsets.only(bottom: 120)
//         //     : null,
//         height: 120,
//         width: double.infinity,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: <Widget>[
//             Container(
//               width: ScreenUtil.screenWidthDp / 3,
//               // height: double.infinity,
//               child: Card(
//                 elevation: 3.5,
//                 clipBehavior: Clip.antiAlias,
//                 margin: EdgeInsetsDirectional.only(end: 10),
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8.0)),
//                 child: CachedNetworkImage(
//                   cacheManager: CustomCacheManager.instance,
//                   imageUrl: model.cart.lines[index].item.image,
//                   placeholder: (context, url) => LoadingIndicator(),
//                   errorWidget: (context, url, error) => GestureDetector(
//                     onTap: () {
//                       UI.push(context, Routes.home,
//                           replace: true); //* adding navigation
//                     },
//                     child: Center(
//                       child: Image.asset(
//                         'assets/images/beautyLogo.png',
//                         scale: 10,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Expanded(
//               child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Spacer(),
//                     Text(
//                       item.item.name.localized(context),
//                       style: TextStyle(fontSize: 20),
//                       maxLines: 1,
//                       overflow: TextOverflow.clip,
//                     ),
//                     Spacer(),
//                     Container(
//                       height: 35,
//                       width: 120,
//                       decoration: BoxDecoration(
//                           color: Colors.grey[400],
//                           borderRadius: BorderRadius.all(Radius.circular(15))),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: <Widget>[
//                           IconButton(
//                             onPressed: () {
//                               if (item.quantity > 1) {
//                                 item.quantity--;
//                                 model.updateCart(context, index, item);
//                               }
//                             },
//                             color: AppColors.secondaryText,
//                             icon: Icon(Icons.remove, size: 19),
//                           ),
//                           Text(item.quantity.toString(),
//                               style: TextStyle(
//                                   fontSize: 14,
//                                   color: AppColors.secondaryText,
//                                   fontWeight: FontWeight.bold)),
//                           IconButton(
//                             onPressed: () {
//                               if (item.quantity < item.availableQty) {
//                                 item.quantity++;
//                                 model.updateCart(context, index, item);
//                               }
//                             },
//                             color: AppColors.secondaryText,
//                             icon: Icon(
//                               Icons.add,
//                               size: 19,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Spacer(),
//                   ]),
//             ),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: <Widget>[
//                 IconButton(
//                   onPressed: () async {
//                     model.remove(context, locale,
//                         lineId: model.cart.lines[index].id);
//                   },
//                   color: AppColors.accentText,
//                   icon: Icon(Icons.remove_shopping_cart),
//                 ),
//                 Text(
//                     locator<CurrencyService>()
//                             .getPriceWithCurrncy(num.parse(item.price)) +
//                         "  " +
//                         locale.get(locator<CurrencyService>()
//                             .selectedCurrency
//                             .toUpperCase()),
//                     style: TextStyle(
//                         fontSize: 15,
//                         color: AppColors.accentText,
//                         fontWeight: FontWeight.bold)),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget buildEmptyIndicator(AppLocalizations locale) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Icon(Icons.remove_shopping_cart),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: Text(
//               locale.get("There is no items in your card") ??
//                   "There is no items in your card",
//               style: TextStyle(fontSize: 20),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(5.0),
//             child: Text(
//               locale.get("Start shopping now") ?? "Start shopping now",
//               style: TextStyle(fontSize: 20),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget logo(context) {
//     return GestureDetector(
//       onTap: () {
//         UI.push(context, Routes.home, replace: true); //* adding navigation
//       },
//       child: Align(
//         alignment: Alignment.centerLeft,
//         child: Padding(
//           padding: const EdgeInsets.only(
//             top: 5,
//             left: 20,
//           ),
//           child: Container(
//             width: 57.5,
//             height: 40,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(7.0),
//               image: DecorationImage(
//                   image: const AssetImage('assets/images/beautyLogo.png'),
//                   fit: BoxFit.fitWidth),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Expanded buildErrorWidget(AppLocalizations locale) {
//     return Expanded(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.error_outline),
//           Padding(
//             padding: const EdgeInsets.only(top: 8.0),
//             child: Text(locale.get("There is no items in your card") ??
//                 "There is no items in your card"),
//           )
//         ],
//       ),
//     );
//   }

//   Expanded buildLoading() => Expanded(
//           child: Center(
//               child: CircularProgressIndicator(
//         color: AppColors.accentText,
//       )));

//   Padding buildHeader(BuildContext context, AppLocalizations locale) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           InkWell(
//               onTap: () => Provider.of<HomePageModel>(context, listen: false)
//                   .changeTap(context, 0),
//               child: Container(
//                   child: Icon(Icons.arrow_back_ios,
//                       size: 28, color: Colors.black))),
//           Text(
//             locale.get('My Cart') ?? 'My Cart',
//             style: TextStyle(
//               fontFamily: 'Josefin Sans',
//               fontSize: 25,
//               color: const Color(0xff313131),
//               fontWeight: FontWeight.w700,
//             ),
//             textAlign: TextAlign.left,
//           ),
//           Container(width: 28)
//         ],
//       ),
//     );
//   }

//   checkOutButton(BuildContext context, AppLocalizations local,
//       CartPageModel model, Cart cart) {
//     return Container(
//       width: 255,
//       height: 40,
//       margin: EdgeInsets.all(10),
//       child: FlatButton(
//         onPressed: () {
//           // Preference.setString(PrefKeys.token, '1' + model.auth.user.token);
//           if (model.cart != null && model.cart.lines.length != 0) {
//             showDialog(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return AddressesDialogPage(cart: cart);
//                 });
//           } else {
//             UI.toast(local.get("Cart is empty") ?? "Cart is empty");
//           }
//         },
//         padding: EdgeInsets.all(0),
//         color: AppColors.secondaryElement,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             Text(local.get('Check out now') ?? 'Check out now',
//                 style: TextStyle(fontSize: 16, color: const Color(0xffffffff))),
//             Text('>',
//                 style: TextStyle(fontSize: 16, color: const Color(0xffffffff))),
//           ],
//         ),
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//           Radius.circular(15),
//         )),
//       ),
//     );
//   }
// }
