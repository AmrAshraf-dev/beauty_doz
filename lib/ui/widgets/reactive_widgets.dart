import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

enum ReactiveFields {
  TEXT,
  DROP_DOWN,
  PASSWORD,
  DATE_PICKER,
  DATE_PICKER_FIELD,
  CHECKBOX_LISTTILE,
  RADIO_LISTTILE
}

class ReactiveField extends StatelessWidget {
  @required
  final ReactiveFields type;
  @required
  final String controllerName;
  final int maxLines;
  final double width;
  final Map<String, String> validationMesseges;
  final TextInputType keyboardType;
  final InputDecoration decoration;
  final String hint, radioTitle, radioVal;
  final Color borderColor, hintColor, textColor, fillColor, enabledBorderColor;
  final bool secure, autoFocus, readOnly, filled;
  final List<dynamic> items;
  final BuildContext context;
  final String label;
  final Widget suffexIcon;
  final Widget prefixIcon;
  final textDirection;
  final Function(dynamic) dropDownOnChanged;
  const ReactiveField(
      {this.type,
      this.controllerName,
      this.validationMesseges,
      this.hint,
      this.width = double.infinity,
      this.keyboardType = TextInputType.emailAddress,
      this.secure = false,
      this.autoFocus = false,
      this.readOnly = false,
      this.label,
      this.textDirection = TextDirection.ltr,
      this.radioTitle = '',
      this.borderColor,
      this.hintColor,
      // this.textColor = const Color(0xFFACBBC2),
      this.textColor,
      this.fillColor,
      this.enabledBorderColor,
      this.maxLines = 1,
      this.filled = false,
      this.radioVal = '',
      this.items,
      this.context,
      this.suffexIcon,
      this.prefixIcon,
      this.dropDownOnChanged,
      this.decoration});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Container(
      width: width,
      child: buildReactiveField(locale),
    );
  }

  buildReactiveField(locale) {
    var validationM = validationMesseges ??
        {
          'required': locale.get("Required") ?? "Required",
          'minLength': locale.get("Password must exceed 8 characters") ??
              "Password must exceed 8 characters",
          'mustMatch': locale.get("Passwords doesn't match") ??
              "Passwords doesn't match",
          'email': locale.get("Please enter valid email") ??
              "Please enter valid email"
        };

    switch (type) {
      case ReactiveFields.TEXT:
        return ReactiveTextField(
          formControlName: controllerName,
          validationMessages: (controller) => validationM,
          keyboardType: keyboardType,
          style: TextStyle(color: textColor),
          readOnly: readOnly,
          maxLines: maxLines,
          onTap: () {},
          cursorColor: Theme.of(context).textTheme.bodyText1.color,
          decoration: decoration != null
              ? decoration
              : InputDecoration(
                  // labelStyle: TextStyle(color: Colors.blue),
                  filled: filled,
                  fillColor: Theme.of(context).primaryColor,
                  suffixIcon: suffexIcon,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(
                          width: 1.0,
                          color: Theme.of(context).colorScheme.surface)),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide(
                          width: 1.0,
                          color: Theme.of(context).colorScheme.surface)),
                  labelText: label,
                  hintText: hint,
                  labelStyle: Theme.of(context).textTheme.caption),
          autofocus: autoFocus,
        );
        break;
      case ReactiveFields.PASSWORD:
        return ReactiveTextField(
          formControlName: controllerName,
          validationMessages: (controller) => validationM,
          keyboardType: TextInputType.visiblePassword,
          style: TextStyle(color: textColor),
          cursorColor: Theme.of(context).textTheme.bodyText1.color,
          decoration: decoration != null
              ? decoration
              : InputDecoration(
                  // labelStyle: TextStyle(color: Colors.blue),
                  filled: filled,
                  fillColor: Theme.of(context).primaryColor,
                  // border: InputBorder.none,
                  // focusedBorder: InputBorder.none,
                  // enabledBorder: InputBorder.none,
                  // errorBorder: InputBorder.none,
                  // disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: Colors.red,
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1.color,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide(
                      color: Theme.of(context).textTheme.bodyText1.color,
                      width: 1.0,
                    ),
                  ),

                  labelText: label,
                  hintText: hint,

                  // fillColor: Colors.grey,

                  // fillColor: Colors.white,
                ),
          autofocus: autoFocus,
          readOnly: readOnly,
          obscureText: true,
        );
        break;
      case ReactiveFields.DROP_DOWN:
        return ReactiveDropdownField(
          hint: Text(
            hint ?? "",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          items: items
              .map((item) => DropdownMenuItem<dynamic>(
                    value: item,
                    child: new Text(
                      item.name.localized(context),
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ))
              .toList(),
          style: Theme.of(context).textTheme.bodyText1,
          onChanged: dropDownOnChanged,
          decoration: decoration != null
              ? decoration
              : InputDecoration(
                  // labelStyle: TextStyle(color: Colors.blue),
                  filled: filled,
                  fillColor: Theme.of(context).primaryColor,
                  labelText: label,
                  // hintText: hint,

                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32),
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.surface),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 10)
                  // fillColor: Colors.white,
                  ),
          readOnly: readOnly,

          formControlName: controllerName,

          // style: TextStyle(color: textColor),
        );
        break;
      case ReactiveFields.DATE_PICKER:
        return ReactiveDatePicker(
          formControlName: controllerName,
          builder: (context, picker, child) {
            return IconButton(
              onPressed: picker.showPicker,
              icon: Icon(Icons.date_range),
            );
          },
          firstDate: DateTime(1985),
          lastDate: DateTime(2030),
        );
        break;

      case ReactiveFields.DATE_PICKER_FIELD:
        return ReactiveTextField(
          formControlName: controllerName,
          readOnly: true,
          decoration: InputDecoration(
            suffixIcon: ReactiveTimePicker(
              formControlName: controllerName,
              builder: (context, picker, child) {
                return IconButton(
                  onPressed: picker.showPicker,
                  icon: Icon(Icons.access_time),
                );
              },
            ),
          ),
        );
        break;

      case ReactiveFields.CHECKBOX_LISTTILE:
        return ReactiveCheckboxListTile();
        break;
      case ReactiveFields.RADIO_LISTTILE:
        return ReactiveRadioListTile(
            // activeColor: AppColors.mainColor,
            formControlName: controllerName,
            title: Text(radioTitle),
            value: radioVal);
        break;
    }
  }
}
