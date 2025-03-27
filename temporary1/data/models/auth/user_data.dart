import 'package:cloud_firestore/cloud_firestore.dart';

class UserDataModel {
  String? name;
  String? email;

  UserDataModel({
    this.name,
    this.email
  });

  factory UserDataModel.fromSnapshot(DocumentSnapshot snapshot) {
    var snapshotMap = snapshot.data() as Map<String, dynamic>;

    return UserDataModel(
      name: snapshotMap['name'],
      email: snapshotMap['email']
    );
  }

  UserDataModel.fromJson(Map<String, dynamic> data) {
    name = data['name'];
    email = data['email'];
  }
}