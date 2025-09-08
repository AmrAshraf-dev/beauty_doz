import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ui_utils/ui_utils.dart';

class RecoveryPage extends StatelessWidget {
  const RecoveryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        child: NewAppBar(
          title: 'Returns & Exchange Policy',
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
                UI.pushReplaceAll(context, Routes.home); //* adding navigation
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
                              paragrah(context,
                                  title: "Returns & Exchange Policy",
                                  subtitle:
                                      "All items are eligible for return during 5-14 calendar days from the day of receiving .\n Items returnable should be as given; sealed, if any, not used and as new \n Any product that is open, unpacked or in a condition other than that provided by the company, its exchange or return is considered unacceptable"),
                              paragrah(context,
                                  title: "DEFECTIVE GOODS",
                                  subtitle:
                                      "Manufactured defective goods should be notified immediately, within 24H, by sending a photo showing clearly the place or part defected"),
                              paragrah(context,
                                  title: "REFUND POLICY",
                                  subtitle:
                                      "1- Watches and Luxury Accessories return policy within 3 Calendar Days \n 2-The money that is returned in cash to the customers will be deducted from the delivery amount \n 3- Returned purchases The amount received is deposited into the bank account according to the bank’s policy."),
                            ],
                          )
                        : Column(
                            children: [
                              paragrah(context,
                                  title: " سياسة الاستبدال والاسترجاع",
                                  subtitle:
                                      "سياسية الاستبدال والاسترجاع  لجميع المشتريات يمكن إرجاعها أو استبدالها خلال 5 الى 14 يوما من تاريخ فاتورة الشراء.المنتجات المرغوب إرجاعها أو استبدالها يجب أن تكون في نفس حالتها المصنعة من المصنع. أي منتج مفتوح أو منزوع التغليف أو في حالة غير المقدم بها من الشركة يعتبر استبداله أو إرجاعه مرفوض."),
                              paragrah(context,
                                  title: "البضائع ذات العيوب المصنعية",
                                  subtitle:
                                      "يجب إخطارنا بالمنتجات ذات العيب المصنعي فور توصيل المنتج وخلال 24 ساعة.إرسال صورة توضح جليا العيب المصنعي المشكو منه مع رقم الطلب."),
                              paragrah(context,
                                  title: "سياسة استرجاع الأموال",
                                  subtitle:
                                      "المشتريات التي يتم إرجاعها يتم إيداع المبلغ الذي تم استلامه في الحساب البنكي وذلك حسب سياسة البنك .الأموال التي سيتم إرجاعها نقدا للعملاء يتم خصم مبلغ التوصيل منها.المنتجات الثمينة يتم ارجاعها خلال مدة اقصاها 2 ايام عمل."),
                            ],
                          )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget paragrah(BuildContext context, {String title, String subtitle}) {
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
                    .withOpacity(0.9))),
      ),
    );
  }
}
