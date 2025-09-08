import 'dart:async';
import 'dart:convert';

import 'package:beautydoz/core/models/address.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/models/categories.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/models/cities.dart';
import 'package:beautydoz/core/models/countries.dart';
import 'package:beautydoz/core/models/currency_model.dart';
import 'package:beautydoz/core/models/favourite_model.dart' as favo;
import 'package:beautydoz/core/models/home-list.model.dart';
import 'package:beautydoz/core/models/home_page_items.dart';
import 'package:beautydoz/core/models/myorders.dart';
import 'package:beautydoz/core/models/new_search_model.dart';
import 'package:beautydoz/core/models/promocode.dart';
import 'package:beautydoz/core/models/welcome_screen.dart';
import 'package:beautydoz/core/models/wrapping-model.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/models/user.dart';
import '../../../core/models/user_notification.dart';
import '../../../core/services/preference/preference.dart';
import 'api.dart';

class HttpApi implements Api {
  Dio _dio;
  // final baseUrl = 'http://server.overrideeg.net:3001/v1/';
  // final baseUrl = 'https://beauty.remabackend.com/v1/';
  // final baseUrl = 'http://192.168.8.100:3001/v1/';

  AppLocalizations locale;

  // APIState state = APIState.lazy;
  // ConnectivityService connectivity;
  //stream allow to subscribe to connection changes
  // StreamController<APIState> _stateStreamController = StreamController.broadcast();
  // Stream<APIState> get stateChange => _stateStreamController.stream;

  HttpApi() {
    // connectivity = Provider.of(context, listen: false);
    setupDio();
  }

  setupDio() async {
    _dio = Dio(BaseOptions(connectTimeout: 15000, receiveTimeout: 15000));
    // connectivity.connectivityStreamController.stream.listen((online) async {
    //   if (online) {
    //     await loadBaseUrl();
    //   }
    // });
  }

  Future<dynamic> request(String url,
      {dynamic body,
      BuildContext context,
      Function onSendProgress,
      Map<String, dynamic> headers,
      String type = RequestType.Get,
      Map<String, dynamic> queryParameters,
      String contentType = Headers.jsonContentType,
      bool retry = false,
      ResponseType responseType = ResponseType.json}) async {
    Response response;
    final options = Options(
        sendTimeout: 100000,
        receiveTimeout: 100000,
        headers: headers,
        contentType: contentType,
        responseType: responseType);
    await setupDio();

    if (onSendProgress == null) {
      onSendProgress = (int sent, int total) {
        // print('$url\n sent: $sent total: $total\n');
      };
    }

    ///load current server url
    // final baseUrl = Preference.getString(PrefKeys.baseUrl);

    Logger().i('🍉request $EndPoint ${EndPoint.baseUrl}$url $headers');

    try {
      switch (type) {
        case RequestType.Get:
          {
            response = await _dio.get(EndPoint.baseUrl + url,
                queryParameters: queryParameters, options: options);
          }
          break;
        case RequestType.Post:
          {
            response = await _dio.post(EndPoint.baseUrl + url,
                queryParameters: queryParameters,
                onSendProgress: onSendProgress,
                data: body ?? {},
                options: options);
          }
          break;
        case RequestType.Put:
          {
            response = await _dio.put(EndPoint.baseUrl + url,
                queryParameters: queryParameters,
                data: body ?? {},
                options: options);
          }
          break;
        case RequestType.Delete:
          {
            response = await _dio.delete(EndPoint.baseUrl + url,
                queryParameters: queryParameters,
                data: body ?? {},
                options: options);
          }
          break;
        default:
          break;
      }

      print(response);

      if (response.statusCode == 200 || response.statusCode == 201) {
        /// 🦄map of string dynamic...
        return response.data;
      } else {
        Logger().e('🌐🌐ERROR in http $type for $url:🌐🌐\n' +
            '${response.statusCode}: ${response.statusMessage} ${response.data}');

        await checkSessionExpired(context: context, response: response);
      }
    } on DioError catch (e) {
      if (e.response != null) {
        Logger().e('🌐🌐DIO ERROR in http $type for $url:🌐🌐\n' +
            '${e?.response?.statusCode}: ${e?.response?.statusMessage} ${e?.response?.data}\n' +
            e.toString());

        UI.toast(locale != null
            ? locale.get(e.response.data['message'])
            : e.response.data['message']);

        if (e?.response?.statusCode == 401 && !retry && context != null) {
          // sending Refresh token
          Logger().w('Try to send refresh token');
          await refreshToken(context);
          return await request(url,
              body: body,
              queryParameters: queryParameters,
              headers: Header.userAuth,
              context: context,
              type: type,
              contentType: contentType,
              responseType: responseType,
              retry: true);
        } else if (e.response.statusCode == 401 && retry && context != null) {
          Logger().w("Checking session expired");
          await checkSessionExpired(context: context, response: e.response);
        } else {
          Logger().e(e.error);
        }
      }
    }
    // } on DioError catch (e) {
    //   Logger().e('🌐🌐DIO ERROR in http $type for $url:🌐🌐\n' +
    //       '${e.response.statusCode}: ${e.response.statusMessage} ${e.response.data}\n' +
    //       e.toString());

    //   if (e.response.statusCode == 401 && context != null) {
    //     // sending Refresh token
    //     Logger().w('Session expired 1 ');
    //     await checkSessionExpired(context: context, response: e.response);
    //   }
    // }
  }

