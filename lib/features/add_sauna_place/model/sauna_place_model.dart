class SaunaPlaceModel {
  int id;
  String? userId;
  dynamic lattitude;
  dynamic longitude;
  List<dynamic>? selectedWildType;
  List<dynamic>? selectedCommercialType;
  List<dynamic>? selectedNearbyService;
  List<dynamic>? selectedNearbyActivities;
  List<dynamic>? checkedInUsers;
  String? description;
  List? imgLinks;
  String? address;
  String? commercialPhone;
  String? zipCode;
  String? saunaType;
  DateTime createdAt;

  SaunaPlaceModel({
    required this.id,
    this.userId,
    this.lattitude,
    this.longitude,
    this.selectedWildType,
    this.selectedCommercialType,
    this.selectedNearbyService,
    this.selectedNearbyActivities,
    this.checkedInUsers,
    this.description,
    this.imgLinks,
    this.address,
    this.commercialPhone,
    this.saunaType,
    required this.createdAt,
    this.zipCode,
  });

  factory SaunaPlaceModel.fromJson(Map<String, dynamic> json) => SaunaPlaceModel(
        id: json['id'],
        userId: json['user_id'],
        lattitude: json['latitude'],
        createdAt: DateTime.parse(json['created_at']),
        longitude: json['longitude'],
        selectedWildType: json['wild_location'],
        selectedCommercialType: json['commercial_location'],
        selectedNearbyService: json['nearby_service'],
        selectedNearbyActivities: json['nearby_activity'],
        checkedInUsers: json['checked_in_users'],
        description: json['description'],
        imgLinks: json['img_links'],
        address: json['address'],
        commercialPhone: json['commercial_phone'],
        zipCode: json['zip_code'],
        saunaType: json['sauna_type'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'latitude': lattitude,
        'longitude': longitude,
        'wild_location': selectedWildType,
        'commercial_location': selectedCommercialType,
        'nearby_service': selectedNearbyService,
        'nearby_activity': selectedNearbyActivities,
        'checked_in_users': checkedInUsers,
        'description': description,
        'img_links': imgLinks,
        'address': address,
        'commercial_phone': commercialPhone,
        'zip_code': zipCode,
        'sauna_type': saunaType,
        'created_at': createdAt.toIso8601String(),
      };
}
