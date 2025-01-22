// To parse this JSON data, do
//
//     final mapPredictionModel = mapPredictionModelFromJson(jsonString);

import 'dart:convert';

MapPredictionModel mapPredictionModelFromJson(String str) =>
    MapPredictionModel.fromJson(json.decode(str));

String mapPredictionModelToJson(MapPredictionModel data) =>
    json.encode(data.toJson());

class MapPredictionModel {
  List<Prediction> predictions;
  String? status;

  MapPredictionModel({
    required this.predictions,
    this.status,
  });

  factory MapPredictionModel.fromJson(Map<String, dynamic> json) =>
      MapPredictionModel(
        predictions: List<Prediction>.from(
            json["predictions"].map((x) => Prediction.fromJson(x))),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "predictions": List<dynamic>.from(predictions.map((x) => x.toJson())),
        "status": status,
      };
}

class Prediction {
  String? description;
  String? placeId;
  String? reference;

  Prediction({
    this.description,
    this.placeId,
    this.reference,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json["description"],
        placeId: json["place_id"],
        reference: json["reference"],
      );

  Map<String, dynamic> toJson() => {
        "description": description,
        "place_id": placeId,
        "reference": reference,
      };
}
