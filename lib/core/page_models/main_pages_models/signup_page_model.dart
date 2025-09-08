import 'dart:convert';
import 'dart:math';
import 'package:beautydoz/core/models/countries.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/init/init_services.dart';
import 'package:beautydoz/core/utils/validator.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ui_utils/ui_utils.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/api/http_api.dart';

import '../../services/localization/localization.dart';

class SignUpPageModel extends BaseNotifier with Validator {
  final AuthenticationService auth;
  final BuildContext context;
  final formKey = GlobalKey<FormState>();

  final userName = TextEditingController();
  final extinsion = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final address = TextEditingController();

  int selectedExtension;

  List<Countries> countries;

  bool fetchingCountries = false;

  SignUpPageModel({@required this.auth, @required this.context}) {
    if (countries == null) {
      fetchCountries();
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void fetchCountries() async {
    final HttpApi api = Provider.of<Api>(context, listen: false);
    fetchingCountries = true;
    setState();
    countries = await api.getCountries(context);
    fetchingCountries = false;
    setState();
  }

  onPressSignup(BuildContext context, AppLocalizations local) async {
    final formValid = formKey.currentState.validate();
    if (formValid) {
      setBusy();
      Map<String, dynamic> param = {
        'name': userName.text,
        'email': email.text,
        'password': password.text,
        'mobile': {'extintion': extinsion.text, 'number': phone.text},
        'userType': 'user',
        'isActive': true
      };
      print(param);
      if (await auth.signUp(param)) {
        Provider.of<InitService>(context, listen: false).initServices(context);
        UI.pushReplaceAll(context, Routes.home);
      } else {
        UI.toast(local.get("Error") ?? "Error");
        setIdle();
      }
    }
  }

  signInWithGoogle(BuildContext context) async {
    final locale = AppLocalizations.of(context);
    setBusy();
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      setError();
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    final UserCredential authResult =
        await _auth.signInWithCredential(credential);
    final User user = authResult.user;
    if (user != null) {
      // Register to backend
      authenticateUser(context, user, "google");
    } else {
      UI.toast(locale.get("Error") ?? "Error");
      setError();
    }
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  void authenticateUser(
      BuildContext context, User user, String provider) async {
    setBusy();

    if (await auth.login(body: {
      "email": user.providerData[0].email,
      provider: user.providerData[0].uid
    })) {
      setIdle();
      Provider.of<InitService>(context, listen: false).initServices(context);
      UI.pushReplaceAll(context, Routes.home);
    } else {
      setError();
    }
    setError();
  }

  void signInWithFacbook(BuildContext context) async {
    final locale = AppLocalizations.of(context);
    setBusy();

    // Trigger the sign-in flow
    final AccessToken loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.token);
    UserCredential cred = await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);

    final User user = cred.user;
    if (user != null) {
      // Register to backend
      authenticateUser(context, user, "facebook");
    } else {
      UI.toast(locale.get("Error") ?? "Error");
      setError();
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

  signInWithApple(BuildContext context) async {
    setBusy();
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
    UserCredential user =
        await FirebaseAuth.instance.signInWithCredential(oauthCredential);

    try {
      if (await auth
          .login(body: {"email": user.user.email, "apple": user.user.uid})) {
        setIdle();
        Provider.of<InitService>(context, listen: false).initServices(context);
        UI.pushReplaceAll(context, Routes.home);
      } else {
        setError();
      }
    } catch (e) {
      // TODO: Show alert here
      UI.toast("Error");

      print(e);
    }

    setIdle();

    // Once signed in, return the UserCredential
    // final UserCredential authResult =
    //     await _auth.signInWithCredential(credential);
    // final User user = authResult.user;
    // if (user != null) {
    // Register to backend
    // authenticateUser(context, user, "apple");
    // }
    // else {
    //   UI.toast(locale.get("Error") ?? "Error");
    //   setError();
    // }
  }

  // UI.toast(locale.get("Coming Soon") ?? "Coming Soon");
  // }
}