  checkSessionExpired({Response response, BuildContext context}) async {
    if (context != null &&
        (response.statusCode == 401 || response.statusCode == 500)) {
      final expiredMsg = response.data['message'];
      final authExpired = expiredMsg != null && expiredMsg == 'Unauthorized';

      if (authExpired) {
        await AuthenticationService.handleAuthExpired(context: context);
      }
    }
  }

  Future<User> signUp({Map<String, dynamic> param}) async {
    final body = {
      "name": param['name'],
      "email": param['email'],
      "password": param['password'],
      "userType": param['userType'],
      'isActive': param['isActive'],
      'mobile': param['mobile']
    };
    try {
      final response = await request(EndPoint.REGISTER,
          type: RequestType.Post, body: body, headers: Header.clientAuth);
      if (response != null && response['user'] != null) {
        return User.fromJson(response);
      }
    } catch (e) {
      return null;
    }

    return null;
  }

  Future<User> signIn({Map<String, dynamic> body}) async {
    final response = await request(EndPoint.LOGIN,
        type: RequestType.Post, body: body, headers: Header.clientAuth);

    User user;

    if (response['user'] != null) {
      user = User.fromJson(response);
    }

    final token = user.token;

    if (token == null) {
      return null;
    }

    await Preference.setString(PrefKeys.token, token);

    if (user != null) {
      return user;
    } else {
      return null;
    }
  }

  Future<bool> refreshToken(BuildContext context) async {
    String email = null;
    try {
      email = Provider.of<AuthenticationService>(context, listen: false)
          .user
          .user
          .email;
    } catch (e) {
      print(e);
    }
    if (email == null) {
      UI.toast('please log in again');
      UI.pushReplaceAll(context, Routes.signIn);
    }

    String oldToken =
        Provider.of<AuthenticationService>(context, listen: false).user?.token;

    final body = {"oldtoken": oldToken, "email": email};
    print(body);
    var tokenResponse;
    tokenResponse = await request(EndPoint.REFRESH_TOKEN,
        type: RequestType.Put,
        body: body,
        headers: Header.clientAuth,
        context: context);

    print(tokenResponse);

    User user;

    if (tokenResponse != null && tokenResponse['token'] != null) {
      user = User.fromJson(tokenResponse);
      Provider.of<AuthenticationService>(context, listen: false)
          .saveUser(user: user);
    }

    final token = tokenResponse["token"];

    final tokenRefreshed = token != null;

    if (tokenRefreshed) {
      await Preference.setString(PrefKeys.token, token);
    }
    return tokenRefreshed;
  }

