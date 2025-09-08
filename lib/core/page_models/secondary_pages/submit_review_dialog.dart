import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/myorders.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class SubmitReviewDialogModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;
  final MyOrdersModel order;
  final Item item;

  SubmitReviewDialogModel(
      {NotifierState state,
      this.api,
      this.auth,
      this.context,
      this.order,
      this.item})
      : super(state: state);

  double rateValue = 1;

  TextEditingController reviewController = TextEditingController();

  submitReview() async {
    final locale = AppLocalizations.of(context);
    Map<String, dynamic> body = {
      "item": {"id": item.id},
      "order": {"id": order.id},
      "user": {"id": auth.user.user.id},
      "comment": reviewController.text,
      "rating": rateValue,
      "valueDate": "2020-10-04"
    };

    bool res = false;

    setBusy();

    res = await api.postReview(context, body: body);
    if (res) {
      UI.toast(locale.get(
          "Review submitted successfully" ?? "Review submitted successfully"));

      Navigator.pop(context);
    } else {
      UI.toast(locale.get("Error in submiting your review") ??
          "Error in submiting your review");

      Navigator.pop(context);
    }
  }
}
