import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/init/init_services.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:beautydoz/core/utils/validator.dart';
import 'package:beautydoz/ui/pages/main_pages/delivery_boy_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ui_utils/ui_utils.dart';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

class SignInPageModel extends BaseNotifier with Validator {
  final AuthenticationService auth;
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final AppLocalizations locale;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  SignInPageModel({this.auth, this.locale});

  signIn(BuildContext context, {formValid = false}) async {
    if (!formValid) {
      // this is exist for calling method after sign in with google and the current state will be null
      formValid = formKey.currentState.validate();
    }

    if (formValid) {
      setBusy();
      try {
        bool res = await auth.login(body: {
          "email": emailController.text,
          "password": passwordController.text
        });
        if (res) {
          if (auth.user.user.userType == 'delivery') {
            UI.pushReplaceAll(context, DeliveryBoyPage());
          } else {
            Provider.of<InitService>(context, listen: false)
                .initServices(context);
            UI.pushReplaceAll(context, Routes.home);
          }
        } else {
          UI.toast(locale.get('incorrect username or password') ??
              'incorrect username or password');
        }
      } catch (e) {
        UI.toast(locale.get('incorrect username or password') ??
            'incorrect username or password');
      }
      if (_auth != null && _auth.currentUser != null) {
        await _auth.signOut();
      }
      setIdle();
    }
  }

  void resetPasswordPage(BuildContext context) {
    UI.push(context, Routes.resetPasswordPage);
  }

  signInWithGoogle(BuildContext context) async {
    // Once signed in, return the UserCredential
    final UserCredential authResult =
        await locator<AuthenticationService>().signInWithGoogle();
    if (authResult != null) authenticateUser(context, authResult, "google");
  }

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

    if (user != null) {
      authenticateUser(context, user, "apple");
    } else {
      UI.toast(locale.get("Error") ?? "Error");
      setError();
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

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  /// Returns the sha256 hash of [input] in hex notation.
  // Future<UserCredential> signInWithApple() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //   var clientID = "com.overrideeg.apps.beautydoz";
  //   var redirectURL = "server.overrideeg.net:3002/v1/";
  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //       scopes: [
  //         AppleIDAuthorizationScopes.email,
  //         AppleIDAuthorizationScopes.fullName,
  //       ],
  //       nonce: nonce,
  //       webAuthenticationOptions: WebAuthenticationOptions(
  //           clientId: clientID, redirectUri: Uri.parse(redirectURL)));

  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );

  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();

    print("User Signed Out");
  }

  void authenticateUser(
      BuildContext context, UserCredential user, String provider) async {
    setBusy();

    if (await auth.login(body: {
      "email": user.user.email ?? user.additionalUserInfo.profile['email'],
      provider: user.user.uid
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
    setBusy();

    // Trigger the sign-in flow
    try {
      final AccessToken loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.token);
      UserCredential cred = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);

      authenticateUser(context, cred, "facebook");
    } catch (e) {
      toast('Error White Login');
    }
  }

  // UI.toast(locale.get("Coming Soon") ?? "Coming Soon");

  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.

  /// Returns the sha256 hash of [input] in hex notation.

}
