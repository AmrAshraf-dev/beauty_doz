import 'package:beautydoz/core/utils/provider_setup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/page_models/theme_provider.dart';
import '../../../core/services/localization/localization.dart';
import '../../../ui/shared/styles/gradients.dart';
import '../../../ui/widgets/loading_widget.dart';

class NormalButton extends StatelessWidget {
  final bool localize;
  final bool busy;
  final double width;
  final double height;
  final String text;
  final Gradient gradient;
  final EdgeInsets margin;
  final Function onPressed;
  const NormalButton(
      {Key key,
      this.busy = false,
      this.gradient,
      this.localize = true,
      this.onPressed,
      this.text = 'ok',
      this.width = 322,
      this.height = 46,
      this.margin = const EdgeInsets.only(top: 22)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    final theme = Provider.of<ThemeProvider>(context);

    return StreamBuilder<bool>(
        stream: locator<ThemeProvider>().isDark.stream,
        builder: (context, snapshot) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 600),
            width: busy ? (width / 2) : width,
            height: height,
            margin: EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(34),
                gradient: gradient == null
                    ? (snapshot.data
                        ? Gradients.fireGradient
                        : LinearGradient(
                            colors: [Color(0xff82A2FE), Color(0xff6285FD)]))
                    : gradient),
            child: busy
                ? Center(child: LoadingIndicator())
                : FlatButton(
                    padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(34)),
                    onPressed: () => onPressed == null ? {} : onPressed(),
                    child: Ink(
                      child: Container(
                          width: width,
                          height: height,
                          alignment: Alignment.center,
                          child: Text(localize ? locale.get(text) : text,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontStyle: FontStyle.normal))),
                    ),
                  ),
          );
        });
  }
}
