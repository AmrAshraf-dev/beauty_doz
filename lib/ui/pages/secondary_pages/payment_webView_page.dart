import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/secondary_pages/payment_webView_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

const kAndroidUserAgent =
    'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.94 Mobile Safari/537.36';

class PaymentWebViewPage extends StatefulWidget {
  final Map<String, dynamic> body;

  PaymentWebViewPage({this.body});

  @override
  _PaymentWebViewPageState createState() => _PaymentWebViewPageState();
}

class _PaymentWebViewPageState extends State<PaymentWebViewPage> {
  bool isLoading = true;
  final _key = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final flutterWebviewPlugin = new FlutterWebviewPlugin();

    return WillPopScope(
      onWillPop: () async {
        flutterWebviewPlugin.hide();
        flutterWebviewPlugin.close();
        UI.push(context, Routes.home, replace: true);
        return true;
      },
      child: FocusWidget(
        child: Scaffold(
          body: BaseWidget<PaymentWebPageModel>(
              initState: (m) => WidgetsBinding.instance.addPostFrameCallback(
                  (_) => m.initPayment(promo: widget.body['promo'])),
              model: PaymentWebPageModel(
                  api: Provider.of<Api>(context),
                  auth: Provider.of(context),
                  body: widget.body,
                  context: context),
              builder: (context, model, child) {
                return Column(
                  children: [
                    // buildAppBar(context, locale),
                    model.busy
                        ? Container(
                            height: ScreenUtil.screenHeightDp,
                            width: ScreenUtil.screenWidthDp,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CircularProgressIndicator(
                                    color: AppColors.accentText,
                                  ),
                                  SizedBox(),
                                  Text(model.uiText,
                                      style:
                                          Theme.of(context).textTheme.bodyText1)
                                ],
                                verticalDirection: VerticalDirection.down,
                              ),
                            ),
                          )
                        : model.hasError
                            ? Expanded(
                                child: Center(
                                  child: Text(locale.get("Error") ?? "Error"),
                                ),
                              )
                            : model.url != null && model.url.isNotEmpty
                                ? Container(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    // "https://sandbox.hesabe.com/payment?data=9e5a960de9a5c9abb43fad522fab51d1d74a7c7327986bc76290883449a1cff3071225fccb99846f65c67742170c60b7baa675783e92fa5b6feb27d10cad0d68684929f6dd4eef122211f12c5be8d0d20fd9a2f893079b2f71e792a5d99d9864",
                                    child: WebviewScaffold(
                                      hidden: true,
                                      url: model.url,
                                      ignoreSSLErrors: false,
                                      appBar: AppBar(
                                        backgroundColor: Colors.white,
                                        title: Text(
                                          locale.get('Payment') ?? "Payment",
                                        ),
                                        elevation: 1,
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: Column(
                                      children: [
                                        CircularProgressIndicator(
                                          color: AppColors.accentText,
                                        ),
                                        Expanded(
                                            child: Text(
                                                locale.get(model.uiText) ??
                                                    model.uiText))
                                      ],
                                    ),
                                  ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  SafeArea buildAppBar(BuildContext context, AppLocalizations locale) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 30,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // back arrow
            InkWell(
              onTap: () {
                UI.push(context, Routes.home, replace: true);
              },
              child: Container(
                child:
                    Icon(Icons.arrow_back_ios, size: 28, color: Colors.black),
              ),
            ),

            Text(
              locale.get('Payment') ?? "Payment",
              style: TextStyle(
                  fontSize: 25,
                  color: const Color(0xff313131),
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [],
            ),
          ],
        ),
      ),
    );
  }
}
