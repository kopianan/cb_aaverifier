import 'dart:convert';

TxObject txObjectFromJson(String str) => TxObject.fromJson(json.decode(str));

String txObjectToJson(TxObject data) => json.encode(data.toJson());

class TxObject {
  TxObject({
    required this.from,
    required this.to,
    required this.maxGas,
    required this.gasPrice,
    required this.nonce,
    required this.value,
    required this.data,
  });

  String from;
  String to;
  String maxGas;
  String gasPrice;
  String nonce;
  String value;
  String data;

  factory TxObject.fromJson(Map<String, dynamic> json) => TxObject(
        from: json["from"] == null ? null : json["from"],
        to: json["to"] == null ? null : json["to"],
        maxGas: json["maxGas"] == null ? null : json["maxGas"],
        gasPrice: json["gasPrice"] == null ? null : json["gasPrice"],
        nonce: json["nonce"] == null ? null : json["nonce"],
        value: json["value"] == null ? null : json["value"],
        data: json["data"] == null ? null : json["data"],
      );

  Map<String, dynamic> toJson() => {
        "from": from == null ? null : from,
        "to": to == null ? null : to,
        "maxGas": maxGas == null ? null : maxGas,
        "gasPrice": gasPrice == null ? null : gasPrice,
        "nonce": nonce == null ? null : nonce,
        "value": value == null ? null : value,
        "data": data == null ? null : data,
      };
}
