import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/myorders.dart';
import 'package:beautydoz/core/page_models/secondary_pages/my_orders_page_model.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/category/category_service.dart';
import 'package:beautydoz/core/services/homePageService/home_page_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class DeliveryBoyPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  DeliveryBoyPageModel({NotifierState state, this.api, this.auth})
      : super(state: state);

  List<MyOrdersModel> orders;
  List<MyOrdersPageModel> deliveredOrders;

  bool checkBoxVal = false;

  int pendingOrder = 1;
  int deliveredOrder = 2;

  loadOrders(BuildContext context) async {
    setBusy();

    orders = await api.loadDeliveryOrders(context);
    print("order length : " + orders.length.toString());
    orders != null ? setIdle() : setError();
  }

  calculateLinesTotalPrice(List<OrderLines> lines) {
    double price = 0.000;
    lines.forEach((element) => price = price + double.parse(element.price));
    return price;
  }

  updateOrderStatus(BuildContext context, MyOrdersModel order) async {
    final locale = AppLocalizations.of(context);
    var res;
    setBusy();
    // update status
    try {
      res = await api.updateOrderStatus(context, order);
    } catch (e) {}
    if (res == true) {
      orders.remove(order);
      checkBoxVal = false;
      setIdle();
      UI.toast(locale.get("Order status updated successfuly") ??
          "Order status updated successfuly");
    } else {
      checkBoxVal = false;
      setIdle();
      UI.toast(locale.get("Error") ?? "Error");
    }
  }

  void signOut(BuildContext context) async {
    await auth.signOut;

    // await Provider.of<CategoryService>(context, listen: false)
    //     .getCategories(context);

    UI.pushReplaceAll(context, Routes.home);
  }
}
