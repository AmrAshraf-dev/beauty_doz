import 'dart:io';

import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:flutter/material.dart';

import '../../../core/page_models/app_language_model.dart';
import '../../../core/services/api/http_api.dart';
import '../../../core/services/auth/authentication_service.dart';

class ProfileScreenModel extends BaseNotifier {
  // Text Controller for fields
  TextEditingController phoneTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController rePasswordTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();

  AuthenticationService auth;
  HttpApi api;
  AppLanguageModel languageModel;

  File choosedImage;
  int radioValue = 1;

  ProfileScreenModel({this.languageModel, this.auth, this.api}) {
    //phoneTextController.text = auth.user.phoneNumber ?? '';
    //emailTextController.text = auth.user.email ?? '';
  }
}
