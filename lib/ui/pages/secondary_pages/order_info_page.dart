import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/myorders.dart';
import 'package:beautydoz/core/page_models/secondary_pages/order_info_page_model.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/pages/secondary_pages/submit_review_dialog.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:intl/intl.dart';

class OrderInfoPage extends StatelessWidget {
  final MyOrdersModel order;
  OrderInfoPage({this.order});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          child: NewAppBar(
            title: order.id.toRadixString(10),
            drawer: false,
            returnBtn: true,
            onLanguageChanged: null,
          ),
          preferredSize: Size(ScreenUtil.screenWidthDp, 80),
        ),
        body: BaseWidget<OrderInfoPageModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
            model: OrderInfoPageModel(auth: Provider.of(context), order: order),
            builder: (context, model, child) {
              return Container(
                width: ScreenUtil.screenWidthDp,
                height: ScreenUtil.screenHeightDp,
                child: Column(
                  children: <Widget>[
                    orderInfo(context, model, locale),
                  ],
                ),
              );
            }),
      ),
    );
  }

  orderInfo(
      BuildContext context, OrderInfoPageModel model, AppLocalizations locale) {
    final locale = AppLocalizations.of(context);

    var date = locale.locale == Locale("ar")
        ? new DateFormat('yyyy/dd/MM hh:mm')
            .format(DateTime.tryParse(model.order.valueDate.toString()))
        : new DateFormat('dd/MM/yyyy mm:hh')
            .format(DateTime.tryParse(model.order.valueDate.toString()));
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(locale.get('Order No. ') +
                            ' #' +
                            model.order.id.toString() ??
                        'Order No. ' '# ' + model.order.id.toString()),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text("${locale.get("Placed on. ")} : " + date)),
                  Divider(),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ...model.order.lines
                          .map((line) => Column(
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: CachedNetworkImage(
                                          cacheManager:
                                              CustomCacheManager.instance,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: 80,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              LoadingIndicator(),
                                          errorWidget: (context, url, error) =>
                                              GestureDetector(
                                            onTap: () {
                                              UI.pushReplaceAll(
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
                                          imageUrl: line.item.image,
                                          fit: BoxFit.fitHeight,
                                        ),
                                      )),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(
                                                  line.item.name
                                                      .localized(context),
                                                  style: TextStyle(
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(1.0),
                                                child: Text(
                                                  locale.get("QTY: ") +
                                                          line.qty.toString() +
                                                          locale.get(' item') ??
                                                      ' item' ??
                                                      'QTY: ' +
                                                          line.qty.toString() +
                                                          locale.get(' item') ??
                                                      ' item',
                                                  style:
                                                      TextStyle(fontSize: 14),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(
                                                  locale.get("Item price: ") +
                                                          line.price
                                                              .toString() ??
                                                      "Item price: " +
                                                          line.item.price
                                                              .toString(),
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyText1
                                                          .color),
                                                ),
                                              ),
                                              RaisedButton(
                                                onPressed: () {
                                                  return showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return SubmitReviewDialog(
                                                            order: order,
                                                            item: line.item);
                                                      });
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0),
                                                      child: Text(
                                                          locale.get("Rate") ??
                                                              "Rate"),
                                                    ),
                                                    Icon(
                                                      Icons.star,
                                                      color: Colors.white,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16.0, right: 16, top: 8),
                                    child: Divider(),
                                  )
                                ],
                              ))
                          .toList()
                    ],
                  ),
                  if (model.order.giftWrapping != null)
                    Column(
                      children: [
                        Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CachedNetworkImage(
                                cacheManager: CustomCacheManager.instance,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    LoadingIndicator(),
                                errorWidget: (context, url, error) =>
                                    GestureDetector(
                                  onTap: () {
                                    UI.pushReplaceAll(context,
                                        Routes.home); //* adding navigation
                                  },
                                  child: Center(
                                      child: Image.asset(
                                    'assets/images/beautyLogo.png',
                                    scale: 10,
                                  )),
                                ),
                                imageUrl:
                                    model.order.giftWrapping.wrapping.image,
                                fit: BoxFit.fitHeight,
                              ),
                            )),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        locale.get('Gift Wrapping Service'),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Text(
                                        locale.get("QTY: ") +
                                                model.order.giftWrapping.qty
                                                    .toString() +
                                                locale.get(' item') ??
                                            ' item',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Text(
                                        locale.get("Item price: ") +
                                            model.order.giftWrapping.wrapping
                                                .price,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyText1
                                                .color),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16.0, right: 16, top: 8),
                          child: Divider(),
                        )
                      ],
                    )
                  // ListView.builder(
                  //   shrinkWrap: true,
                  //   itemCount: model.order.lines.length,
                  //   physics: NeverScrollableScrollPhysics(),
                  //   itemBuilder: (context, index) {
                  //     return Column(
                  //       children: [
                  //         Row(
                  //           children: <Widget>[
                  //             Expanded(
                  //                 child: Padding(
                  //               padding: const EdgeInsets.all(5.0),
                  //               child: CachedNetworkImage(
                  //                 cacheManager: CustomCacheManager.instance,
                  //                 imageBuilder: (context, imageProvider) =>
                  //                     Container(
                  //                   height: 80,
                  //                   width: 80,
                  //                   decoration: BoxDecoration(
                  //                     image: DecorationImage(
                  //                         image: imageProvider,
                  //                         fit: BoxFit.cover),
                  //                   ),
                  //                 ),
                  //                 placeholder: (context, url) =>
                  //                     LoadingIndicator(),
                  //                 errorWidget: (context, url, error) => Center(
                  //                     child: Image.asset(
                  //                   'assets/images/beautyLogo.png',
                  //                   scale: 10,
                  //                 )),
                  //                 imageUrl: model.order.lines[index].item.image,
                  //                 fit: BoxFit.fitHeight,
                  //               ),
                  //             )),
                  //             Flexible(
                  //               child: Padding(
                  //                 padding: const EdgeInsets.all(8.0),
                  //                 child: Column(
                  //                   crossAxisAlignment:
                  //                       CrossAxisAlignment.start,
                  //                   children: <Widget>[
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(2.0),
                  //                       child: Text(
                  //                         model.order.lines[index].item.name
                  //                             .localized(context),
                  //                         style: TextStyle(
                  //                             fontSize: 20,
                  //                             fontWeight: FontWeight.bold),
                  //                       ),
                  //                     ),
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(1.0),
                  //                       child: Text(
                  //                         locale.get("QTY: ") +
                  //                                 model.order.lines[index].qty
                  //                                     .toString() +
                  //                                 locale.get(' item') ??
                  //                             ' item' ??
                  //                             'QTY: ' +
                  //                                 model.order.lines[index].qty
                  //                                     .toString() +
                  //                                 locale.get(' item') ??
                  //                             ' item',
                  //                         style: TextStyle(fontSize: 14),
                  //                       ),
                  //                     ),
                  //                     Padding(
                  //                       padding: const EdgeInsets.all(2.0),
                  //                       child: Text(
                  //                         locale.get("Item price: ") +
                  //                                 model.order.lines[index].price
                  //                                     .toString() ??
                  //                             "Item price: " +
                  //                                 model.order.lines[index].item
                  //                                     .price
                  //                                     .toString(),
                  //                         style: TextStyle(
                  //                             fontSize: 15,
                  //                             color: Theme.of(context).textTheme.bodyText1.color),
                  //                       ),
                  //                     ),
                  //                     RaisedButton(
                  //                       onPressed: () {
                  //                         return showDialog(
                  //                             context: context,
                  //                             builder: (context) {
                  //                               return SubmitReviewDialog(
                  //                                   order: order,
                  //                                   item: model.order
                  //                                       .lines[index].item);
                  //                             });
                  //                       },
                  //                       child: Row(
                  //                         mainAxisAlignment:
                  //                             MainAxisAlignment.center,
                  //                         children: [
                  //                           Padding(
                  //                             padding: const EdgeInsets.only(
                  //                                 left: 5.0),
                  //                             child: Text(
                  //                                 locale.get("Rate") ?? "Rate"),
                  //                           ),
                  //                           Icon(
                  //                             Icons.star,
                  //                             color: Colors.white,
                  //                           ),
                  //                         ],
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //               ),
                  //             )
                  //           ],
                  //         ),
                  //         Padding(
                  //           padding: const EdgeInsets.only(
                  //               left: 16.0, right: 16, top: 8),
                  //           child: Divider(),
                  //         )
                  //       ],
                  //     );
                  //   },
                  // ),
                  ,
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          locale.get("Shipping Address: ") ??
                              "Shipping Address: ",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    child: Text(
                      model.order.shipment.shippingAddress,
                      style: TextStyle(fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          locale.get("Payment Method: ") ?? "Payment Method: ",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          model.order.invoice.paymentMethod,
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10.0, left: 10, bottom: 10),
                    child: Text(
                      locale.get("Order Summary ") ?? 'Order Summary ',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, left: 10, bottom: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(locale.get("Subtotal") ?? 'Subtotal'),
                        Text(model
                                .calculateLinesTotalPrice(model.order.lines)
                                .toStringAsFixed(3) +
                            " " +
                            locale.get("KD" ?? "KD")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 5, bottom: 5, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(locale.get("Shipping Fee") ?? 'Shipping Fee'),
                        Text(model.order.shipment.shippingCost.toString() +
                                " " +
                                locale.get("KD") ??
                            "KD"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10, bottom: 5, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(locale.get("Order Total") ?? 'Order Total'),
                        Text((double.parse(model.order.totalPrice) +
                                        double.parse(
                                            model.order.shipment.shippingCost))
                                    .toStringAsFixed(3) +
                                " " +
                                locale.get("KD") ??
                            "KD"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10, bottom: 5, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(locale.get("Discount") ?? 'Discount',
                            style: TextStyle(color: Colors.redAccent)),
                        Text(
                            model.order.discount.toString() +
                                    " " +
                                    locale.get("KD") ??
                                "KD",
                            style: TextStyle(color: Colors.redAccent))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10, bottom: 5, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          locale.get("Price after discount") ??
                              'Price after discount',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        Text(
                            (double.parse(model.order.priceAfterDiscount) +
                                            double.parse(model
                                                .order.shipment.shippingCost))
                                        .toStringAsFixed(3) +
                                    " " +
                                    locale.get("KD") ??
                                "KD",
                            style: TextStyle(color: Colors.redAccent))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10, bottom: 5, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(locale.get("Invoice id") ?? 'Invoice id'),
                        Text(model.order.invoice.id.toString())
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10, bottom: 5, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(locale.get("Invoice status") ?? 'Invoice status'),
                        Text(model.order.invoice.status)
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: RaisedButton(
                  //     shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10)),
                  //     onPressed: () {
                  //       return showDialog(
                  //           context: context,
                  //           builder: (context) {
                  //             return SubmitReviewDialog();
                  //           });
                  //     },
                  //     child: Center(
                  //       child: Padding(
                  //         padding: const EdgeInsets.symmetric(vertical: 10),
                  //         child: Text(
                  //             locale.get("Rate the shopping Experience") ??
                  //                 "Rate the shopping Experience"),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(top: 3.0, left: 10, bottom: 15),
                  //   child: RatingBar(
                  //     initialRating: 1,
                  //     minRating: 1,
                  //     itemCount: 5,
                  //     direction: Axis.horizontal,
                  //     itemBuilder: (context, _) => Icon(
                  //       Icons.star,
                  //       color: Colors.amber,
                  //     ),
                  //     onRatingUpdate: (rating) {
                  //       print(rating);
                  //     },
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
