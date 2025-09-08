// provider_setup.dart

import 'package:beautydoz/core/page_models/main_pages_models/home_page/home_page_model.dart';
import 'package:beautydoz/core/page_models/theme_provider.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/app_language_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/cart/cart_service.dart';
import 'package:beautydoz/core/services/category/category_service.dart';
import 'package:beautydoz/core/services/currency/currency.service.dart';
import 'package:beautydoz/core/services/drawer.service.dart';
import 'package:beautydoz/core/services/favourites/favourites_service.dart';
import 'package:beautydoz/core/services/homePageService/home_page_service.dart';
import 'package:beautydoz/core/services/init/init_services.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../core/services/api/http_api.dart';
import '../../core/services/auth/authentication_service.dart';
import '../../core/services/notification/notification_service.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => HttpApi());
  locator.registerLazySingleton(() => NotificationServices());
  locator.registerLazySingleton(() => AppLanguageModel());
  locator.registerLazySingleton(() => AuthenticationService());
  locator.registerLazySingleton(() => CartService());
  locator.registerLazySingleton(() => CategoryService());
  locator.registerLazySingleton(() => CurrencyService());
  locator.registerLazySingleton(() => DrawerService());
  locator.registerLazySingleton(() => ThemeProvider());
}

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
  // ...uiConsumableProviders,
];

List<SingleChildWidget> independentServices = [
  Provider<Api>(create: (c) => HttpApi()),
  Provider<InitService>(
    create: (context) => InitService(context: context),
  )
];

List<SingleChildWidget> dependentServices = [
  ChangeNotifierProxyProvider<Api, CategoryService>(
    create: (c) => CategoryService(
        api: Provider.of<Api>(c, listen: false), state: NotifierState.busy),
    update: (context, api, cs) => CategoryService(
        api: Provider.of<Api>(context, listen: false),
        state: NotifierState.busy),
  ),
  ChangeNotifierProxyProvider<Api, HomePageService>(
    create: (c) => HomePageService(
        api: Provider.of<Api>(c, listen: false), state: NotifierState.busy),
    update: (context, api, cs) => HomePageService(
        api: Provider.of<Api>(context, listen: false),
        state: NotifierState.busy),
  ),
  ChangeNotifierProxyProvider<Api, CartService>(
    create: (c) => CartService(state: NotifierState.busy),
    update: (context, api, cs) => CartService(state: NotifierState.busy),
  ),
  ChangeNotifierProxyProvider<Api, FavouriteService>(
    create: (c) => FavouriteService(
        api: Provider.of<Api>(c, listen: false), state: NotifierState.busy),
    update: (context, api, cs) => FavouriteService(
        api: Provider.of<Api>(context, listen: false),
        state: NotifierState.busy),
  ),
  ProxyProvider<Api, AuthenticationService>(
      update: (context, api, authenticationService) =>
          AuthenticationService(api: api)),
  ProxyProvider<AuthenticationService, NotificationServices>(
      update: (context, auth, authenticationService) => NotificationServices()),
];

List<SingleChildWidget> uiConsumableProviders = [
  // StreamProvider<User>(create: (context) => Provider.of<AuthenticationService>(context, listen: false).user),
];
