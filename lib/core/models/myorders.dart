import 'package:beautydoz/core/models/categories.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/models/favourite_model.dart';
import 'package:beautydoz/core/models/user.dart';
import 'package:beautydoz/core/models/wrapping-model.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';

class MyOrdersModel {
  int id;
  String status;
  String description;
  String valueDate;
  dynamic totalItems;
  dynamic totalPrice;
  dynamic discount;
  dynamic priceAfterDiscount;
  GiftWrapping giftWrapping;

  UserInfo user;
  Shipment shipment;
  Invoice invoice;
  List<OrderLines> lines;

  MyOrdersModel(
      {this.id,
      this.status,
      this.description,
      this.valueDate,
      this.totalItems,
      this.totalPrice,
      this.user,
      this.giftWrapping,
      this.discount,
      this.priceAfterDiscount,
      this.shipment,
      this.invoice,
      this.lines});

  MyOrdersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    description = json['description'];
    valueDate = json['valueDate'];
    totalItems = json['totalItems'];
    totalPrice = json['totalPrice'];
    giftWrapping = json['giftWrapping'] != null
        ? new GiftWrapping.fromJson(json['giftWrapping'])
        : null;
    discount = json['discount'] != null ? json['discount'] : 0;
    priceAfterDiscount = json['priceAfterDiscount'] != "0.000"
        ? json['priceAfterDiscount']
        : json['totalPrice'];
    user = json['user'] != null ? new UserInfo.fromJson(json['user']) : null;
    shipment = json['shipment'] != null
        ? new Shipment.fromJson(json['shipment'])
        : null;
    invoice =
        json['invoice'] != null ? new Invoice.fromJson(json['invoice']) : null;
    if (json['lines'] != null) {
      lines = <OrderLines>[];
      json['lines'].forEach((v) {
        lines.add(new OrderLines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status'] = this.status;
    data['description'] = this.description;
    data['valueDate'] = this.valueDate;
    if (this.giftWrapping != null) {
      data['giftWrapping'] = this.giftWrapping.toJson();
    }
    data['totalItems'] = this.totalItems;
    data['totalPrice'] = this.totalPrice;
    data['discount'] = this.discount;
    data['priceAfterDiscount'] = this.priceAfterDiscount;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.shipment != null) {
      data['shipment'] = this.shipment.toJson();
    }
    if (this.invoice != null) {
      data['invoice'] = this.invoice.toJson();
    }
    if (this.lines != null) {
      data['lines'] = this.lines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Shipment {
  int id;
  String valueDate;
  String shippingAddress;
  dynamic shippingCost;
  String status;
  UserInfo user;

  Shipment(
      {this.id,
      this.valueDate,
      this.shippingAddress,
      this.shippingCost,
      this.status,
      this.user});

  Shipment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    valueDate = json['valueDate'];
    shippingAddress = json['shippingAddress'];
    shippingCost = json['shippingCost'];
    status = json['status'];
    user = json['user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['valueDate'] = this.valueDate;
    data['shippingAddress'] = this.shippingAddress;
    data['shippingCost'] = this.shippingCost;
    data['status'] = this.status;
    data['user'] = this.user;
    return data;
  }
}

class Invoice {
  int id;
  String paymentMethod;
  String creditCardInvoice;
  String status;
  UserInfo user;

  Invoice(
      {this.id,
      this.paymentMethod,
      this.creditCardInvoice,
      this.status,
      this.user});

  Invoice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentMethod = json['paymentMethod'];
    creditCardInvoice = json['creditCardInvoice'];
    status = json['status'];
    user = json['user'] != null ? new UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['paymentMethod'] = this.paymentMethod;
    data['creditCardInvoice'] = this.creditCardInvoice;
    data['status'] = this.status;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class OrderLines {
  int id;
  int qty;
  dynamic price;
  Item item;

  OrderLines({
    this.id,
    this.qty,
    this.price,
    this.item,
  });

  OrderLines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    qty = json['qty'];
    price = json['price'];
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qty'] = this.qty;
    data['price'] = this.price;
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }

    return data;
  }
}

class Item {
  int id;
  String image;
  bool showInApp;
  dynamic price;
  String gender;
  Name name;
  Name description;
  Brand brand;
  List<Categories> categories;
  List<Banners> banners;

  Item({
    this.id,
    this.image,
    this.showInApp,
    this.price,
    this.gender,
    this.name,
    this.description,
    this.brand,
    this.categories,
    this.banners,
  });

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    showInApp = json['showInApp'];
    price = json['price'];
    gender = json['gender'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners.add(new Banners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['showInApp'] = this.showInApp;
    data['price'] = this.price;
    data['gender'] = this.gender;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    if (this.brand != null) {
      data['brand'] = this.brand.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
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
