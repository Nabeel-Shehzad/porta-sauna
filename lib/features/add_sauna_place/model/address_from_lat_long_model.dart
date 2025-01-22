import 'dart:convert';

AddressFromLatLongModel addressFromLatLongModelFromJson(String str) =>
    AddressFromLatLongModel.fromJson(json.decode(str));

String addressFromLatLongModelToJson(AddressFromLatLongModel data) =>
    json.encode(data.toJson());

class AddressFromLatLongModel {
  List<Result> results;

  AddressFromLatLongModel({
    required this.results,
  });

  factory AddressFromLatLongModel.fromJson(Map<String, dynamic> json) =>
      AddressFromLatLongModel(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

class Result {
  String? formattedAddress;
  List<AddressComponent> addressComponents;

  Result({
    this.formattedAddress,
    required this.addressComponents,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        formattedAddress: json["formatted_address"],
        addressComponents: List<AddressComponent>.from(
            json["address_components"]
                .map((x) => AddressComponent.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "address_components":
            List<dynamic>.from(addressComponents.map((x) => x.toJson())),
      };
}

class AddressComponent {
  String? longName;
  String? shortName;
  List<String> types;

  AddressComponent({
    this.longName,
    this.shortName,
    required this.types,
  });

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: List<String>.from(json["types"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "long_name": longName,
        "short_name": shortName,
        "types": List<dynamic>.from(types.map((x) => x)),
      };
}
