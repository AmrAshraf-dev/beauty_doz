import 'package:beautydoz/core/models/categories.dart';
import 'package:beautydoz/core/models/category_items.dart';

class FavouritesModel {
  String type;
  User user;
  int id;
  List<Lines> lines;

  FavouritesModel({this.type, this.user, this.id, this.lines});

  FavouritesModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    id = json['id'];
    if (json['lines'] != null) {
      lines = <Lines>[];
      json['lines'].forEach((v) {
        lines.add(new Lines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['id'] = this.id;
    if (this.lines != null) {
      data['lines'] = this.lines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int id;
  String name;
  String email;
  String password;
  String userType;
  bool isActive;
  String tempCode;
  Mobile mobile;

  User(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.userType,
      this.isActive,
      this.tempCode,
      this.mobile});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    userType = json['userType'];
    isActive = json['isActive'];
    tempCode = json['tempCode'];
    mobile =
        json['mobile'] != null ? new Mobile.fromJson(json['mobile']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['userType'] = this.userType;
    data['isActive'] = this.isActive;
    data['tempCode'] = this.tempCode;
    if (this.mobile != null) {
      data['mobile'] = this.mobile.toJson();
    }
    return data;
  }
}

class Mobile {
  String extintion;
  String number;

  Mobile({this.extintion, this.number});

  Mobile.fromJson(Map<String, dynamic> json) {
    extintion = json['extintion'];
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['extintion'] = this.extintion;
    data['number'] = this.number;
    return data;
  }
}

class Lines {
  int id;
  int quantity;
  CategoryItems item;

  Lines({this.id, this.quantity, this.item});

  Lines.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    quantity = json['quantity'];
    item =
        json['item'] != null ? new CategoryItems.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['quantity'] = this.quantity;
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

class Banners {
  int id;
  String image;
  Name title;
  Name description;

  Banners({this.id, this.image, this.title, this.description});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'] != null ? new Name.fromJson(json['title']) : null;
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    return data;
  }
}
