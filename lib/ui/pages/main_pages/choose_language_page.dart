import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/main_pages_models/choose_language_page_model.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/shared/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../shared/styles/colors.dart';

class ChooseLanguagePage extends StatelessWidget {
  const ChooseLanguagePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: BaseWidget<ChooseLanguagePageModel>(
            model: ChooseLanguagePageModel(languageModel: Provider.of(context)),
            builder: (context, model, child) {
              return Scaffold(
                backgroundColor: Theme.of(context).backgroundColor,
                body: Container(
                  width: ScreenUtil.screenWidthDp,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset('assets/images/beautyLogo.png',
                            width: ScreenUtil.screenHeightDp / 5),
                        Text(
                          locale.get('Choose your preferred language'),
                          style: TextStyle(
                            color: AppColors.accentText,
                          ),
                        ),
                        SizedBox(height: 25),
                        LanguageButton(
                          text: 'English',
                          selected: model.checkedButton == 1,
                          onPressed: () => model.switchLang(context, 'en'),
                        ),
                        SizedBox(height: 25),
                        LanguageButton(
                          text: 'العربية',
                          selected: model.checkedButton == 2,
                          onPressed: () => model.switchLang(context, 'ar'),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final double width;
  final bool selected;
  final double height;
  final String text;
  final Function onPressed;
  const LanguageButton(
      {Key key,
      this.onPressed,
      this.text,
      this.width = 222,
      this.height = 48,
      this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: selected
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentText,
                  offset: Offset(0, 0),
                  blurRadius: 8,
                ),
              ],
            )
          : null,
      child: FlatButton(
        onPressed: onPressed,
        padding: EdgeInsets.all(0),
        child: Text(text,
            textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
        shape: RoundedRectangleBorder(
            side: Borders.primaryBorder,
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}