  // Future<bool> updateUserFcm({String fcmToken}) async {
  //   final Map<String, dynamic> header = {"fcmToken": fcmToken};

  //   final response = await request(EndPoint.FCMTOKEN,

  //       type: RequestType.Post, headers: header..addAll(Header.userAuth));

  //   return response != null && response['id'] != null;
  // }

  Future getNotifications(
      {@required BuildContext context,
      @required int userId,
      @required int lastId}) async {
    final Map<String, dynamic> queryParameters = {"userId": userId};

    if (lastId != null) {
      queryParameters['lastId'] = lastId;
    }
    final response = await request(EndPoint.USERNOTIFICATION,
        context: context,
        type: RequestType.Get,
        queryParameters: queryParameters,
        headers: Header.userAuth);
    return response
        ?.map<UserNotification>((item) => UserNotification.fromJson(item))
        ?.toList();
  }

  Future<String> getUserToken(BuildContext context, String mac) async {
    try {
      final response = await request(EndPoint.FIRST_REQUEST + mac,
          type: RequestType.Post, headers: Header.clientAuth, context: context);

      if (response != null && response['token'] != null) {
        return response['token'];
      }
    } catch (e) {
      Logger().e('error in  method $e');
    }
    return null;
  }

  Future<PromoCode> getPromoCode(String code) async {
    final res = await request(
      EndPoint.PROMOCODE + '/$code',
      type: RequestType.Get,
      headers: Header.userAuth,
    );

    if (res == null)
      return null;
    else
      return PromoCode.fromJson(res);
  }

  Future<User> changePassword(BuildContext context,
      {Map<String, dynamic> param}) async {
    print(param);
    final response = await request(EndPoint.CHANGE_PASSWORD,
        type: RequestType.Post,
        headers: Header.userAuth,
        body: param,
        context: context);
    if (response != null && response['id'] != null) {
      return User.fromJson(response);
    } else {
      return null;
    }
  }

  Future<List<Categories>> getCategories(BuildContext context) async {
    final response = await request(EndPoint.CATEGORIES,
        type: RequestType.Get, headers: Header.userAuth, context: context);

    return response != null && response['Categories'] != null
        ? response['Categories']
            .map<Categories>((item) => Categories.fromJson(item))
            .toList()
        : response.length == 0
            ? []
            : null;
  }

  Future<HomePageItems> getHomePageItems(BuildContext context) async {
    final locale = AppLocalizations.of(context);
    Map<String, dynamic> queryParam = {'lang': locale.locale.languageCode};

    final response = await request(EndPoint.HOME_PAGE_ITEMS,
        type: RequestType.Get,
        headers: Header.userAuth,
        queryParameters: queryParam,
        context: context);

    return response != null && response['banners'] != null
        ? HomePageItems.fromJson(response)
        : null;
  }

  Future<List<CategoryItems>> getCategoryItems(BuildContext context,
      {Map<String, dynamic> param}) async {
    param.removeWhere((key, value) => value == null || value == "");

    final response = await request(EndPoint.CATEGORY_ITEMS,
        type: RequestType.Get,
        headers: Header.userAuth,
        queryParameters: param,
        context: context);
    if (response != null && response.length > 0) {
      return response
          .map<CategoryItems>((item) => CategoryItems.fromJson(item))
          .toList();
    } else {
      return null;
    }
  }

  Future<List<Countries>> getCountries(BuildContext context) async {
    final response = await request(EndPoint.COUNTRIES,
        type: RequestType.Get, headers: Header.userAuth, context: context);
    return response != null
        ? response.map<Countries>((item) => Countries.fromJson(item)).toList()
        : null;
  }

