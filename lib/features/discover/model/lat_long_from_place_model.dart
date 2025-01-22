import 'dart:convert';

LatLongFromPlaceModel latLongFromPlaceModelFromJson(String str) =>
    LatLongFromPlaceModel.fromJson(json.decode(str));

String latLongFromPlaceModelToJson(LatLongFromPlaceModel data) =>
    json.encode(data.toJson());

class LatLongFromPlaceModel {
  List<Result> results;
  String status;

  LatLongFromPlaceModel({
    required this.results,
    required this.status,
  });

  factory LatLongFromPlaceModel.fromJson(Map<String, dynamic> json) =>
      LatLongFromPlaceModel(
        results:
            List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
        "status": status,
      };
}

class Result {
  String? formattedAddress;
  Geometry? geometry;
  String? placeId;

  Result({
    this.formattedAddress,
    this.geometry,
    this.placeId,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        formattedAddress: json["formatted_address"],
        geometry: Geometry.fromJson(json["geometry"]),
        placeId: json["place_id"],
      );

  Map<String, dynamic> toJson() => {
        "formatted_address": formattedAddress,
        "geometry": geometry?.toJson(),
        "place_id": placeId,
      };
}

class Geometry {
  LatLngCustomModel? location;
  String? locationType;
  Viewport? viewport;

  Geometry({
    this.location,
    this.locationType,
    this.viewport,
  });

  factory Geometry.fromJson(Map<String, dynamic> json) => Geometry(
        location: LatLngCustomModel.fromJson(json["location"]),
        locationType: json["location_type"],
        viewport: Viewport.fromJson(json["viewport"]),
      );

  Map<String, dynamic> toJson() => {
        "location": location?.toJson(),
        "location_type": locationType,
        "viewport": viewport?.toJson(),
      };
}

class LatLngCustomModel {
  double? lat;
  double? lng;

  LatLngCustomModel({
    this.lat,
    this.lng,
  });

  factory LatLngCustomModel.fromJson(Map<String, dynamic> json) =>
      LatLngCustomModel(
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat,
        "lng": lng,
      };
}

class Viewport {
  LatLngCustomModel? northeast;
  LatLngCustomModel? southwest;

  Viewport({
    this.northeast,
    this.southwest,
  });

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
        northeast: LatLngCustomModel.fromJson(json["northeast"]),
        southwest: LatLngCustomModel.fromJson(json["southwest"]),
      );

  Map<String, dynamic> toJson() => {
        "northeast": northeast?.toJson(),
        "southwest": southwest?.toJson(),
      };
}
