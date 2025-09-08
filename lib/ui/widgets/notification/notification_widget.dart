import 'dart:convert';

import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/styles.dart';
import 'package:beautydoz/ui/widgets/buttons/normal_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:ui_utils/ui_utils.dart';

class Notify extends StatelessWidget {
  final String title;
  final String body;
  final int itemId;
  final String image;

  Notify({Key key, this.title, this.body, this.image, this.itemId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final grad = Gradients.secandaryGradient;
    final textColor = Color(0xff5C6470);

    return itemId != null && image != null
        ? StatefulBuilder(
            builder: (context, innerSetState) => GestureDetector(
              onTap: () {
                if (itemId != null) {
                  UI.push(
                      context,
                      Routes.item(
                          cartItem: null, item: CategoryItems(id: itemId)));
                  OverlaySupportEntry.of(context).dismiss();
                }
              },
              onHorizontalDragEnd: (_) =>
                  OverlaySupportEntry.of(context).dismiss(),
              onVerticalDragEnd: (_) {
                if (itemId != null) {
                  UI.push(
                      context,
                      Routes.item(
                          cartItem: null, item: CategoryItems(id: itemId)));
                  OverlaySupportEntry.of(context).dismiss();
                }
              },
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * .13,
                  ),
                  AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0))),
                    elevation: 1000.5,
                    contentPadding: EdgeInsets.zero,
                    content: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: image,
                          imageBuilder: (context, imageProvider) => Container(
                            height: MediaQuery.of(context).size.height * .7,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.scaleDown),
                            ),
                          ),
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            color: AppColors.accentText,
                          ),
                          errorWidget: (context, url, error) =>
                              SvgPicture.asset(
                            "assets/images/beautyLogo.svg",
                            width: ScreenUtil.screenWidthDp,
                            // height: ScreenUtil.screenHeightDp,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * .7,
                          width: MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  AppColors.accentText.withOpacity(0.1),
                                  AppColors.accentText.withOpacity(0.4),
                                ],
                                stops: [
                                  0.0,
                                  1.0
                                ]),
                          ),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 80,
                          left: 80,
                          child: NormalButton(
                            gradient: LinearGradient(
                                begin: FractionalOffset.topCenter,
                                end: FractionalOffset.bottomCenter,
                                colors: [
                                  AppColors.accentText.withOpacity(0.5),
                                  AppColors.accentText
                                ],
                                stops: [
                                  0.0,
                                  1.0
                                ]),
                            text: title == " " ? "GO" : title,
                            onPressed: () async {
                              if (itemId != null) {
                                UI.push(
                                    context,
                                    Routes.item(
                                        cartItem: null,
                                        item: CategoryItems(id: itemId)));
                                OverlaySupportEntry.of(context).dismiss();
                              }
                            },
                          ),
                        ),
                        Positioned(
                            bottom: MediaQuery.of(context).size.height * .10,
                            child: Center(
                              widthFactor: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  body,
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )),
                        Positioned(
                            top: 20,
                            right: 20,
                            child: IconButton(
                                color: Colors.black,
                                icon: Icon(Icons.close),
                                onPressed: () =>
                                    OverlaySupportEntry.of(context).dismiss()))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : SafeArea(
            child: GestureDetector(
              onTap: () {
                if (itemId != null) {
                  UI.push(
                      context,
                      Routes.item(
                          cartItem: null, item: CategoryItems(id: itemId)));
                }
              },
              onHorizontalDragEnd: (_) =>
                  OverlaySupportEntry.of(context).dismiss(),
              onVerticalDragEnd: (_) {
                if (itemId != null) {
                  UI.push(
                      context,
                      Routes.item(
                          cartItem: null, item: CategoryItems(id: itemId)));
                }
              },
              child: Card(
                margin: EdgeInsets.all(7),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: grad,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: ListTile(
                    leading: SizedBox(
                        width: 35,
                        height: 35,
                        child: image != null
                            ? Image.network(image)
                            : Image.asset('assets/images/logowide.png')),
                    title: Text(title ?? '',
                        style: TextStyle(fontSize: 15, color: textColor)),
                    subtitle: Text(body ?? '',
                        style: TextStyle(fontSize: 10, color: textColor)),
                    trailing: IconButton(
                        color: textColor,
                        icon: Icon(Icons.close),
                        onPressed: () =>
                            OverlaySupportEntry.of(context).dismiss()),
                  ),
                ),
              ),
            ),
          );
  }
}
