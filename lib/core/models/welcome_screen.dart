import 'package:beautydoz/core/models/category_items.dart';

class WelcomeScreen {
  int id;
  String image;
  Name title;
  Name body;

  WelcomeScreen({this.id, this.image, this.title, this.body});

  WelcomeScreen.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    title = json['title'] != null ? new Name.fromJson(json['title']) : null;
    body = json['body'] != null ? new Name.fromJson(json['body']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    if (this.title != null) {
      data['title'] = this.title.toJson();
    }
    if (this.body != null) {
      data['body'] = this.body.toJson();
    }
    return data;
  }
}
