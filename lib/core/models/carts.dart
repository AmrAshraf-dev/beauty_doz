import 'package:beautydoz/core/models/cart_options.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/models/user.dart';
import 'package:beautydoz/core/models/wrapping-model.dart';

class Cart {
  int id;
  String type;
  User user;
  GiftWrapping giftWrapping;
  List<Lines> lines;
  dynamic totalItems;
  dynamic totalPrice;

  Cart(
      {this.id,
      this.type,
      this.user,
      this.lines,
      this.giftWrapping,
      this.totalItems,
      this.totalPrice});

  Cart.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    giftWrapping = json['giftWrapping'] != null
        ? new GiftWrapping.fromJson(json['giftWrapping'])
        : null;
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    if (json['lines'] != null) {
      lines = <Lines>[];
      json['lines'].forEach((v) {
        lines.add(new Lines.fromJson(v));
      });
    }

    totalItems = json['totalItems'] ?? 0;
    totalPrice = json['totalPrice'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type'] = this.type;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.giftWrapping != null) {
      data['giftWrapping'] = this.giftWrapping.toJson();
    }
    if (this.lines != null) {
      data['lines'] = this.lines.map((v) => v.toJson()).toList();
    }

    data['totalItems'] = this.totalItems;
    data['totalPrice'] = this.totalPrice;
    return data;
  }
}

class Lines {
  int id;
  int quantity;
  CategoryItems item;
  dynamic price;
  int availableQty;
  List<CartOption> options;

  Lines({this.id, this.quantity, this.item, this.price, this.availableQty});

  Lines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    item =
        json['item'] != null ? new CategoryItems.fromJson(json['item']) : null;
    price = json['price'];
    availableQty = json['availableQty'];
    if (json['options'] != null) {
      options = <CartOption>[];
      json['options'].forEach((v) {
        options.add(new CartOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    data['price'] = this.price;
    data['availableQty'] = this.availableQty;
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Name {
  String ar;
  String en;

  Name({this.ar, this.en});

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
