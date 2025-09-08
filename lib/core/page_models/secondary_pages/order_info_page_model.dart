import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/myorders.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';

class OrderInfoPageModel extends BaseNotifier {
  final AuthenticationService auth;
  final MyOrdersModel order;

  double cashTotal = 0;
  num lineTotalPrice = 0;

  OrderInfoPageModel({this.auth, this.order});

  calculateCashTotal() {
    // order.items.forEach((element) { cashTotal += element.qty * element.price;});
    return cashTotal;
  }

  num calculateLinesTotalPrice(List<OrderLines> lines) {
    lines.forEach((element) {
      lineTotalPrice += double.parse(element.price);
    });
    return lineTotalPrice;
  }
}
