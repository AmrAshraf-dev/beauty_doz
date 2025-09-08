import 'package:beautydoz/ui/pages/secondary_pages/item_page.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'core/page_models/app_language_model.dart';
import 'core/page_models/secondary_pages/new_search_model_management.dart';
import 'core/page_models/theme_provider.dart';
import 'core/services/localization/localization.dart';
import 'core/services/navigationService.dart';
import 'core/services/preference/preference.dart';
import 'core/utils/provider_setup.dart';

void main() async {
  setupLocator();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Preference.init();
  runApp(
    MyApp(),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppLanguageModel>(
        create: (_) => AppLanguageModel(),
        child: Consumer<AppLanguageModel>(builder: (context, model, child) {
          return ChangeNotifierProvider<ThemeProvider>(
              create: (_) => ThemeProvider(),
              child: Consumer<ThemeProvider>(builder: (context, theme, child) {
                return OverlaySupport(
                  child: MultiProvider(
                    providers: providers,
                    child: FeatureDiscovery(
                      recordStepsInSharedPreferences: false,
                      child: StreamBuilder<bool>(
                          stream: locator<ThemeProvider>().isDark.stream,
                          builder: (context, snapshot) {
                            print(snapshot);
                            return MaterialApp(
                              // navigatorKey: navigatorKey,
                              navigatorKey: NavigationService.navigationKey,

                              onGenerateRoute: (RouteSettings settings) {
                                final Map arguments = settings.arguments as Map;
                                if (arguments != null)
                                  print(arguments['itemId']);

                                switch (settings.name) {
                                  case '/item':
                                    return MaterialPageRoute(
                                        builder: (_) => ItemPage(
                                            itemId: int.parse(
                                                arguments['itemId'])));

                                  default:
                                    return null;
                                }
                              },
                              home: Routes.splash,
                              debugShowCheckedModeBanner: false,
                              theme: snapshot.data != null && snapshot.data
                                  ? theme.dark
                                  : theme.light,
                              themeMode: snapshot.data != null && snapshot.data
                                  ? ThemeMode.dark
                                  : ThemeMode.light,
                              locale: model.appLocal,
                              supportedLocales: [
                                const Locale('en'),
                                const Locale('ar')
                              ],
                              localizationsDelegates: [
                                AppLocalizations.delegate,
                                GlobalMaterialLocalizations.delegate,
                                GlobalWidgetsLocalizations.delegate,
                                GlobalCupertinoLocalizations.delegate,
                              ],
                            );
                          }),
                    ),
                  ),
                );
              }));
        }));
  }
}
