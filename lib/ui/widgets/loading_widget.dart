import 'package:beautydoz/core/page_models/theme_provider.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingIndicator extends StatelessWidget {
  final String text;
  final double size;
  const LoadingIndicator({Key key, this.text, this.size = 40})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              color: AppColors.accentText,
            ),
            if (text != null)
              Text(
                text,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
              ),
          ],
        ));
  }
}