  Future<List<Cities>> getCities(BuildContext context, {int countryId}) async {
    final response = await request(EndPoint.CITIES + countryId.toString(),
        type: RequestType.Get, headers: Header.userAuth, context: context);
    return response != null
        ? response.map<Cities>((item) => Cities.fromJson(item)).toList()
        : null;
  }

  Future<bool> saveAddress(BuildContext context,
      {Map<String, dynamic> body}) async {
    final response = await request(EndPoint.ADDRESS,
        type: RequestType.Post,
        headers: Header.userAuth,
        body: body,
        context: context);
    return response != null &&
            response['city'] != null &&
            response['country'] != null
        ? true
        : false;
  }

  Future<bool> updateAddress(BuildContext context,
      {Map<String, dynamic> body, int addressId}) async {
    final response = await request(
        EndPoint.ADDRESS + '/' + addressId.toString(),
        type: RequestType.Put,
        headers: Header.userAuth,
        body: body);
    return response != null &&
            response['city'] != null &&
            response['country'] != null
        ? true
        : false;
  }

  Future<List<Address>> getUserAddress(
      {BuildContext context, int userId}) async {
    print(PrefKeys.token);
    final response = await request(EndPoint.USER_ADDRESS + userId.toString(),
        type: RequestType.Get, headers: Header.userAuth, context: context);
    return response != null && response.length > 0
        ? response.map<Address>((item) => Address.fromJson(item)).toList()
        : null;
  }

  Future<bool> deleteAddress(BuildContext context, {int addressId}) async {
    final response = await request(
        EndPoint.ADDRESS + '/' + addressId.toString(),
        type: RequestType.Delete,
        headers: Header.userAuth,
        context: context);
    return response != null ? true : false;
  }

  Future<int> getAvailableQuantity(BuildContext context,
      {Map<String, int> param}) async {
    final response = await request(EndPoint.AVAILABLE_QTY,
        type: RequestType.Get,
        headers: Header.userAuth,
        queryParameters: param,
        context: context);
    print(response);
    return response != null ? response['quantity'] : null;
  }

  Future<Cart> newCartRequest(BuildContext context,
      {Map<String, dynamic> body}) async {
    final response = await request(EndPoint.NEW_CART,
            type: RequestType.Post,
            headers: Header.userAuth,
            body: body,
            context: context)
        .onError((error, stackTrace) => Logger().wtf(error));
    print(response);
    return response != null && response['lines'] != null
        ? Cart.fromJson(response)
        : null;
  }

  Future<Cart> getCarts(BuildContext context,
      {int userId, String promo}) async {
    Map<String, dynamic> query = {'userId': userId, 'promo': promo};

    final response = await request(EndPoint.GET_CARTS,
        type: RequestType.Get,
        headers: Header.userAuth,
        context: context,
        queryParameters: query);
    print(response);
    if (response != null && response['error'] == 'Cart is empty') {
      return Cart(lines: []);
    } else if (response['lines'] != null) {
      return Cart.fromJson(response);
    } else {
      return null;
    }
  }

  removerFromCart(BuildContext context, {int userId, int lineId}) async {
    final response = await request(EndPoint.REMOVE_FROM_CART,
        headers: Header.userAuth,
        context: context,
        type: RequestType.Delete,
        queryParameters: {'userId': userId, 'lineId': lineId});
    print(response);
    if (response['delted'] != null) {
      return Cart(lines: []);
    }
    return response != null && response['lines'] != null
        ? Cart.fromJson(response)
        : null;
  }

  getFavourites(BuildContext context, {int userId}) async {
    final response = await request(EndPoint.FAVOURITES,
        type: RequestType.Get,
        headers: Header.userAuth,
        context: context,
        queryParameters: {"userId": userId});

    Logger().e(response);

    if (response == null || response['error'] == "Favorate is empty") {
      return favo.FavouritesModel(lines: []);
    } else if (response['user'] != null) {
      return favo.FavouritesModel.fromJson(response);
    }
  }

