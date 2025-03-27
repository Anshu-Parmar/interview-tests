import 'package:cloud_firestore/cloud_firestore.dart';

class UserEntity{
  String? name;
  String? email;
  String? password;
  String? oldPassword;
  Timestamp? createdAt;
  String? createdBy;
  Timestamp? updatedAt;

  UserEntity({
    this.name,
    this.email,
    this.password,
    this.createdAt,
    this.createdBy,
    this.updatedAt,
    this.oldPassword
  });

  UserEntity.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    email = data['email'];
  }

}