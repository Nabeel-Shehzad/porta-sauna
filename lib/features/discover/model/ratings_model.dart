class RatingsModel {
  int id;
  DateTime createdAt;
  int rating;
  String feedback;
  int locationId;

  RatingsModel({
    required this.id,
    required this.createdAt,
    required this.rating,
    required this.feedback,
    required this.locationId,
  });

  factory RatingsModel.fromJson(Map<String, dynamic> json) => RatingsModel(
        id: json['id'],
        createdAt: DateTime.parse(json['created_at']),
        rating: json['rating'],
        feedback: json['feedback'],
        locationId: json['location_id'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "rating": rating,
        "feedback": feedback,
        "location_id": locationId,
      };
}
