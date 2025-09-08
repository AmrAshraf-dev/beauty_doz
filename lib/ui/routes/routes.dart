import 'package:beautydoz/core/models/address.dart';
import 'package:beautydoz/core/models/carts.dart';
import 'package:beautydoz/core/models/categories.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/models/home_page_items.dart';
import 'package:beautydoz/core/models/myorders.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/home_page.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/taps/all_items_page.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/taps/cart_page.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/taps/new_cart_page.dart';
import 'package:beautydoz/ui/pages/main_pages/on_borading.dart';
import 'package:beautydoz/ui/pages/secondary_pages/favorites_page.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/taps/profile_page.dart';
import 'package:beautydoz/ui/pages/main_pages/home_page/taps/shop_page.dart';
import 'package:beautydoz/ui/pages/main_pages/notification_page.dart';
import 'package:beautydoz/ui/pages/main_pages/reset_form_page.dart';
import 'package:beautydoz/ui/pages/main_pages/reset_password_page.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_in_page.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_in_up_page.dart';
import 'package:beautydoz/ui/pages/main_pages/sign_up_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/about_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/addresses_dialog_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/addresses_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/banner_items_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/brand_items_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/category_item_screen.dart';
import 'package:beautydoz/ui/pages/secondary_pages/contact_us.dart';
import 'package:beautydoz/ui/pages/secondary_pages/home_page_see_more.dart';
import 'package:beautydoz/ui/pages/secondary_pages/item_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/languages_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/my_orders_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/my_profile_screen.dart';
import 'package:beautydoz/ui/pages/secondary_pages/new_search_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/order_info_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/payement_card_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/payment_method_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/payment_webView_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/rate_us_page.dart';
import 'package:beautydoz/ui/pages/secondary_pages/search_page.dart';
import 'package:flutter/material.dart';

import '../../ui/pages/main_pages/splash_screen.dart';
import '../pages/main_pages/home_page/taps/brands_page.dart';

class Routes {
  static Widget get splash => SplashScreen();
  static Widget get signUp => SignUpPage();
  static Widget get signIn => SignInPage();
  static Widget get signInUp => SignInUp();
  static Widget get home => HomePage();
  static Widget get onBorading => OnBoradingScreens();

  //
  static Widget get shop => ShopPage();
  static Widget get favorites => FavoritesPage();
  // static Widget cart(/* {CategoryItems item, int qty} */) => CartPage(
  //     /*  item: item,
  //       qty: qty, */
  //     );

  static Widget cart(/* {CategoryItems item, int qty} */) => NewCartPage(
      /*  item: item,
        qty: qty, */
      );

  static Widget get profile => ProfilePage();
  static Widget item({CategoryItems item, Lines cartItem}) => ItemPage(
        itemId: item.id,
        cartItem: cartItem,
      );
  static Widget categoryItem(Categories category) => CategoryItemPage(
        category: category,
      );
  static Widget homePageSeeMore({List<CategoryItems> items}) => SeeMorePage(
        items: items,
      );
  static Widget brandItems({Brand brand}) => BrandItemsPage(brand: brand);
  static Widget get myOrders => MyOrderPage();
  static Widget orderInfo({MyOrdersModel order}) => OrderInfoPage(order: order);
  static Widget banner(Banners banner) => BannerItemsPage(banner: banner);
  static Widget paymentWebView({Map<String, dynamic> body}) =>
      PaymentWebViewPage(body: body);
  static Widget allItems({bool isBottomNavIndex}) =>
      AllItemsPage(isBottomNavIndex: isBottomNavIndex);
  static Widget notificatioPage() => NotificationScreen();

  //
  static Widget get addresses => AdressesPage();
  static Widget get myProfile => MyProfilePage();
  static Widget get languages => LanguagesPage();
  static Widget get about => AboutPage();
  static Widget get contact => ContactUsPage();
  static Widget get rateUs => RateUsPage();
  static Widget get checkoutAdresses => AddressesDialogPage();
  static Widget paymentMethod({Address address, Cart cart}) =>
      PaymentMethodPage(address: address, cart: cart);
  static Widget get paymentCard => PaymentCardPage();
  static Widget get search => SearchPage();
  static Widget get resetPasswordPage => ResetPasswordPage();

  static Widget resetForm({String email}) => ResetFormPage(
        email: email,
      );

  static Widget brandsPage({bool isBottomNavIndex}) =>
      BrandsPage(isBottomNavIndex: isBottomNavIndex);
  static Widget get newSearch => NewSearchPage();
  // static Widget notificatioPage() => NotificationScreen();
}
