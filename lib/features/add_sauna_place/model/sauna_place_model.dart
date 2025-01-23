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
  String? website;      // Added website field
  String? instagram;    // Added instagram field
  DateTime createdAt;
  double? distance; // Distance in kilometers from user's location

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
    this.website,      // Added to constructor
    this.instagram,    // Added to constructor
    required this.createdAt,
    this.zipCode,
    this.distance,
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
        saunaType: json['sauna_type'],
        website: json['website'],           // Added to fromJson
        instagram: json['instagram'],       // Added to fromJson
        zipCode: json['zip_code'],
        distance: json['distance'],
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
        'sauna_type': saunaType,
        'website': website,                 // Added to toJson
        'instagram': instagram,             // Added to toJson
        'zip_code': zipCode,
        'created_at': createdAt.toIso8601String(),
        'distance': distance,
      };
}
