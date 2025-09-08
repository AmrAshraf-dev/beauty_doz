import 'dart:convert';

CurrencyModel currencyModelFromJson(String str) =>
    CurrencyModel.fromJson(json.decode(str));

String currencyModelToJson(CurrencyModel data) => json.encode(data.toJson());

class CurrencyModel {
  CurrencyModel({
    this.currencyRetio,
    this.currencyExtension,
  });

  final num currencyRetio;
  final String currencyExtension;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => CurrencyModel(
        currencyRetio:
            json["currencyRetio"] == null ? null : json["currencyRetio"].toDouble(),
        currencyExtension:
            json["currencyExtension"] == null ? null : json["currencyExtension"],
      );

  Map<String, dynamic> toJson() => {
        "currencyRetio": currencyRetio == null ? null : currencyRetio,
        "currencyExtension": currencyExtension == null ? null : currencyExtension,
      };
}
