class User {
  String token;
  UserInfo user;

  User({this.token, this.user});

  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    user = json['user'] != null ? new UserInfo.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class UserInfo {
  int id;
  String name;
  String email;
  String password;
  Mobile mobile;
  String userType;
  bool isActive;
  String fcmToken;
  String tempCode;

  UserInfo(
      {this.id,
      this.name,
      this.email,
      this.password,
      this.mobile,
      this.userType,
      this.isActive,
      this.fcmToken,
      this.tempCode});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    mobile =
        json['mobile'] != null ? new Mobile.fromJson(json['mobile']) : null;
    userType = json['userType'];
    isActive = json['isActive'];
    fcmToken = json['fcmToken'];
    tempCode = json['tempCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    if (this.mobile != null) {
      data['mobile'] = this.mobile.toJson();
    }
    data['userType'] = this.userType;
    data['isActive'] = this.isActive;
    data['tempCode'] = this.tempCode;
    data['fcmToken'] = this.fcmToken;
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

  @override
  String toString() {
    return ' +' + extintion + number;
  }
}
