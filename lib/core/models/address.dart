import 'package:beautydoz/core/models/cities.dart';
import 'package:beautydoz/core/models/countries.dart';

class Address {
  int id;
  String state;
  String line1;
  String line2;
  String line3; //* NOTES
  String postCode;
  Countries country;
  Cities city;

  Address(
      {this.id,
      this.state,
      this.line1,
      this.line2,
        this.line3, //* NOTES
      this.postCode,
      this.country,
      this.city});

  Address.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    state = json['state'];
    line1 = json['line1'];
    line2 = json['line2'];
    line3 = json['line3']; //* NOTES
    postCode = json['postCode'];
    country = json['country'] != null
        ? new Countries.fromJson(json['country'])
        : null;
    city = json['city'] != null ? new Cities.fromJson(json['city']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['state'] = this.state;
    data['line1'] = this.line1;
    data['line2'] = this.line2;
     data["line3"] = this.line3; //* NOTES
    data['postCode'] = this.postCode;
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    return data;
  }
}
