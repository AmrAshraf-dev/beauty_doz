import 'package:beautydoz/core/models/categories.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';

class CategoryItems {
  bool inFavorate;
  int id;
  String code;
  int priority;
  String image;
  bool showInApp;
  dynamic price;
  String gender;
  dynamic purchasePrice;
  Name name;
  Name description;
  List<Categories> categories;
  List<Null> banners;
  Brand brand;
  List<Reviews> reviews;
  bool haveOptions;
  List<ItemOptions> options;
  dynamic discount;
  dynamic priceAfter;
  int availableQty;
  dynamic cRating;

  CategoryItems(
      {this.inFavorate,
      this.id,
      this.code,
      this.priority,
      this.image,
      this.showInApp,
      this.price,
      this.gender,
      this.purchasePrice,
      this.name,
      this.description,
      this.categories,
      this.banners,
      this.brand,
      this.reviews,
      this.haveOptions,
      this.options,
      this.discount,
      this.priceAfter,
      this.availableQty,
      this.cRating});

  CategoryItems.fromJson(Map<String, dynamic> json) {
    inFavorate = json['inFavorate'];
    id = json['id'];
    code = json['code'];
    priority = json['priority'];
    image = json['image'];
    showInApp = json['showInApp'];
    price = json['price'];
    gender = json['gender'];
    purchasePrice = json['purchasePrice'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    description = json['description'] != null
        ? new Name.fromJson(json['description'])
        : null;
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    // if (json['banners'] != null) {
    //   banners = new List<Null>();
    //   json['banners'].forEach((v) {
    //     banners.add(new Null.fromJson(v));
    //   });
    // }
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    if (json['reviews'] != null) {
      reviews = <Reviews>[];
      json['reviews'].forEach((v) {
        reviews.add(new Reviews.fromJson(v));
      });
    }
    haveOptions = json['haveOptions'] ?? false;

    if (json['options'] != null) {
      options = <ItemOptions>[];
      json['options'].forEach((v) {
        options.add(new ItemOptions.fromJson(v));
      });
    }
    discount = json['discount'];
    priceAfter = json['priceAfter'];
    availableQty = json['availableQty'];
    cRating = json['cRating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['inFavorate'] = this.inFavorate;
    data['id'] = this.id;
    data['code'] = this.code;
    data['priority'] = this.priority;
    data['image'] = this.image;
    data['showInApp'] = this.showInApp;
    data['price'] = this.price;
    data['gender'] = this.gender;
    data['purchasePrice'] = this.purchasePrice;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description.toJson();
    }
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    // if (this.banners != null) {
    //   data['banners'] = this.banners.map((v) => v.toJson()).toList();
    // }
    if (this.brand != null) {
      data['brand'] = this.brand.toJson();
    }
    if (this.reviews != null) {
      data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
    }
    data['haveOptions'] = this.haveOptions;

    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    data['discount'] = this.discount;
    data['priceAfter'] = this.priceAfter;
    data['availableQty'] = this.availableQty;
    data['cRating'] = this.cRating;
    return data;
  }
}

class Brand {
  int id;
  String image;
  Name name;
  // List<CategoryItems> items;

  Brand({
    this.id,
    this.image,
    this.name,
    /* this.items */
  });

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    // if (json['items'] != null) {
    //   items = new List<CategoryItems>();
    //   json['items'].forEach((v) {
    //     items.add(new CategoryItems.fromJson(v));
    //   });
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    // if (this.items != null) {
    //   data['items'] = this.items.map((v) => v.toJson()).toList();
    // }
    return data;
  }
}

class ItemOptions {
  int id;
  Name name;
  bool isText;
  List<ItemOptionsValues> values;

  ItemOptions({this.id, this.name, this.isText, this.values});

  ItemOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    isText = json['isText'];
    if (json['values'] != null) {
      values = <ItemOptionsValues>[];
      json['values'].forEach((v) {
        values.add(new ItemOptionsValues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    data['isText'] = this.isText;
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemOptionsValues {
  int id;
  Name name;
  ItemOptions options;

  ItemOptionsValues({this.id, this.name, this.options});

  ItemOptionsValues.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    options = json['option'] != null
        ? new ItemOptions.fromJson(json['option'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.options != null) {
      data['option'] = this.options.toJson();
    }
    return data;
  }
}

// class Items {
//   bool inFavorate;
//   int id;
//   String code;
//   int priority;
//   String image;
//   bool showInApp;
//   dynamic price;
//   String gender;
//   dynamic purchasePrice;
//   Name name;
//   Name description;
//   List<Categories> categories;
//   List<Banners> banners;
//   Brand brand;
//   List<Reviews> reviews;
//   dynamic discount;
//   dynamic priceAfter;
//   int availableQty;
//   dynamic cRating;

//   Items(
//       {this.inFavorate,
//       this.id,
//       this.code,
//       this.priority,
//       this.image,
//       this.showInApp,
//       this.price,
//       this.gender,
//       this.purchasePrice,
//       this.name,
//       this.description,
//       this.categories,
//       this.banners,
//       this.brand,
//       this.reviews,
//       this.discount,
//       this.priceAfter,
//       this.availableQty,
//       this.cRating});

//   Items.fromJson(Map<String, dynamic> json) {
//     inFavorate = json['inFavorate'];
//     id = json['id'];
//     code = json['code'];
//     priority = json['priority'];
//     image = json['image'];
//     showInApp = json['showInApp'];
//     price = json['price'];
//     gender = json['gender'];
//     purchasePrice = json['purchasePrice'];
//     name = json['name'] != null ? new Name.fromJson(json['name']) : null;
//     description = json['description'] != null
//         ? new Name.fromJson(json['description'])
//         : null;
//     if (json['categories'] != null) {
//       categories = new List<Categories>();
//       json['categories'].forEach((v) {
//         categories.add(new Categories.fromJson(v));
//       });
//     }
//     if (json['banners'] != null) {
//       banners = new List<Banners>();
//       json['banners'].forEach((v) {
//         banners.add(new Banners.fromJson(v));
//       });
//     }
//     brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
//     if (json['reviews'] != null) {
//       reviews = new List<Reviews>();
//       json['reviews'].forEach((v) {
//         reviews.add(new Reviews.fromJson(v));
//       });
//     }
//     discount = json['discount'];
//     priceAfter = json['priceAfter'];
//     availableQty = json['availableQty'];
//     cRating = json['cRating'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['inFavorate'] = this.inFavorate;
//     data['id'] = this.id;
//     data['code'] = this.code;
//     data['priority'] = this.priority;
//     data['image'] = this.image;
//     data['showInApp'] = this.showInApp;
//     data['price'] = this.price;
//     data['gender'] = this.gender;
//     data['purchasePrice'] = this.purchasePrice;
//     if (this.name != null) {
//       data['name'] = this.name.toJson();
//     }
//     if (this.description != null) {
//       data['description'] = this.description.toJson();
//     }
//     if (this.categories != null) {
//       data['categories'] = this.categories.map((v) => v.toJson()).toList();
//     }
//     if (this.banners != null) {
//       data['banners'] = this.banners.map((v) => v.toJson()).toList();
//     }
//     if (this.brand != null) {
//       data['brand'] = this.brand.toJson();
//     }
//     if (this.reviews != null) {
//       data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
//     }
//     data['discount'] = this.discount;
//     data['priceAfter'] = this.priceAfter;
//     data['availableQty'] = this.availableQty;
//     data['cRating'] = this.cRating;
//     return data;
//   }
// }

class Reviews {
  int id;
  String comment;
  dynamic rating;
  String valueDate;
  CategoryUser user;

  Reviews({this.id, this.comment, this.rating, this.valueDate, this.user});

  Reviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    comment = json['comment'];
    rating = json['rating'];
    valueDate = json['valueDate'];
    user =
        json['user'] != null ? new CategoryUser.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['valueDate'] = this.valueDate;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class CategoryUser {
  String name;
  int id;

  CategoryUser({this.name, this.id});

  CategoryUser.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
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
    ar = json['ar'] ?? " ";
    en = json['en'] ?? " ";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    return data;
  }
}
