// import 'package:beautydoz/core/models/currency_model.dart';
// import 'package:beautydoz/core/services/api/http_api.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';

// class LocationService {
//   static String isoCode;
//   static Future<bool> getLocation() async {
//     final bool permission = await requestLocation();
//     if (permission) {
//       Position position = await Geolocator.getCurrentPosition();
//       await placemarkFromCoordinates(position.latitude, position.longitude).then((value) {
//         isoCode = value.first.isoCountryCode;
//       });
//       print("iso code is : $isoCode");
//       return true;
//     }
//     return false;
//   }

//   static Future<bool> checkPermission() async {
//     final LocationPermission permission = await Geolocator.checkPermission();
//     bool isActive = false;
//     switch (permission) {
//       case LocationPermission.denied:
//         {
//           isActive = false;
//         }

//         break;
//       case LocationPermission.deniedForever:
//         {
//           isActive = false;
//         }
//         break;
//       case LocationPermission.whileInUse:
//         {
//           isActive = true;
//         }
//         break;
//       case LocationPermission.always:
//         {
//           isActive = true;
//         }
//         break;
//     }
//     return isActive;
//   }

//   static Future<bool> requestLocation() async {
//     final bool permission = await checkPermission();
//     if (permission) {
//       return true;
//     }
//     final LocationPermission reqPermission = await Geolocator.requestPermission();
//     if (reqPermission == LocationPermission.denied ||
//         reqPermission == LocationPermission.deniedForever) {
//       await Geolocator.openAppSettings();

//       return false;
//     }
//     return true;
//   }
// }

// import 'package:beautydoz/core/models/currency_model.dart';

// class CurrencyLocationServices {
//   static CurrencyModel currencyModel = CurrencyModel();
//  static final HttpApi api = HttpApi();
//    static changeCurrencyBasedOnCountry() async {
//     currencyModel = await api.getCurrencyData(
//         isoCode: LocationService.isoCode?.toUpperCase() ?? "KW");
//   }
// }
