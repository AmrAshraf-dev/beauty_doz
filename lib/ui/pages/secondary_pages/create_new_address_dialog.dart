import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/address.dart';
import 'package:beautydoz/core/models/cities.dart';
import 'package:beautydoz/core/models/countries.dart';
import 'package:beautydoz/core/page_models/secondary_pages/address_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/api/http_api.dart';
import 'package:beautydoz/core/services/auth/authentication_service.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/loading_widget.dart';
import 'package:beautydoz/ui/widgets/reactive_widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui_utils/ui_utils.dart';

class AddressDialogPage extends StatelessWidget {
  final List<Countries> countries;

  final Address addresses;

  final bool update;

  final BuildContext ctx;

  AddressDialogPage(this.ctx, {this.countries, this.addresses, this.update});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);
    return BaseWidget<DialogeModel>(
        model: DialogeModel(
          context: ctx,
          api: Provider.of<Api>(context),
          auth: Provider.of(context),
          countries: countries,
          addresses: addresses,
        ),
        builder: (context, model, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: model.busy
                ? Container(
                    height: ScreenUtil.screenWidthDp * 1.25,
                    child: Center(
                        child: CircularProgressIndicator(
                            color: AppColors.accentText)))
                : model.hasError
                    ? Container(
                        height: ScreenUtil.screenWidthDp * 1.25,
                        child: Center(
                          child: Text(locale.get("Error , please try again")),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          height: ScreenUtil.screenWidthDp * 1.25,
                          child: Center(
                            child: ReactiveForm(
                              formGroup: model.form,
                              child: ListView(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: InkWell(
                                      onTap: () => Navigator.of(context).pop(),
                                      child: Icon(Icons.close),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ReactiveField(
                                      context: context,
                                      controllerName: 'country',
                                      type: ReactiveFields.DROP_DOWN,
                                      items: model.countries,
                                      hint:
                                          locale.get("Please choose country") ??
                                              "Please choose country",
                                      dropDownOnChanged: (val) {
                                        model.form.control("country").value =
                                            val;

                                        model.form.control("city").reset();
                                        model.cities.clear();
                                        model.getCities(
                                            context,
                                            model.form
                                                .control("country")
                                                .value
                                                .id);
                                      },
                                    ),
                                  ),
                                  if (model.cities != null &&
                                      model.cities.length > 0) ...[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ReactiveField(
                                        context: context,
                                        controllerName: 'city',
                                        type: ReactiveFields.DROP_DOWN,
                                        items: model.cities,
                                        hint: locale.get("Please choose city"),
                                      ),
                                    )
                                  ],
                                  dialogText(context,
                                      localizedText: locale.get("Address"),
                                      controller: 'line1'),
                                  dialogText(context,
                                      localizedText:
                                          locale.get("Another phone number"),
                                      keyBoardType: TextInputType.number,
                                      controller: 'line2'),
                                  dialogText(context,
                                      localizedText: locale.get("Notes"),
                                      keyBoardType: TextInputType.text,
                                      controller: 'line3'),
                                  ReactiveFormConsumer(
                                    builder: (context, formGroup, child) =>
                                        Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 15),
                                            child: AnimatedContainer(
                                              width: 233,
                                              height: 52,
                                              duration:
                                                  Duration(milliseconds: 300),
                                              margin: EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                color:
                                                    AppColors.primaryBackground,
                                              ),
                                              child: model.busy
                                                  ? LoadingIndicator()
                                                  : FlatButton(
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10)),
                                                      color: formGroup.valid
                                                          ? Color.fromRGBO(
                                                              219, 170, 68, 1)
                                                          : Colors.grey,
                                                      onPressed: formGroup.valid
                                                          ? () {
                                                              model.saveAddress(
                                                                  update);
                                                            }
                                                          : null,
                                                      padding:
                                                          EdgeInsets.all(0),
                                                      child: Text(
                                                          update == true
                                                              ? locale
                                                                  .get('Update')
                                                              : locale.get(
                                                                  'Create'),
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              color: AppColors
                                                                  .primaryText)),
                                                    ),
                                            )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
          );
        });
  }

  Widget dialogText(
    context, {
    String localizedText,
    String controller,
    TextInputType keyBoardType = TextInputType.emailAddress,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ReactiveField(
        context: context,
        controllerName: controller,
        type: ReactiveFields.TEXT,
        hint: localizedText,
        label: localizedText,
      ),
    );
  }
}

class DialogeModel extends BaseNotifier {
  final HttpApi api;
  final AuthenticationService auth;
  final BuildContext context;

  List<Countries> countries;

  Countries selectedCountry;

  List<Cities> cities = [];

  Cities citySelected;

  final Address addresses;

  // TextEditingController stateController = new TextEditingController();
  // TextEditingController line1Controller = new TextEditingController();
  // TextEditingController line2Controller = new TextEditingController();
  // TextEditingController postcodeController = new TextEditingController();

  FormGroup form;

  DialogeModel(
      {this.auth, this.api, this.countries, this.context, this.addresses}) {
    if (countries == null) {
      fetchCountries();
    }

    form = FormGroup({
      "country": FormControl(),
      "city": FormControl(),
      // "state": FormControl(validators: [Validators.required]),
      "line1": FormControl(validators: [Validators.required]),
      "line2": FormControl(validators: [Validators.required]),
      "line3": FormControl(),
      "user": FormGroup({"id": FormControl(value: auth.user.user.id)}),
    });

    if (addresses != null) {
      // stateController.text = addresses.state;
      // citySelected = addresses.city;
      // selectedCountry = addresses.country;
      // line1Controller.text = addresses.line1;
      // line2Controller.text = addresses.line2;
      // postcodeController.text = addresses.postCode;
      form.updateValue(addresses.toJson());

      form.control('country').value = addresses.country;
      form.control('city').value = addresses.country;
      setState();
      // var x = form.control("country").value;
      // print(x["id"]);
      getCities(context, form.control("country").value.id);
    }
  }

  void getCities(BuildContext context, int currentCountryId) async {
    setBusy();

    if (currentCountryId != null) {
      try {
        cities = await api.getCities(context, countryId: currentCountryId);
      } catch (e) {}
    }

    setIdle();
  }

  void changeCurrentCity(newVal) {
    setBusy();
    citySelected = newVal;
    setIdle();
  }

  void saveAddress(bool update) async {
    final locale = AppLocalizations.of(context);

    bool res = false;

    setBusy();
    try {
      if (update == false) {
        res = await api.saveAddress(context, body: form.value);
      } else {
        form.control('user').reset();

        res = await api.updateAddress(context,
            body: form.value, addressId: addresses.id);
      }
    } catch (e) {
      UI.toast(locale.get("Error") ?? "Error");
      setError();
    }
    if (res) {
      UI.toast(locale.get("Address saved successfully") ??
          "Address saved successfully");
      setIdle();
      Navigator.pop(context, res);
    } else {
      UI.toast(locale.get("Address doesn't saved") ?? "Address doesn't saved");
      setError();
    }
  }

  void fetchCountries() async {
    setBusy();
    countries = await api.getCountries(context);
    countries != null ? setIdle() : setError();
  }
}
