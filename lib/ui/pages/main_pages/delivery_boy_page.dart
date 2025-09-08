import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/main_pages_models/delivery_boy_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/cache_manager/cache_manager.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class DeliveryBoyPage extends StatefulWidget {
  @override
  _DeliveryBoyPageState createState() => _DeliveryBoyPageState();
}

class _DeliveryBoyPageState extends State<DeliveryBoyPage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    tabController = new TabController(length: 1, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: BaseWidget<DeliveryBoyPageModel>(
        model: DeliveryBoyPageModel(
            api: Provider.of<Api>(context), auth: Provider.of(context)),
        initState: (m) => WidgetsBinding.instance
            .addPostFrameCallback((_) => m.loadOrders(context)),
        builder: (context, model, child) => Scaffold(
            appBar: new AppBar(
              backgroundColor: Colors.white,
              title: buildTitle(context, model),
              bottom: TabBar(
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                tabs: [
                  new Tab(text: locale.get("New orders") ?? "New orders"),
                ],
                controller: tabController,
                indicatorColor: Colors.amber,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              bottomOpacity: 1,
            ),
            body: Consumer<DeliveryBoyPageModel>(
              builder: (contex, model, child) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    //buildTaps(locale),

                    model.busy
                        ? Expanded(
                            child: Center(
                              child: LoadingIndicator(),
                            ),
                          )
                        : model.hasError
                            ? Expanded(
                                child: Center(
                                  child: Text(locale.get("Error") ?? "Error"),
                                ),
                              )
                            : model.orders == null || model.orders.isEmpty
                                ? Expanded(
                                    child: Center(
                                      child: Column(
                                        children: [Text("Empty")],
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: TabBarView(
                                      controller: tabController,
                                      children: [
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: model.orders.length,
                                            itemBuilder: (context, index) =>
                                                buildOrder(
                                                    locale, model, index)),
                                      ],
                                    ),
                                  )
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget buildOrder(
      AppLocalizations locale, DeliveryBoyPageModel model, int index) {
    var order = model.orders[index];
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Card(
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
                              order.id.toString() ??
                          'Order No. ' '# ' + order.id.toString()),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                      child: Text(locale.get('Placed on. ') + order.valueDate ??
                          'Placed on. ' + order.valueDate),
                    ),
                    Divider(
                      thickness: 2,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10, bottom: 10),
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
                        order.shipment.shippingAddress,
                        style: TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10, bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            locale.get("Payment Method: ") ??
                                "Payment Method: ",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            order.invoice.paymentMethod,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10, bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            locale.get("Phone number: ") ?? "Phone number: ",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            order.user.mobile.toString(),
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 10, bottom: 10),
                      child: Text(
                        locale.get("Order Summary ") ?? 'Order Summary ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                              .calculateLinesTotalPrice(order.lines)
                              .toStringAsFixed(3)),
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
                          Text(order.shipment.shippingCost),
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
                          Text(order.totalPrice),
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
                          Text(order.invoice.id.toString())
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 2.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10, bottom: 5, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(locale.get("QTY: ") ?? 'QTY: '),
                          Text(order.totalItems.toString() +
                                  locale.get(' Item') ??
                              ' Item')
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: order.lines.length,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, idx) {
                        return Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: CachedNetworkImage(
                                imageUrl: order.lines[idx].item.image,
                                fit: BoxFit.fitHeight,
                                cacheManager: CustomCacheManager.instance,
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
                                        order.lines[idx].item.name
                                            .localized(context),
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    ),
                    Divider(
                      thickness: 3.0,
                    ),
                    Row(
                      children: [
                        Checkbox(
                            value: model.checkBoxVal,
                            onChanged: (newVal) {
                              model.checkBoxVal = newVal;
                              model.updateOrderStatus(context, order);
                              //model.setState();
                              print(newVal);
                            }),
                        Text(locale.get("Order deliverd") ?? "Order deliverd"),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context, DeliveryBoyPageModel model) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white,
          child: Image.asset('assets/images/correct.png'),
        ),
        SizedBox(
          width: 10,
        ),
        Text('Name'),
        InkWell(
          onTap: () => model.signOut(context),
          child: Icon(Icons.settings_power),
        ),
      ],
    );
  }
}
