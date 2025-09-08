import 'categories.dart';

class PromoCode {
  int id;
  String code;
  bool useOnce;
  DateTime expireDate;
  int discountPercent;
  double discountValue;
  List<Categories> categories;

  PromoCode(
      {this.id,
      this.code,
      this.useOnce,
      this.expireDate,
      this.discountPercent,
      this.categories,
      this.discountValue});

  PromoCode.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    useOnce = json['useOnce'];
    String date = json['expireDate'];
    if (date != null) {
      expireDate = new DateTime(int.parse(date.substring(0, 4)),
          int.parse(date.substring(5, 7)), int.parse(date.substring(8, 10)));
    }
    discountPercent = json['discountPercent'];
    discountValue = double.parse(json['discountValue']);
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['code'] = this.code;
    data['useOnce'] = this.useOnce;
    data['expireDate'] = this.expireDate;
    data['discountPercent'] = this.discountPercent;
    data['discountValue'] = this.discountValue;
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