  addToFavourites(BuildContext context, {Map<String, dynamic> body}) async {
    final response = await request(EndPoint.FAVOURITES,
        type: RequestType.Post,
        headers: Header.userAuth,
        body: body,
        context: context);
    print(response);
    return response != null &&
            response['type'] != null &&
            response['lines'] != null
        ? favo.FavouritesModel.fromJson(response)
        : null;
  }

  removeFromFavourite(BuildContext context,
      {Map<String, dynamic> queryParam}) async {
    final response = await request(EndPoint.FAVOURITES,
        type: RequestType.Delete,
        headers: Header.userAuth,
        context: context,
        queryParameters: queryParam);
    print(response);
    return response != null &&
            response['type'] != null &&
            response['lines'] != null
        ? favo.FavouritesModel.fromJson(response)
        : null;
  }

  updateUserInfo(BuildContext context,
      {Map<String, dynamic> body, int userId}) async {
    final response = await request(
        EndPoint.UPDATE_USER_INFO + userId.toString(),
        type: RequestType.Put,
        headers: Header.userAuth,
        context: context,
        body: body);

    return response != null && response['id'] != null
        ? UserInfo.fromJson(response)
        : null;
  }

  Future<MyOrdersModel> payment(BuildContext context,
      {Map<String, dynamic> body}) async {
    final response = await request(EndPoint.PAYMENT,
        context: context,
        type: RequestType.Post,
        headers: Header.userAuth,
        body: body);
    return response != null &&
            response['shipment'] != null &&
            response['invoice'] != null
        ? MyOrdersModel.fromJson(response)
        : null;
  }

  Future<List<MyOrdersModel>> getUserOrders(BuildContext context,
      {int userId}) async {
    final response = await request(EndPoint.USER_ORDERS + userId.toString(),
        type: RequestType.Get, headers: Header.userAuth, context: context);

    print(response);
    if (response.length == 0) {
      return [];
    }
    return response
        .map<MyOrdersModel>((item) => MyOrdersModel.fromJson(item))
        .toList();
  }

  Future<List<MyOrdersModel>> loadDeliveryOrders(BuildContext context) async {
    final response = await request(EndPoint.DELIVERY_ORDERS,
        type: RequestType.Get, headers: Header.userAuth, context: context);

    if (response != null) {
      print(response);
      return response
          .map<MyOrdersModel>((item) => MyOrdersModel.fromJson(item))
          .toList();
    } else {
      // } else if (response['lines']) {
      //   return [];
      // } else {
      return null;
    }
  }

  updateOrderStatus(BuildContext context, MyOrdersModel order) async {
    //await Future.delayed(Duration(milliseconds: 2000));
    final response = await request(
        EndPoint.UPDATE_DELIVERY_STATUS + order.id.toString(),
        type: RequestType.Put,
        headers: Header.userAuth,
        context: context);
    return response != null && response['status'] == 'closed' ? true : false;
  }

  sendResetEmail(context, String email) async {
    final response = await request(EndPoint.EMAIL_RESET + email,
        type: RequestType.Post, headers: Header.clientAuth, context: context);

    if (response['message'] != null &&
        response['message'] == "User Not Found") {
      return false;
    }
    return response != null && response['status'] == true ? true : false;
  }

  resetPassword(BuildContext context, {Map<String, dynamic> body}) async {
    final response = await request(EndPoint.PASSWORD_RESET + body['code'],
        type: RequestType.Post,
        headers: Header.clientAuth,
        context: context,
        body: {'email': body['email'], 'password': body['password']});

    return response != null && response['id'] != null
        ? UserInfo.fromJson(response)
        : null;
  }

  // sendFcmToken(BuildContext context, String fcm) async {
  //   final response = await request(EndPoint.FCMTOKEN,
  //       headers: Header.userAuth,
  //       type: RequestType.Put,
  //       context: context,
  //       body: {"fcmToken": fcm});

