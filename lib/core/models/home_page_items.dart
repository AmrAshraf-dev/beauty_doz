import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';

class HomePageItems {
  List<Banners> banners;
  List<Brand> brands;
  List<CategoryItems> topSellers;
  List<CategoryItems> recentlyAdded;
   List<CategoryItems> nichPerfumes;

  HomePageItems(
      {this.banners, this.brands, this.topSellers, this.recentlyAdded,this.nichPerfumes});

  HomePageItems.fromJson(Map<String, dynamic> json) {
    if (json['banners'] != null) {
      banners = <Banners>[];
      json['banners'].forEach((v) {
        banners.add(new Banners.fromJson(v));
      });
    }
    if (json['brands'] != null) {
      brands = <Brand>[];
      json['brands'].forEach((v) {
        brands.add(new Brand.fromJson(v));
      });
    }
    if (json['topSellers'] != null) {
      topSellers = <CategoryItems>[];
      json['topSellers'].forEach((v) {
        topSellers.add(new CategoryItems.fromJson(v));
      });
    }
    if (json['recentlyAdded'] != null) {
      recentlyAdded = <CategoryItems>[];
      json['recentlyAdded'].forEach((v) {
        recentlyAdded.add(new CategoryItems.fromJson(v));
      });
    }
      if (json['nichPerfumes'] != null) {
       nichPerfumes = <CategoryItems>[];
       json['nichPerfumes'].forEach((v) {
         nichPerfumes.add(CategoryItems.fromJson(v));
       });
     }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.banners != null) {
      data['banners'] = this.banners.map((v) => v.toJson()).toList();
    }
    if (this.brands != null) {
      data['brands'] = this.brands.map((v) => v.toJson()).toList();
    }
    if (this.topSellers != null) {
      data['topSellers'] = this.topSellers.map((v) => v.toJson()).toList();
    }
    if (this.recentlyAdded != null) {
      data['recentlyAdded'] =
          this.recentlyAdded.map((v) => v.toJson()).toList();
    }
     if (this.nichPerfumes != null) {
       data['nichPerfumes'] = this.nichPerfumes.map((v) => v.toJson()).toList();
     }
    return data;
  }
}

class Banners {
  int id;
  String image;
  String type;
  Title title;

  Banners({this.id, this.image, this.type, this.title});

  Banners.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    type = json['type'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['type'] = this.type;
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    return data;
  }
}

class Title {
  String ar;
  String en;

  Title({this.ar, this.en});

  Title.fromJson(Map<String, dynamic> json) {
    ar = json['ar'];
    en = json['en'];
  }

  String localized(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return locale.locale == Locale("en") ? en : ar;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ar'] = this.ar;
    data['en'] = this.en;
    return data;
  }
}


// class TopSellers {
//   bool inFavorate;
//   int id;
//   String code;
//   int priority;
//   String image;
//   bool showInApp;
//   dynamic price;
//   String gender;
//   dynamic purchasePrice;
//   Title name;
//   Title description;
//   List<Reviews> reviews;
//   int discount;
//   dynamic priceAfter;
//   int availableQty;
//   int cRating;

//   TopSellers(
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
//       this.reviews,
//       this.discount,
//       this.priceAfter,
//       this.availableQty,
//       this.cRating});

//   TopSellers.fromJson(Map<String, dynamic> json) {
//     inFavorate = json['inFavorate'];
//     id = json['id'];
//     code = json['code'];
//     priority = json['priority'];
//     image = json['image'];
//     showInApp = json['showInApp'];
//     price = json['price'];
//     gender = json['gender'];
//     purchasePrice = json['purchasePrice'];
//     name = json['name'] != null ? new Title.fromJson(json['name']) : null;
//     description = json['description'] != null
//         ? new Title.fromJson(json['description'])
//         : null;
//     // if (json['reviews'] != null) {
//     //   reviews = new List<Null>();
//     //   json['reviews'].forEach((v) {
//     //     reviews.add(new Null.fromJson(v));
//     //   });
//     // }
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
//     // if (this.reviews != null) {
//     //   data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
//     // }
//     data['discount'] = this.discount;
//     data['priceAfter'] = this.priceAfter;
//     data['availableQty'] = this.availableQty;
//     data['cRating'] = this.cRating;
//     return data;
//   }
// }

// class RecentlyAdded {
//   bool inFavorate;
//   int id;
//   String code;
//   int priority;
//   String image;
//   bool showInApp;
//   dynamic price;
//   String gender;
//   dynamic purchasePrice;
//   Title name;
//   Title description;
//   List<Null> reviews;
//   int discount;
//   dynamic priceAfter;
//   int availableQty;
//   int cRating;

//   RecentlyAdded(
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
//       this.reviews,
//       this.discount,
//       this.priceAfter,
//       this.availableQty,
//       this.cRating});

//   RecentlyAdded.fromJson(Map<String, dynamic> json) {
//     inFavorate = json['inFavorate'];
//     id = json['id'];
//     code = json['code'];
//     priority = json['priority'];
//     image = json['image'];
//     showInApp = json['showInApp'];
//     price = json['price'];
//     gender = json['gender'];
//     purchasePrice = json['purchasePrice'];
//     name = json['name'] != null ? new Title.fromJson(json['name']) : null;
//     description = json['description'] != null
//         ? new Title.fromJson(json['description'])
//         : null;
//     // if (json['reviews'] != null) {
//     //   reviews = new List<Null>();
//     //   json['reviews'].forEach((v) {
//     //     reviews.add(new Null.fromJson(v));
//     //   });
//     // }
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
//     // if (this.reviews != null) {
//     //   data['reviews'] = this.reviews.map((v) => v.toJson()).toList();
//     // }
//     data['discount'] = this.discount;
//     data['priceAfter'] = this.priceAfter;
//     data['availableQty'] = this.availableQty;
//     data['cRating'] = this.cRating;
//     return data;
//   }
// }
