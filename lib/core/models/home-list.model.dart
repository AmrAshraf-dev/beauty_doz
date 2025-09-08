import 'category_items.dart';

class HomeList {
  int id;
  Name title;
  List<CategoryItems> items;

  HomeList({this.id, this.title, this.items});

  HomeList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Name.fromJson(json['title']) : null;
    if (json['items'] != null) {
      items = <CategoryItems>[];
      json['items'].forEach((v) {
        items.add(new CategoryItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
