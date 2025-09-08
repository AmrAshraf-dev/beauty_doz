import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class BrandsPageModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  RefreshController refreshController = RefreshController();

  TextEditingController brandNameController = TextEditingController();

  Map<String, dynamic> param;

  BrandsPageModel({this.api, this.auth, this.context}) {
    param = {'page': 1};
  }

  List<Brand> brands;

  getBrands() async {
    setBusy();
    brands = await api.getAllBrands(context, param: param);
    if (brands != null) {
      setIdle();
    } else {
      setError();
    }
  }

  search() async {
    setBusy();
    param['name'] = brandNameController.text;
    print(param);
    brands = await api.getAllBrands(context, param: param);
    if (brands != null) {
      setIdle();
    } else {
      setError();
    }
  }

  onload(BuildContext context) async {
    param['page'] = param['page'] + 1;
    print(param['page']);
    //setBusy();
    brands.addAll(await api.getAllBrands(context, param: param) ?? []);
    if (brands != null && brands.isNotEmpty) {
      // lastPage = param['page'] + 1;
      setIdle();
    }
    refreshController.loadComplete();
  }

  onRefresh(BuildContext context) async {
    param = {'page': 1};
    await getBrands();
    refreshController.refreshCompleted();
  }
}
