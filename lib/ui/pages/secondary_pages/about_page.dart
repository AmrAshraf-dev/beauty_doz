import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        child: NewAppBar(
          title: 'About Us',
          drawer: false,
          returnBtn: true,
          onLanguageChanged: null,
        ),
        preferredSize: Size(ScreenUtil.screenWidthDp, 80),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            GestureDetector(
              onTap: () {
                UI.push(context, Routes.home,
                    replace: true); //* adding navigation
              },
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7.0),
                  image: DecorationImage(
                    image: const AssetImage('assets/images/beautyLogo.png'),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 25),
                    child: locale.locale.languageCode == 'en'
                        ? Column(
                            children: [
                              paragrah(
                                  context: context,
                                  title: "About company",
                                  subtitle:
                                      "BeautyDoz is an e-commerce company with headquarters in Kuwait. BeautyDoz started as an online Perfumes store, but soon diversified, selling Makeup, Skincare, Accessories, and others.. We’re the most complete online shopping experience in the Kuwait"),
                              paragrah(
                                  context: context,
                                  title: "We Know Our Products",
                                  subtitle:
                                      "We’re proud to have the most knowledgeable telephone sales staff in the industry. Training is the key. The bottom line is that when you call, you’ll talk to people who can help you get through what can sometimes be a maze of technology.Whether you want to know how to network your small office, which printer is best for your needs or how the internet works, we’re happy to take the time to help. "),
                            ],
                          )
                        : Column(
                            children: [
                              paragrah(
                                  context: context,
                                  title: "عن الشركة",
                                  subtitle:
                                      " شركة بيوتي دوز هي شركة حديثة في التجارة الإلكترونية بمقرها الرئيسي في دولة الكويت. بدأت فكرة بيوتي دوز من خلال متجر لبيع العطور عبر الموقع الإلكتروني، وما لبثت أن تعددت الأقسام لتشمل جميع مواد التجميل و الاكسسوارات بأنواعها، وبهذا، بيوتي دوز هي شركة كبرى ومتكاملة في أقسامها وخبرتها في مجال التسوق عبر الإنترنت في الكويت."),
                              paragrah(
                                  context: context,
                                  title: "نعرف منتجاتنا جيّداً",
                                  subtitle:
                                      "يمكنك التواصل مع قسم خدمة مبيعات محترفين وعلى دراية كبيرة بالمنتجات، تسعى شركة بيوتي دوز على توفير لعملائها تجربة تسوق ممتازة وفريدة من نوعها.موظفي خدمة العملاء متوفرون لخدمتكم، إتصلوا بنا.."),
                            ],
                          )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget paragrah({BuildContext context, String title, String subtitle}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(subtitle,
            style: TextStyle(
                fontSize: 18,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .color
                    .withOpacity(0.8))),
      ),
    );
  }
}