  //   // return response != null && response['id'] != null
  //   //     ? UserInfo.fromJson(response)
  //   //     : null;
  //   return response;
  // }

  getOtherBanners(BuildContext context) async {
    final response = await request(
      EndPoint.OTHER_BANNERS,
      headers: Header.userAuth,
      type: RequestType.Get,
      context: context,
    );

    return response != null
        ? response.map<Banners>((item) => Banners.fromJson(item)).toList()
        : null;
  }

  getAllBrands(BuildContext context, {Map<String, dynamic> param}) async {
    final response = await request(
      EndPoint.BRANDS,
      headers: Header.userAuth,
      type: RequestType.Get,
      queryParameters: param,
      context: context,
    );

    return response != null
        ? response.map<Brand>((item) => Brand.fromJson(item)).toList()
        : null;
  }

  postReview(context, {Map<String, dynamic> body}) async {
    final response = await request(EndPoint.REVIEW,
        headers: Header.userAuth,
        type: RequestType.Post,
        body: body,
        context: context);

    return response != null ? true : false;
  }

  getWelcomeScreens(BuildContext context) async {
    final res = await request(EndPoint.WELCOME_SCREENS,
        headers: Header.clientAuth, type: RequestType.Get, context: context);

    return res != null
        ? res
            .map<WelcomeScreen>((item) => WelcomeScreen.fromJson(item))
            .toList()
        : null;
  }

  getItemById(BuildContext context, {int itemId}) async {
    final response = await request(EndPoint.ITEMBYID + itemId.toString(),
        headers: Header.userAuth, type: RequestType.Get, context: context);

    return response != null ? CategoryItems.fromJson(response) : null;
  }

  Future<List<Wrapping>> getWrappings(BuildContext context) async {
    final response = await request(EndPoint.WRAPPING,
        headers: Header.userAuth, type: RequestType.Get, context: context);

    return response != null
        ? response.map<Wrapping>((wrap) => Wrapping.fromJson(wrap)).toList()
        : [];
  }

  Future<Cart> addWrapping(BuildContext context,
      {Map<String, dynamic> body}) async {
    final response = await request(EndPoint.ADDWRAPPINGGIFT,
        type: RequestType.Post,
        headers: Header.userAuth,
        body: body,
        context: context);
    print(response);
    return response != null ? Cart.fromJson(response) : null;
  }

  Future<Cart> removeWrapping(BuildContext context) async {
    final response = await request(EndPoint.REMOVEWRAPPING,
        type: RequestType.Delete, headers: Header.userAuth, context: context);
    print(response);
    return response != null ? Cart.fromJson(response) : null;
  }

  Future<NewSearchModel> getNewSearchData(
      BuildContext context, String searchWord, Function onSendProgress) async {
    final res = await request(
      EndPoint.NEW_SEARCH,
      type: RequestType.Get,
      headers: Header.userAuth,
      context: context,
      onSendProgress: onSendProgress,
      queryParameters: {'word': searchWord},
    );

    return res != null ? NewSearchModel.fromJson(res) : null;
  }

  @override
  recordFcm(BuildContext context, {String fcm}) async {
    // final response = await request('User/recordFcm',
    //     headers: Header.clientAuth,
    //     type: RequestType.Put,
    //     context: context,
    //     body: {"fcmToken": fcm});

    // // return response != null && response['id'] != null
    // //     ? UserInfo.fromJson(response)
    // //     : null;
    // return response;
  }

  Future<List<HomeList>> getHomeLists(BuildContext context) async {
    final response = await request(EndPoint.HOMELIST,
        headers: Header.userAuth,
        type: RequestType.Get,
        context: context, onSendProgress: () {
      print('send');
    });

    return response != null
        ? response.map<HomeList>((wrap) => HomeList.fromJson(wrap)).toList()
        : [];
  }
}
