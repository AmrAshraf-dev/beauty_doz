import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:ui_utils/ui_utils.dart';

import 'category_items.dart';

class NewSearchModel {
  List<Brand> brandList = [];
  List<CategoryItems> itemsList = [];
  NewSearchModel({
    this.brandList,
    this.itemsList,
  });
  NewSearchModel.fromJson(Map<String, dynamic> json) {
    if (json['brandList'] != null) {
      brandList = <Brand>[];
      json['brandList'].forEach((v) {
        brandList.add(Brand.fromJson(v));
      });
    }
    if (json['itemsList'] != null) {
      itemsList = <CategoryItems>[];
      json['itemsList'].forEach((v) {
        itemsList.add(CategoryItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.brandList != null) {
      data['brandList'] = this.brandList.map((v) => v.toJson()).toList();
    }
    if (this.itemsList != null) {
      data['itemsList'] = this.itemsList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
