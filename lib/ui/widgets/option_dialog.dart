import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/shared/styles/borders.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/reactive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class OptionsDialog extends StatelessWidget {
  final CategoryItems item;
  final FormArray form;

  OptionsDialog({this.item, this.form});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: _buildDialogContent(context),
    );
  }

  Widget _buildDialogContent(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return Container(
      height: ScreenUtil.screenHeightDp * .5,
      color: Colors.white,
      child: Column(children: [
        ReactiveFormArray(
          formArray: form,
          builder: (context, formArray, child) => Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: formArray.controls.length ?? 0,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return buildOptionsContainer(context, index, item);
                }),
          ),
        ),
        Container(
          width: 233,
          height: 52,
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color(0xffdbaa44),
            boxShadow: [
              BoxShadow(
                color: const Color(0x99dbaa44),
                offset: Offset(0, 0),
                blurRadius: 10,
              ),
            ],
          ),
          child: FlatButton(
            onPressed: () {
              bool success = true;
              form.controls.forEach((element) {
                if (element.value['optionText'] == null &&
                    element.value['optionValue'] == null) {
                  success = false;
                }
              });
              success
                  ? Navigator.pop(context, form)
                  : UI.toast(locale.get("You must choose options") ??
                      "You must choose options");
            },
            padding: EdgeInsets.all(0),
            color: AppColors.secondaryElement,
            child: Text(locale.get('Continue') ?? 'Continue',
                style: TextStyle(fontSize: 16, color: AppColors.primaryText)),
            shape: RoundedRectangleBorder(
                side: Borders.primaryBorder,
                borderRadius: BorderRadius.all(Radius.circular(10))),
          ),
        )
      ]),
    );
  }

  buildOptionsContainer(BuildContext context, int index, CategoryItems item) {
    final locale = AppLocalizations.of(context);
    if (index < item.options.length)
      return Padding(
        padding:
            const EdgeInsets.only(left: 12.0, right: 12, top: 15, bottom: 12),
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Text(item.options[index].name.localized(context)),
              Text(" : "),
              if (form != null && form.controls.length > 0)
                if (form.controls[index].value['itemOption'].isText) ...[
                  Expanded(
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ReactiveField(
                          type: ReactiveFields.TEXT,
                          borderColor: AppColors.accentText,
                          controllerName: "$index.optionText",
                          hint: form.control("$index.optionText").value != null
                              ? form.control("$index.optionText").value
                              : locale.get("Enter option") ?? "Enter option",
                        )),
                  )
                ] else ...[
                  Expanded(
                      child: ReactiveField(
                    type: ReactiveFields.DROP_DOWN,
                    context: context,
                    filled: true,
                    fillColor: Colors.white,
                    controllerName: "$index.optionValue",
                    items: form.value[index]["itemOption"].values,
                    hint: form.control("$index.optionValue").value != null
                        ? form
                            .control("$index.optionValue")
                            .value
                            .name
                            .localized(context)
                        : locale.get("Select an option") ?? "Select an option",
                  ))
                ]
            ],
          ),
        ),
      );
  }
}
