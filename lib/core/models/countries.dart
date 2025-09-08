import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';

class Countries {
  int id;
  dynamic shippingCost;
  dynamic countryCode;
  Name name;

  Countries({this.id, this.shippingCost, this.name});

  Countries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shippingCost = json['shippingCost'];
    countryCode = json['countryCode'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shippingCost'] = this.shippingCost;
    data['countryCode'] = this.countryCode;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    return data;
  }
}

class Name {
  String ar;
  String en;

  Name({this.ar, this.en});

  String localized(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return locale.locale.languageCode == 'en' ? en : ar;
  }

  Name.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    return data;
  }
}
