import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';

class PaymentCardPageModel extends BaseNotifier {
  final AuthenticationService auth;
  PaymentCardPageModel({this.auth});
}
