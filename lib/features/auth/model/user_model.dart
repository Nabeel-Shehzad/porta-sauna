class UserModel {
  dynamic id;
  String? email;
  String? name;
  String? profileImg;
  var favourites;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.profileImg,
    this.favourites,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      email: map['email'],
      name: map['user_name'],
      profileImg: map['profile_img'],
      favourites: map['favourites'],
    );
  }
}
