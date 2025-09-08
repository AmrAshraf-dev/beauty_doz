import 'package:beautydoz/core/models/category_items.dart';

class CartOption {
  int id;
  String optionText;
  ItemOptions itemOption;
  ItemOptionsValues optionValue;

  CartOption({this.id, this.optionText, this.itemOption, this.optionValue});

  CartOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optionText = json['optionText'];
    itemOption = json['itemOption'] != null
        ? new ItemOptions.fromJson(json['itemOption'])
        : null;
    optionValue = json['optionValue'] != null
        ? new ItemOptionsValues.fromJson(json['optionValue'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['optionText'] = this.optionText;
    if (this.itemOption != null) {
      data['itemOption'] = this.itemOption.toJson();
    }
    if (this.optionValue != null) {
      data['optionValue'] = this.optionValue.toJson();
    }
    return data;
  }
}

class ItemOption {
  int id;
  bool isText;
  Name name;
  List<ItemOptionsValues> values;

  ItemOption({this.id, this.isText, this.name, this.values});

  ItemOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isText = json['isText'];
    name = json['name'] != null ? new Name.fromJson(json['name']) : null;
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
    data['isText'] = this.isText;
    if (this.name != null) {
      data['name'] = this.name.toJson();
    }
    if (this.values != null) {
      data['values'] = this.values.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

// class Values {
//   int id;
//   Name name;

//   Values({this.id, this.name});

//   Values.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     name = json['name'] != null ? new Name.fromJson(json['name']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     if (this.name != null) {
//       data['name'] = this.name.toJson();
//     }
//     return data;
//   }
// }
