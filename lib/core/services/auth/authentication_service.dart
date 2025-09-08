import 'dart:convert';
import 'dart:math';

import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/init/init_services.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/models/user.dart' as OUser;
import '../preference/preference.dart';

class AuthenticationService {
  final HttpApi api;
  final _firebaseAuth = FirebaseAuth.instance;

  OUser.User _user;
  OUser.User get user => _user;

  AuthenticationService({this.api}) {
    loadUser;
  }

  Future<bool> getUserToken(BuildContext context, String mac) async {
    try {
      var token = await api.getUserToken(context, mac);
      if (token != null) {
        await Preference.setString(PrefKeys.token, token);
      }
      return true;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  /*
   * authenticate user by his phone number and password
   */
  Future<bool> login({Map<String, dynamic> body}) async {
    try {
      _user = await api.signIn(body: body);

      if (_user != null) {
        Logger().i(_user.toJson());
        saveUser(user: _user);

        return true;
      }
    } catch (e) {
      Logger().e(e);
      return false;
    }
    return false;
  }

  Future<bool> socialLogin({Map<String, dynamic> body}) async {
    try {
      _user = await api.signIn(body: body);

      if (_user != null) {
        Logger().i(_user.toJson());
        saveUser(user: _user);

        return true;
      }
    } catch (e) {
      Logger().e(e);
      return false;
    }
    return false;
  }

  /* 
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
    } */

  Future<bool> signUp(Map<String, dynamic> param) async {
    OUser.User user;
    try {
      user = await api.signUp(param: param);
      if (user != null) {
        final token = user.token;
        await Preference.setString(PrefKeys.token, token);
        _user = user;
        Logger().i(_user.toJson());
        saveUser(user: _user);
      }
      return user != null ? true : false;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  /*
   *check if user is authenticated 
   */
  bool get userLoged => Preference.getBool(PrefKeys.userLogged) ?? false;

  /*
   *save user in shared prefrences 
   */
  saveUser({OUser.User user}) {
    Preference.setBool(PrefKeys.userLogged, true);
    Preference.setString(PrefKeys.userData, json.encode(user.toJson()));
    _user = user;
  }

  /*
   * load the user info from shared prefrence if existed to be used in the service   
   */
  Future<void> get loadUser async {
    if (userLoged) {
      _user = OUser.User.fromJson(
          json.decode(Preference.getString(PrefKeys.userData)));
      Logger().i(_user.toJson());
      print('\n\n\n\n');
    }
  }

  /*
   * refresh the user access token and update it in shared prefrence   
   */
  // Future<bool> get refreshToken async => await api.refreshToken();

  /*
   * signout the user from the app and return to the login screen   
   */
  Future<void> get signOut async {
    await Preference.remove(PrefKeys.userData);
    await Preference.remove(PrefKeys.userLogged);
    _user = null;
  }

  static handleAuthExpired({@required BuildContext context}) async {
    if (context != null) {
      try {
        await Preference.clear();

        if (!Provider.of<AuthenticationService>(context, listen: false)
            .userLoged) {
          try {
            await Provider.of<AuthenticationService>(context, listen: false)
                .getUserToken(context, "MAC");

            Provider.of<CartService>(context, listen: false)?.cart = null;

            Provider.of<FavouriteService>(context, listen: false)?.favourites =
                null;

            // Provider.of<CategoryService>(context, listen: false)
            //     .getCategories(context);

            Provider.of<CartService>(context, listen: false)
                .setState(state: NotifierState.idle, notifyListener: false);
          } catch (e) {
            Logger().e('error in  method $e');
          }
        } else {
          try {
            Provider.of<InitService>(context, listen: false)
                .initServices(context);
          } catch (e) {
            Logger().e('error in  method $e');
          }
        }

        UI.pushReplaceAll(context, Routes.home);

        Logger().v('🦄session destroyed🦄');
      } catch (e) {
        Logger().v('🦄error while destroying session $e🦄');
      }
    }
  }

  Future<bool> changePassowrd(BuildContext context,
      {Map<String, dynamic> param}) async {
    OUser.User user;
    try {
      user = await api.changePassword(context, param: param);
    } catch (e) {}

    if (user != null) {
      _user = user;
      saveUser(user: user);
      Logger().i(_user.toJson());
      return true;
    } else {
      return false;
    }
  }

  updateUserInfo(BuildContext context, {Map<String, dynamic> body}) async {
    try {
      final OUser.UserInfo userInfo =
          await api.updateUserInfo(context, body: body, userId: _user.user.id);
      if (userInfo != null) {
        _user.user = userInfo;
        Logger().i(_user.toJson());
        saveUser(user: _user);
      }
      return user != null ? true : false;
    } catch (e) {
      Logger().e(e);
      return false;
    }
  }

  logout() {}

  sendResetEmail(context, {String email}) async {
    var res = await api.sendResetEmail(context, email);
    if (res == true) {
      return true;
    } else {
      return false;
    }
  }

  resetPassword(BuildContext context, {Map<String, dynamic> body}) async {
    OUser.UserInfo res = await api.resetPassword(context, body: body);
    if (res != null) {
      return true;
    } else {
      return false;
    }
  }

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<UserCredential> signInWithApple() async {
    // To prevent replay attacks with the credential returned from Apple, we
    // include a nonce in the credential request. When signing in with
    // Firebase, the nonce in the id token returned by Apple, is expected to
    // match the sha256 hash of `rawNonce`.
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);

    // Request credential for the currently signed in Apple account.
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    // Create an `OAuthCredential` from the credential returned by Apple.
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
    );

    // Sign in the user with Firebase. If the nonce we generated earlier does
    // not match the nonce in `appleCredential.identityToken`, sign in will fail.
    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      UI.toast('Sign In Faild');
    }
  }
}
