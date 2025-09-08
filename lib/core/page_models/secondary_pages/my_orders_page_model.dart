import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/myorders.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class MyOrdersPageModel extends BaseNotifier {
  final AuthenticationService auth;
  final HttpApi api;

  List<MyOrdersModel> myOrders;

  MyOrdersPageModel({this.auth, this.api});

  ordersList() {
    return myOrders;
  }

  orderInfo(BuildContext context, MyOrdersModel myOrder) {
    UI.push(context, Routes.orderInfo(order: myOrder));
  }

  getUserOrders(
    BuildContext context,
  ) async {
    setBusy();
    myOrders = await api.getUserOrders(context, userId: auth.user.user.id);
    // print(myOrders.length);
    if (myOrders != null && myOrders.length >= 0) {
      setIdle();
    } else {
      setError();
    }
  }
}
