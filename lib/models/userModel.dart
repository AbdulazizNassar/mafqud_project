class UserModel {
  String? name;
  String? email;
  String? phoneNum;
  String? uid;
  int? id;
  String? image;

  UserModel({
    this.name,
    this.email,
    this.phoneNum,
    this.uid,
    this.id,
    this.image,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phoneNum = json['phoneNum'];
    uid = json['uid'];
    id = json['ID'];
    image = json['image'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNum': phoneNum,
      'uid': uid,
      'image': image,
      'ID': id,
    };
  }
}
