import 'package:flutter/src/widgets/framework.dart';

import '../../../core/services/preference/preference.dart';

class RequestType {
  static const String Get = 'get';
  static const String Post = 'post';
  static const String Put = 'put';
  static const String Delete = 'delete';
}

class Header {
  static Map<String, dynamic> get clientAuth {
    // final hashedClient = const Base64Encoder().convert("$clientID:".codeUnits);
    return {'Authorization': 'Bearer $token'};
  }

  static Map<String, dynamic> get userAuth =>
      {'Authorization': 'Bearer ${Preference.getString(PrefKeys.token)}'};
}

class EndPoint {
  static const String baseUrl = 'http://169.51.198.44:3001/v1/';
  //static const String baseUrl = 'https://beauty.remabackend.com/v1/';
  static const String WELCOME_SCREENS = 'WelcomeScreen/all';
  static const String REGISTER = 'auth/register';
  static const String LOGIN = 'auth/login';
  static const String UPDATE_USER_INFO = 'User/';
  static const String REFRESH_TOKEN = 'auth/refreshToken';
  static const String CHANGE_PASSWORD = 'auth/changePassword';
  static const String PROMOCODE = 'PromoCode/code';
  static const String FIRST_REQUEST = 'auth/requestToken/';
  static const String CATEGORIES = 'App/Subdivisions';
  static const String HOME_PAGE_ITEMS = 'App/homePage';
  static const String CATEGORY_ITEMS = 'Item/mobile';
  static const String COUNTRIES = 'Country/all';
  static const String CITIES = 'City/all/';
  static const String ADDRESS = 'Address';
  static const String USER_ADDRESS = 'Address/all/';
  static const String AVAILABLE_QTY = 'TrQty/all/forItem';
  static const String NEW_CART = 'Cart/add';
  static const String ADDWRAPPINGGIFT = 'Cart/addWrapping';
  static const String REMOVEWRAPPING = 'Cart/removeWrapping';
  static const String GET_CARTS = 'Cart/get';
  static const String REMOVE_FROM_CART = 'Cart/remove';
  static const String FAVOURITES = 'Cart/fav';
  static const String PAYMENT = 'Ceckout';
  static const String USER_ORDERS = 'Order/byUser/';
  static const String ORDER_PAYMENT = 'Order/pay/';
  static const String DELIVERY_ORDERS = 'Order/all/pending';
  static const String EMAIL_RESET = 'auth/resetPassword/';
  static const String PASSWORD_RESET = 'auth/changePassword/';
  static const String UPDATE_DELIVERY_STATUS = 'Order/shipping/';
  static const String ITEMBYID = 'Item/';
  static const String FCMTOKEN = 'User/updateFcm';
  static const String OTHER_BANNERS = 'Banner/all/other';
  static const String BRANDS = 'Brand/all/mobile';
  static const String USER = 'user';
  static const String REVIEW = 'Review';
  static const String USERNOTIFICATION = 'userNotification';
  static const String PermessionGroup = 'permessionGroup';
  static const String APPSETTINGS = 'appsettings';
  static const String POST = 'post';
  static const String COMMENT = 'comment';
  static const String REPLY = 'reply';
  static const String WRAPPING = 'Wrapping';
  static const String HOMELIST = 'HomeList/mobile';
  static String currencyUrl({@required String isoCode}) => 'currency/$isoCode';
  static const String NEW_SEARCH = "Item/new/search";
}

enum APIState { lazy, ready }

abstract class Api {
  recordFcm(BuildContext context, {String fcm});
}
//
//
