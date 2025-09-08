import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/secondary_pages/language_page_model.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class LanguagesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return FocusWidget(
      child: Scaffold(
        body: BaseWidget<LanguagesPageModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.retrieveSelectedLanguage()),
            model: LanguagesPageModel(
                languageModel: Provider.of(context),
                auth: Provider.of(context)),
            builder: (context, model, child) {
              String lang = model.retrieveSelectedLanguage();

              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    appBar(
                      context: context,
                      locale: locale,
                      name: 'Languages',
                      verticalPadding: 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: InkWell(
                        onTap: () {
                          model.modifySelectedLanguage(context, 'en');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "English",
                            ),
                            lang == "en"
                                ? Container(
                                    child: Icon(
                                      Icons.check,
                                      color: Color.fromRGBO(228, 194, 125, 1),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: InkWell(
                        onTap: () {
                          model.modifySelectedLanguage(context, 'ar');
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Arabic",
                            ),
                            lang == "ar"
                                ? Container(
                                    child: Icon(
                                      Icons.check,
                                      color: Color.fromRGBO(228, 194, 125, 1),
                                    ),
                                  )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    Divider()
                  ],
                ),
              );
            }),
      ),
    );
  }
}
