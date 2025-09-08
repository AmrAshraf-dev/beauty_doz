import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/services/localization/localization.dart';

class Permessions {
  //get cam per shows dialog if rejected!!
  static Future<bool> getCamPerm(BuildContext context) async {
    final permession = await Permission.camera.request();

    if (!permession.isGranted) {
      final locale = AppLocalizations.of(context);

      final action = await UI.dialog(
            context: context,
            accept: true,
            title: locale.get("permission denied"),
            msg: locale.get("camera denied"),
            cancelMsg: locale.get('cancel'),
            acceptMsg: locale.get('try again'),
          ) ??
          false;

      if (action) return await getCamPerm(context) ?? false;
    }
    return permession.isGranted;
  }

  static Future<bool> getStoragePerm(BuildContext context) async {
    final granted1 = (await Permission.storage.request()).isGranted;
    bool granted2;

    if (Platform.isIOS) {
      granted2 = (await Permission.mediaLibrary.request()).isGranted;
    } else {
      granted2 = granted1;
    }

    if (!granted1 || !granted2) {
      final locale = AppLocalizations.of(context);

      final action = await UI.dialog(
            context: context,
            title: locale.get("permission denied"),
            accept: true,
            cancelMsg: locale.get('cancel'),
            acceptMsg: locale.get('try again'),
          ) ??
          false;

      if (action) return await getStoragePerm(context) ?? false;
    }
    return granted1 && granted2;
  }

  static Future<bool> getLocationPerm(BuildContext context) async {
    final permession = await Permission.location.request();

    if (!permession.isGranted) {
      final locale = AppLocalizations.of(context);

      final action = await UI.dialog(
            context: context,
            accept: true,
            title: locale.get("permission denied"),
            msg: locale.get("permission denied"),
            cancelMsg: locale.get('cancel'),
            acceptMsg: locale.get('try again'),
          ) ??
          false;

      if (action) return await getLocationPerm(context) ?? false;
    }
    return permession.isGranted;
  }
}
