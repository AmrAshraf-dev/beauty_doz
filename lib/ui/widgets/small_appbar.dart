import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/page_models/theme_provider.dart';

Widget smallAppbar({bool notification = true, Color color}) {
  return Builder(builder: (context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.15,
          child: Container(
              width: double.infinity,
              height: 24,
              decoration: new BoxDecoration(color: Color(0xff191a1d))),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  // child: Icon(Icons.navigate_before,
                  //     color: color != null ? color : theme.isDark ? Colors.white : Colors.grey),
                ),
                Image.asset("assets/images/logo.png",
                    // color: color != null ? color : theme.isDark ? Colors.white : Colors.grey,
                    width: 24,
                    height: 24),
                notification
                    ? GestureDetector(
                        onTap: () {
                          print("test");
                          // UI.push(context, Routes.notificatioPage());
                        },
                        child: Icon(Icons.notifications))
                    : Container(width: 20)
              ]),
        ),
      ],
    );
  });
}
