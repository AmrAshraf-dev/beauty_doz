import 'package:flutter/material.dart';

import '../../../core/services/localization/localization.dart';
import '../../../ui/shared/styles/borders.dart';
import '../../../ui/shared/styles/colors.dart';

class TransparentButton extends StatelessWidget {
  final bool localize;
  final double width;
  final bool selected;
  final double height;
  final String text;
  final Function onPressed;
  const TransparentButton(
      {Key key, this.localize = true, this.onPressed, this.text, this.width = 222, this.height = 48, this.selected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return Container(
      height: height,
      width: width,
      child: FlatButton(
        onPressed: onPressed,
        padding: EdgeInsets.all(0),
        color: AppColors.primaryElement,
        textColor: Color.fromARGB(255, 209, 165, 75),
        child: Text(localize ? locale.get(text) : text,
            textAlign: TextAlign.center, style: TextStyle(color: AppColors.secondaryText, fontSize: 16)),
        shape: RoundedRectangleBorder(side: Borders.primaryBorder, borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}
