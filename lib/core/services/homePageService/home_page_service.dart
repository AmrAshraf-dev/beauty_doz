import 'package:beautydoz/core/models/currency_model.dart';
import 'package:beautydoz/core/models/home-list.model.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/home_page_items.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/location/locationService.dart';
import 'package:flutter/material.dart';

class HomePageService extends BaseNotifier {
  final HttpApi api;

  HomePageService({NotifierState state, this.api}) : super(state: state);
}
