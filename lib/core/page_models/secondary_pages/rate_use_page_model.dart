import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';

class RateUsPageModel extends BaseNotifier {
  final AuthenticationService auth;
  RateUsPageModel({this.auth});
}
