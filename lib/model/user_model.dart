class UserModel {
  late String name;
  late String email;
  String? phone;
  late String uid;
  String? pic;
  String? address;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.uid,
    required this.pic,
    required this.address,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    uid = json['uid'];
    pic = json['pic'];
    address = json['address'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uid': uid,
      'pic': pic,
      'address': address,
    };
  }
}
