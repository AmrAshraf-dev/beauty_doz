import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/categories.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:flutter/material.dart';

class CategoryService extends BaseNotifier {
  final HttpApi api;

  List<Categories> categories;

  CategoryService({NotifierState state, this.api}) : super(state: state);

  getCategories(BuildContext context) async {
    try {
      categories = await api.getCategories(context);
    } catch (e) {}
    if (categories != null) {
      setIdle();
    } else {
      setError();
    }
  }

  // getHomePageItems(BuildContext context) async {
  //   try {
  //     homePageItems = await api.getHomePageItems(context);
  //   } catch (e) {}
  //   if (homePageItems != null) {
  //     setIdle();
  //   } else {
  //     setError();
  //   }
  // }

  // loadHomePageItem() async {
  //   return homePageItems;
  // }
}
