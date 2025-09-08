import 'package:beautydoz/core/models/categories.dart';
import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/page_models/secondary_pages/sort_dialog_model.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class SortDialog extends StatelessWidget {
  bool val = false;

  final Map<String, dynamic> param;

  SortDialog({this.param});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BaseWidget<SortDialogModel>(
            //initState: (m) => WidgetsBinding.instance.addPostFrameCallback((_) => m.initializeProfileData()),
            model: SortDialogModel(
                param: param, categoryService: Provider.of(context)),
            builder: (context, model, child) {
              print("param: $param");

              List<String> gender = ['Male', 'Female', "uniSex"];
              List<String> price = ['LTH', 'HTL'];

              return Dialog(
                insetPadding:
                    EdgeInsets.only(top: ScreenUtil.screenHeightDp / 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    dialogAppBar(context, locale),
                    model.categoryService.categories == null
                        ? Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(locale.get("Error") ?? "Error"),
                                Container(
                                  width: 100,
                                  child: FlatButton(
                                    color: AppColors.accentText,
                                    onPressed: () {
                                      model.tryAgain(context);
                                    },
                                    child: Center(
                                      child: Text(locale.get("Try again") ??
                                          "Try again"),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : model.busy
                            ? Center(
                                child: LoadingIndicator(),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 20.0, bottom: 8),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: InkWell(
                                                        onTap: () {
                                                          Navigator.of(context)
                                                              .pop(param);
                                                        },
                                                        child: Container(
                                                          width: ScreenUtil
                                                                  .screenWidthDp /
                                                              3,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color: const Color(
                                                                0xffdbaa44),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: const Color(
                                                                    0x99dbaa44),
                                                                offset: Offset(
                                                                    0, 0),
                                                                blurRadius: 10,
                                                              ),
                                                            ],
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          child: Center(
                                                              child: Text(
                                                            locale.get('OK') ??
                                                                'Ok',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      onTap: () {
                                                        param.remove('concId');
                                                        param.remove('sizeId');
                                                        param.remove('gender');
                                                        param.remove('price');
                                                        param.remove(
                                                            'categoryId');
                                                        print(param);
                                                        model.setState();
                                                        print(val);
                                                      },
                                                      child: Container(
                                                        width: ScreenUtil
                                                                .screenWidthDp /
                                                            3,
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          color: const Color(
                                                              0xffdbaa44),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: const Color(
                                                                  0x99dbaa44),
                                                              offset:
                                                                  Offset(0, 0),
                                                              blurRadius: 10,
                                                            ),
                                                          ],
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        child: Center(
                                                            child: Text(
                                                          locale.get(
                                                                  'Clear Filters') ??
                                                              'Clear Filters',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white),
                                                        )),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25.0),
                                              child: Text(locale.get("Gender")),
                                            ),
                                            ...List.generate(gender.length,
                                                (index) {
                                              var genderRadioVal =
                                                  gender[index];
                                              return GestureDetector(
                                                onTap: () {},
                                                child: RadioListTile(
                                                  value: genderRadioVal,
                                                  title: Text(locale
                                                      .get(gender[index])),
                                                  groupValue: param['gender'],

                                                  onChanged: (val) {
                                                    param['gender'] = val;
                                                    genderRadioVal = val;
                                                    print(val);
                                                    model.setState();
                                                  },
                                                  // title: Text(gender[index]),
                                                ),
                                              );
                                            }),
                                            Divider(),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 25.0),
                                              child: Text(locale.get("Price") ??
                                                  "Price"),
                                            ),
                                            ...List.generate(price.length,
                                                (index) {
                                              var priceRadioVal = price[index];
                                              return Container(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: GestureDetector(
                                                  onTap: () {},
                                                  child: RadioListTile(
                                                    value: priceRadioVal,
                                                    groupValue: param['price'],
                                                    onChanged: (val) {
                                                      param['price'] = val;
                                                      priceRadioVal = val;
                                                      model.setState();
                                                      print(val);
                                                    },
                                                    title: Text(price[index] ==
                                                            'LTH'
                                                        ? locale.get(
                                                                'Low to high') ??
                                                            "Low to high"
                                                        : locale.get(
                                                                "High to low") ??
                                                            "High to low"),
                                                  ),
                                                ),
                                              );
                                            }),
                                            Divider(),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(25.0),
                                              child: Text(
                                                  locale.get("Category") ??
                                                      "Category"),
                                            ),
                                            ...List.generate(
                                                model.categoryService.categories
                                                    .length, (index) {
                                              return Container(
                                                padding:
                                                    EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      model
                                                          .categoryService
                                                          .categories[index]
                                                          .name
                                                          .localized(context),
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .accentText),
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    ...List.generate(
                                                        model
                                                            .categoryService
                                                            .categories[index]
                                                            .subCategories
                                                            .length,
                                                        (subIndex) {
                                                      Categories sub = model
                                                              .categoryService
                                                              .categories[index]
                                                              .subCategories[
                                                          subIndex];
                                                      var categoryVal = sub.id;
                                                      return GestureDetector(
                                                          onTap: () {},
                                                          child: RadioListTile(
                                                              value:
                                                                  categoryVal,
                                                              groupValue: param[
                                                                  'categoryId'],
                                                              onChanged: (val) {
                                                                param['categoryId'] =
                                                                    val;
                                                                categoryVal =
                                                                    val;
                                                                model
                                                                    .setState();
                                                                print(val);
                                                              },
                                                              title: Text(sub
                                                                  .name
                                                                  .localized(
                                                                      context))));
                                                    })
                                                  ],
                                                ),
                                              );
                                            }),
                                            Divider(),
                                          ])),
                                ),
                              ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget dialogAppBar(BuildContext context, AppLocalizations locale) {
    // App bar
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          InkWell(
              onTap: () {
                Navigator.of(context).pop(param);
              },
              child: Icon(
                Icons.done,
                color: AppColors.accentText,
              )),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(locale.get("Sort") ?? "Sort"),
              ],
            ),
          ),
          InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(Icons.close)),
        ],
      ),
    );
  }
}
