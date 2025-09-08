import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/secondary_pages/my_orders_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:intl/intl.dart';

class MyOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          child: NewAppBar(
            title: 'My Orders',
            drawer: false,
            returnBtn: true,
            onLanguageChanged: null,
          ),
          preferredSize: Size(ScreenUtil.screenWidthDp, 80),
        ),
        body: BaseWidget<MyOrdersPageModel>(
            initState: (m) => WidgetsBinding.instance
                .addPostFrameCallback((_) => m.getUserOrders(
                      context,
                    )),
            model: MyOrdersPageModel(
              auth: Provider.of(context),
              api: Provider.of<Api>(context),
            ),
            builder: (context, model, child) {
              return SafeArea(
                child: Container(
                  width: ScreenUtil.screenWidthDp,
                  height: ScreenUtil.screenHeightDp,
                  child: Column(
                    children: <Widget>[
                      // App bar

                      // List or orders
                      model.busy
                          ? Expanded(
                              child: Center(
                                child: LoadingIndicator(),
                              ),
                            )
                          : model.hasError
                              ? Text(locale.get("Error") ?? "Error")
                              : model.myOrders == null || model.myOrders.isEmpty
                                  ? buildEmptyList(locale)
                                  : buildListOrOrders(context, model, locale)
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Widget buildEmptyList(AppLocalizations locale) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_shopping_cart),
          Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
                locale.get("You have no orders \n Start shopping now ") ??
                    "You have no orders \n Start shopping now "),
          )
        ],
      ),
    );
  }

  Expanded buildListOrOrders(
      BuildContext context, MyOrdersPageModel model, AppLocalizations locale) {
    return Expanded(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: model.myOrders.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: orderList(context, model, index, locale),
                );
              }),
        ),
      ),
    );
  }

  orderList(BuildContext context, MyOrdersPageModel model, int idx,
      AppLocalizations locale) {
    var date = locale.locale == Locale("ar")
        ? new DateFormat('yyyy/dd/MM hh:mm')
            .format(DateTime.tryParse(model.myOrders[idx].valueDate.toString()))
        : new DateFormat('dd/MM/yyyy mm:hh').format(
            DateTime.tryParse(model.myOrders[idx].valueDate.toString()));
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () => model.orderInfo(context, model.myOrders[idx]),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              locale.get("Order No. ") +
                                  " #" +
                                  model.myOrders[idx].id.toString(),
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2),
                            child: Text(
                              locale.get("Placed in ") + ' ' + date,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2),
                            child: Text(
                              locale.get("Order status : ") +
                                  ' ' +
                                  model.myOrders[idx].status,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2),
                            child: Text(
                              locale.get("Shippment status : ") +
                                  ' ' +
                                  model.myOrders[idx].shipment.status,
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                          color: Colors.grey[400],
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Divider(),
                ),
                Column(
                  children: [
                    ...model.myOrders[idx].lines
                        .map((line) => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    // Order Picture
                                    Expanded(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: CachedNetworkImage(
                                        cacheManager:
                                            CustomCacheManager.instance,
                                        placeholder: (context, url) =>
                                            LoadingIndicator(),
                                        imageUrl: line.item.image,
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
                                      ),
                                    )),

                                    Flexible(
                                      flex: 2,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              line.item.name.localized(context),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .color,
                                                fontSize: 20,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 3.0, bottom: 3),
                                              child: Text(
                                                locale.get("QTY: ") +
                                                        line.qty.toString() +
                                                        locale.get(' item') ??
                                                    " item" ??
                                                    "QTY: " +
                                                        line.qty.toString() +
                                                        locale.get(' item') ??
                                                    " item",
                                              ),
                                            ),
                                            Text(
                                              locale.get("Total price: ") +
                                                      line.price.toString() +
                                                      ' KD' ??
                                                  "Total price: " +
                                                      line.price.toString(),
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .bodyText1
                                                    .color,
                                                fontSize: 15,
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
                            ))
                        .toList(),
                    if (model.myOrders[idx].giftWrapping != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              // Order Picture
                              Expanded(
                                  child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CachedNetworkImage(
                                  cacheManager: CustomCacheManager.instance,
                                  placeholder: (context, url) =>
                                      LoadingIndicator(),
                                  imageUrl: model.myOrders[idx].giftWrapping
                                      .wrapping.image,
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
                                ),
                              )),

                              Flexible(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        locale.get('Gift Wrapping Service'),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color,
                                          fontSize: 20,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 3.0, bottom: 3),
                                        child: Text(
                                          locale.get("QTY: ") +
                                              model.myOrders[idx].giftWrapping
                                                  .qty
                                                  .toString() +
                                              locale.get(' item'),
                                        ),
                                      ),
                                      Text(
                                        locale.get("Total price: ") +
                                            (double.parse(model
                                                        .myOrders[idx]
                                                        .giftWrapping
                                                        .wrapping
                                                        .price) *
                                                    model.myOrders[idx]
                                                        .giftWrapping.qty)
                                                .toString() +
                                            ' KD',
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText1
                                              .color,
                                          fontSize: 15,
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
                  ],
                ),
                // ListView.builder(
                //   shrinkWrap: true,
                //   physics: NeverScrollableScrollPhysics(),
                //   itemCount: model.myOrders[idx].lines.length,
                //   itemBuilder: (context, index) {
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: <Widget>[
                //         Row(
                //           children: <Widget>[
                //             // Order Picture
                //             Expanded(
                //                 child: Padding(
                //               padding: const EdgeInsets.all(8.0),
                //               child: CachedNetworkImage(
                //                 cacheManager: CustomCacheManager.instance,
                //                 placeholder: (context, url) =>
                //                     LoadingIndicator(),
                //                 imageUrl:
                //                     model.myOrders[idx].lines[index].item.image,
                //                 errorWidget: (context, url, error) => Center(
                //                     child: Image.asset(
                //                   'assets/images/beautyLogo.png',
                //                   scale: 10,
                //                 )),
                //               ),
                //             )),

                //             Flexible(
                //               flex: 2,
                //               child: Padding(
                //                 padding: const EdgeInsets.only(left: 8.0),
                //                 child: Column(
                //                   crossAxisAlignment: CrossAxisAlignment.start,
                //                   children: <Widget>[
                //                     Text(
                //                       model.myOrders[idx].lines[index].item.name
                //                           .localized(context),
                //                       style: TextStyle(
                //                         color: Theme.of(context).textTheme.bodyText1.color,
                //                         fontSize: 20,
                //                       ),
                //                     ),
                //                     Padding(
                //                       padding: const EdgeInsets.only(
                //                           top: 3.0, bottom: 3),
                //                       child: Text(
                //                         locale.get("QTY: ") +
                //                                 model.myOrders[idx].lines[index]
                //                                     .qty
                //                                     .toString() +
                //                                 locale.get(' item') ??
                //                             " item" ??
                //                             "QTY: " +
                //                                 model.myOrders[idx].lines[index]
                //                                     .qty
                //                                     .toString() +
                //                                 locale.get(' item') ??
                //                             " item",
                //                       ),
                //                     ),
                //                     Text(
                //                       locale.get("Total price: ") +
                //                               model.myOrders[idx].lines[index]
                //                                   .price
                //                                   .toString() +
                //                               ' KD' ??
                //                           "Total price: " +
                //                               model.myOrders[idx].lines[index]
                //                                   .price
                //                                   .toString(),
                //                       style: TextStyle(
                //                         color: Theme.of(context).textTheme.bodyText1.color,
                //                         fontSize: 15,
                //                       ),
                //                     ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
