import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: PreferredSize(
        child: NewAppBar(
          title: 'Privacy Policy',
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
            Container(
              width: ScreenUtil.screenWidthDp / 3,
              height: ScreenUtil.screenWidthDp / 4,
              child: Image.asset(
                'assets/images/beautyLogo.png',
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 25),
                      child: Column(
                        children: [
                          paragrah(context,
                              title: "Private Data We Receive and Collect",
                              subtitle:
                                  "Beauty Doz automatically collects and receives certain information from your computer or mobile device, including the activities you perform on our Website, the Platforms, and the Applications, the type of hardware and software you are using (for example, your operating system or browser), and information obtained from cookies. For example, each time you visit the Website or otherwise use the Services, we automatically collect your IP address, browser and device type, access times, the web page from which you came, the regions from which you navigate the web page, and the web page(s) you access (as applicable). When you first register for an Beauty Doz account, and when you use the Services, we collect some Personal Information about you such as:"),
                          Text(
                              '* The geographic area where you use your computer and mobile devices'),
                          Text(
                              '* Your full name, username, and email address and other contact details'),
                          Text(
                              '* A unique Beauty Doz user ID (an alphanumeric string) which is assigned to you upon registration'),
                          Text(
                              '* Other optional information as part of your account profile'),
                          Text(
                              '* Your IP Address and, when applicable, timestamp related to your consent and confirmation of consent'),
                          Text(
                              '* Other information submitted by you or your organizational representatives via various methods'),
                          Text(
                              '* Your billing address and any necessary other information to complete any financial transaction, and when making purchases through the Services, we may also collect your credit card or PayPal information'),
                          Text(
                              '* User generated content (such as messages, posts, comments, pages, profiles, images, feeds or communications exchanged on the Supported Platforms)'),
                          Text(
                              '* Images or other files that you may publish via our Services'),
                          Text(
                              '* Information (such as messages, posts, comments, pages, profiles, images) we may receive relating to communications you send us, such as queries or comments concerning.'),
                          paragrah(context,
                              title: "How We Use Beauty Doz Data",
                              subtitle: ""),
                          Text(
                              '1.To identify you when you login to your account'),
                          Text(
                              '2.To enable us to operate the Services and provide them to you'),
                          Text(
                              '3.To verify your transactions and for purchase confirmation, billing, security, and authentication (including security tokens for communication with installed)'),
                          Text(
                              '4. To analyze the Website or the other Services and information about our visitors and users, including research into our user demographics and user behavior in order to improve our content and Services'),
                          Text(
                              '5.To contact you about your account and provide customer service support, including responding to your comments and questions'),
                          Text(
                              '6.To share aggregate (non-identifiable) statistics about users of the Services to prospective advertisers and partners'),
                          Text(
                              '7. To keep you informed about the Services, features, surveys, newsletters, offers, surveys, newsletters, offers, contests and events we think you may find useful or which you have requested from us'),
                          Text(
                              '8.To sell or market Beauty Doz products and services to you'),
                          Text(
                              '9. To better understand your needs and the needs of users in the aggregate, diagnose problems, analyze trends, improve the features and usability of the Services, and better understand and market to our customers and users to keep the Services safe and secure.'),
                          Text(
                              '10. We also use non-identifiable information gathered for statistical purposes to keep track of the number of visits to the Services with a view to introducing improvements and improving usability of the Services. We may share this type of statistical data so that our partners also understand how often people use the Services, so that they, too, may provide you with an optimal experience.'),
                          paragrah(context,
                              title:
                                  "Customer Content We Process for Customers",
                              subtitle:
                                  "Services help our customers promote their products and services, marketing and advertising; engaging audiences; scheduling and publishing messages; and analyze the results."),
                          paragrah(context,
                              title: "Consent of Using Beauty Doz",
                              subtitle:
                                  "By using any of the Services, or submitting or collecting any Personal Information via the Services, you consent to the collection, transfer, storage disclosure, and use of your Personal Information in the manner set out in this Privacy Policy. If you do not consent to the use of your Personal Information in these ways, please stop using the Services."),
                          paragrah(context,
                              title: "Inquire What Data We Have",
                              subtitle:
                                  "Beauty Doz uses tracking technology, in the Applications, and in the Platforms, including mobile application identifiers and a unique Beauty Doz user ID to help us recognize you across different Services, to monitor usage and web traffic routing for the Services, and to customize and improve the Services. By visiting Beauty Doz or using the Services you agree to the use of cookies in your browser and HTML-based emails. Cookies are small text files placed on your device when you visit a website. By using any of the Services, or submitting or collecting any Personal Information via the Services, you consent to the collection, transfer, storage disclosure, and use of your Personal Information"),
                        ],
                      ))),
            )
          ],
        ),
      ),
    );
  }

  Widget paragrah(BuildContext context, {String title, String subtitle}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(subtitle,
            style: TextStyle(
                fontSize: 14,
                color: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .color
                    .withOpacity(0.9))),
      ),
    );
  }
}
