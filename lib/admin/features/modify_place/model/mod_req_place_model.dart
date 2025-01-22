class ModReqPlaceModel {
  int id;
  String placeId;
  String? userId;
  List<dynamic>? selectedNearbyService;
  List<dynamic>? selectedNearbyActivities;
  String? description;
  List? imgLinks;
  DateTime createdAt;

  ModReqPlaceModel({
    required this.id,
    required this.placeId,
    this.userId,
    this.selectedNearbyService,
    this.selectedNearbyActivities,
    this.description,
    this.imgLinks,
    required this.createdAt,
  });

  factory ModReqPlaceModel.fromJson(Map<String, dynamic> json) =>
      ModReqPlaceModel(
        id: json['id'],
        placeId: json['place_id'],
        userId: json['user_id'],
        createdAt: DateTime.parse(json['created_at']),
        selectedNearbyService: json['nearby_service'],
        selectedNearbyActivities: json['nearby_activity'],
        description: json['description'],
        imgLinks: json['img_links'],
      );

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'place_id': placeId,
        'nearby_service': selectedNearbyService,
        'nearby_activity': selectedNearbyActivities,
        'description': description,
        'img_links': imgLinks,
        'created_at': createdAt.toIso8601String(),
      };
}
