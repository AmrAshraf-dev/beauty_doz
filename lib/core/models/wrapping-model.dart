class GiftWrapping {
  int id;
  String from;
  String to;
  String message;
  int qty;
  Wrapping wrapping;

  GiftWrapping(
      {this.id, this.from, this.to, this.message, this.qty, this.wrapping});

  GiftWrapping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    from = json['from'];
    to = json['to'];
    message = json['message'];
    qty = json['qty'];
    wrapping = json['wrapping'] != null
        ? new Wrapping.fromJson(json['wrapping'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['from'] = this.from;
    data['to'] = this.to;
    data['message'] = this.message;
    data['qty'] = this.qty;
    if (this.wrapping != null) {
      data['wrapping'] = this.wrapping.toJson();
    }
    return data;
  }
}

class Wrapping {
  int id;
  String image;
  String price;

  Wrapping({this.id, this.image, this.price});

  Wrapping.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['price'] = this.price;
    return data;
  }
}
