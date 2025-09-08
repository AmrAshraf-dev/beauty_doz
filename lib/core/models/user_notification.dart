import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';

class NotificationType {
  static const String attendance = 'attendance';
  static const String instalment = 'instalment';
  static const String purchaseRequest = 'purchaseRequest';
}

class UserNotification {
  int id;
  Name title;
  Name description;
  String image;
  Item item;

  UserNotification(
      {this.id, this.title, this.description, this.image, this.item});

  UserNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Name.fromJson(json['title']) : null;
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
    image = json['image'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
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

class Item {
  int id;
  Item({this.id});

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
