import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/ui/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/preference/preference.dart';
import 'package:rxdart/rxdart.dart';

class ThemeProvider with ChangeNotifier {
  final isDark = BehaviorSubject<bool>(sync: true);

  ThemeProvider() {
    isDark.add(Preference.getBool(PrefKeys.isDark) ?? false);
  }
  ThemeData dark = ThemeData(
    primaryColor: Colors.black,
    textTheme: TextTheme(
      headline1: GoogleFonts.tajawalTextTheme()
          .headline1
          .copyWith(color: Colors.white),
      headline2: GoogleFonts.tajawalTextTheme()
          .headline2
          .copyWith(color: Colors.white),
      headline3: GoogleFonts.tajawalTextTheme()
          .headline3
          .copyWith(color: Colors.white),
      headline4: GoogleFonts.tajawalTextTheme()
          .headline4
          .copyWith(color: Colors.white),
      headline5: GoogleFonts.tajawalTextTheme()
          .headline5
          .copyWith(color: Colors.white),
      headline6: GoogleFonts.tajawalTextTheme()
          .headline6
          .copyWith(color: Colors.white),
      bodyText1: GoogleFonts.tajawalTextTheme()
          .bodyText1
          .copyWith(color: Colors.white),
      bodyText2: GoogleFonts.tajawalTextTheme()
          .bodyText2
          .copyWith(color: Colors.white),
      caption: GoogleFonts.tajawalTextTheme()
          .caption
          .copyWith(color: Colors.white70),
      subtitle1: GoogleFonts.tajawalTextTheme()
          .subtitle1
          .copyWith(color: Colors.white),
      subtitle2: GoogleFonts.tajawalTextTheme()
          .subtitle2
          .copyWith(color: Colors.white),
    ),
    // textTheme: TextTheme().apply(bodyColor: Colors.white),
    iconTheme: IconThemeData(color: Colors.grey),
    buttonTheme: ButtonThemeData(buttonColor: AppColors.secondaryElement),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.secondaryBackground),
    bottomAppBarColor: AppColors.secondaryBackground,
    // scaffoldBackgroundColor: AppColors.secondaryBackground,
    backgroundColor: AppColors.secondaryBackground,
    colorScheme: ColorScheme(
        onPrimary: Colors.black,
        primaryVariant: Colors.orange,
        background: Colors.red,
        onBackground: Colors.black54.withOpacity(0.7),
        onSecondary: Colors.white,
        secondaryVariant: Colors.deepOrange,
        error: Colors.black,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        brightness: Brightness.dark,
        primary: AppColors.primaryText,
        secondary: AppColors.accentText),
    inputDecorationTheme: InputDecorationTheme(
      focusColor: Colors.black87.withOpacity(0.7),
    ),

    appBarTheme: AppBarTheme(
        backgroundColor: AppColors.secondaryBackground.withOpacity(0.9)),
    accentColor: AppColors.secondaryElement,
  );

  ThemeData light = ThemeData(
    primaryColor: AppColors.primaryElement,
    textTheme: GoogleFonts.tajawalTextTheme(),
    appBarTheme: AppBarTheme(backgroundColor: AppColors.accentBackground),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.accentBackground),
    bottomAppBarColor: Colors.white,
    backgroundColor: AppColors.accentBackground,
    iconTheme: IconThemeData(color: Colors.black),
    buttonTheme: ButtonThemeData(buttonColor: AppColors.ternaryBackground),
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme(
        onPrimary: Colors.black,
        primaryVariant: AppColors.accentText,
        background: Colors.red,
        onBackground: Colors.white,
        onSecondary: Colors.blueGrey,
        secondaryVariant: Colors.deepOrange,
        error: Colors.black,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: Colors.black,
        brightness: Brightness.light,
        primary: AppColors.primaryElement,
        secondary: AppColors.accentText),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: TextStyle(
        fontFamily: "TeXGyreAdventor-Regular",
        fontSize: 11.181839942932129,
        color: Color(0xff939598),
      ),
      hintStyle: TextStyle(
        fontFamily: "NeusaNextW00-Regular",
        fontSize: 10.358949661254883,
        color: Color(0xff758091),
      ),
    ),
  );

  switchTheme(bool isDarkModeEnabled) {
    isDark.add(isDarkModeEnabled);
    Preference.setBool(PrefKeys.isDark, isDarkModeEnabled);
    notifyListeners();
  }
}
