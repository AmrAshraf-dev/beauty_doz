import 'countries.dart';

class Cities {
  int id;
  dynamic shippingCost;
  Name name;
  Countries country;

  Cities({this.id, this.shippingCost, this.name, this.country});

  Cities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    shippingCost = json['shippingCost'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
    country = json['country'] != null
        ? new Countries.fromJson(json['country'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['shippingCost'] = this.shippingCost;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
    return data;
  }
}
