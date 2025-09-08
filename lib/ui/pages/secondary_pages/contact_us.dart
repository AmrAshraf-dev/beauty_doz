import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        child: NewAppBar(
          title: 'Contact Us',
          drawer: false,
          returnBtn: true,
          onLanguageChanged: null,
        ),
        preferredSize: Size(ScreenUtil.screenWidthDp, 80),
      ),
      body: SafeArea(
        child: Container(
          height: ScreenUtil.screenHeightDp,
          width: ScreenUtil.screenWidthDp,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        uriNavigation("mailto:", "info@beautydoz.com");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: items(context, locale,
                            icon: Icons.email,
                            text: 'info@beautydoz.com',
                            subText: ""),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        uriNavigation("tel:", "+965-90900795");
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: items(context, locale,
                            icon: Icons.phone,
                            text: '+965-90900795',
                            subText: ""),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  items(BuildContext context, AppLocalizations locale,
      {IconData icon, String text, String subText}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
            child: Container(
          child: Icon(
            icon,
            size: 50,
            color: Color.fromRGBO(219, 170, 68, 1),
          ),
        )),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(text),
              Text(subText),
            ],
          ),
        ),
      ],
    );
  }

  uriNavigation(String schema, String path) async {
    String uri = schema + path;

    if (schema == 'mailto:') {
      uri = uri + '?subject=News&body=New%20plugin';
    }

    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      print("Can not lunch $uri");
    }
  }
}
