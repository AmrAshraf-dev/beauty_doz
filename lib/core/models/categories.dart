import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';

class Name {
  String ar;
  String en;

  Name({this.ar, this.en});

  String localized(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return locale.locale.languageCode == 'en' ? en : ar;
  }

  Name.fromJson(Map<String, dynamic> json) {
    ar = json['ar'] ?? '';
    en = json['en'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    return data;
  }
}

class Categories {
  int id;
  Name name;
  List<Categories> subCategories;

  Categories({this.id, this.name, this.subCategories});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    if (json['subCategories'] != null) {
      subCategories = <Categories>[];
      json['subCategories'].forEach((v) {
        subCategories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.subCategories != null) {
      data['subCategories'] =
          this.subCategories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
