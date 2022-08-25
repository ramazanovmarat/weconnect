// создаем метод toMap(), который будет использоваться для сохранения данных в базе данных,
// и fromDocumentSnapshot() для сопоставления полученных данных с классом UserModel.
// также используем метод copyWith() для обновления определенных полей и возврата экземпляра с обновленными полями.

import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? uid;
  bool? isVerified;
  final String? email;
  String? password;
  final String? displayName;
  final int? age;

  UserModel({this.uid, this.password, this.email, this.displayName, this.age, this.isVerified});

  Map<String, dynamic> toMap(){
    return {
      'email': email,
      'displayName': displayName,
      'age': age,
    };
  }

  UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        email = doc.data()!["email"],
        age = doc.data()!["age"],
        displayName = doc.data()!["displayName"];

  UserModel copyWith({
    bool? isVerified,
    String? uid,
    String? email,
    String? password,
    String? displayName,
    int? age,
  }) {
    return UserModel(
        uid: uid ?? this.uid,
        email: email ?? this.email,
        password: password ?? this.password,
        displayName: displayName ?? this.displayName,
        age: age ?? this.age,
        isVerified: isVerified ?? this.isVerified,
    );
  }
}