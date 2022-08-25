// внутри DatabaseService класса используем Cloud Firestore

// Сначала получаем экземпляр Firestore, а затем в addUserData() создаем коллекцию с именем Users,
// а затем назначаем идентификатор пользователя(userId) в качестве идентификатора документа
// и используем метод set() для добавления пользовательских данных в документ.
//
// В retrieveUserData() используем метод get() для извлечения всех документов внутри коллекции Users,
// а затем используем map для возврата списка типа UserModel, который будет содержать все данные.
// также создаем метод с именем retrieveUserName() для получения отображаемого имени пользователя.
// retrieveEmail() для получения Эл.почты пользователя
// retrieveAge() для получения возраста пользователя

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  addUserData(UserModel userData) async {
    await _db.collection("Users").doc(userData.uid).set(userData.toMap());
  }

  Future<List<UserModel>> retrieveUserData() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Users").get();
    return snapshot.docs
        .map((docSnapshot) => UserModel.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<String> retrieveUserName(UserModel user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await _db.collection("Users").doc(user.uid).get();
    return snapshot.data()!["displayName"];
  }

  Future<String> retrieveEmail(UserModel user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").doc(user.uid).get();
    return snapshot.data()!["email"];
  }

  Future<int> retrieveAge(UserModel user) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Users").doc(user.uid).get();
    return snapshot.data()!["age"];
  }
}

