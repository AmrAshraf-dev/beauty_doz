import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/category/category_service.dart';
import 'package:flutter/material.dart';

class SortDialogModel extends BaseNotifier {
  final Map<String, dynamic> param;
  final CategoryService categoryService;

  SortDialogModel({this.param, this.categoryService});

  void tryAgain(BuildContext context) async {
    setBusy();
    await categoryService.getCategories(context);
    setIdle();
  }

  loseFocus(BuildContext context) {
    // FocusScope.of(context).requestFocus(FocusNode());
    FocusScope.of(context).unfocus();
  }
}
