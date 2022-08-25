// Класс репозитория будет действовать как слой над классом обслуживания.
// здесь есть операции, касающиеся аутентификации, такие как регистрация, вход и выход.
// также создаем метод retrieveUserName() для получения имени пользователя и еще один для получения текущего пользователя.
// retrieveEmail() для получения эл. почты пользователя
// retrieveAge() для получения возраста пользователя
// Класс AuthenticationRepository будет зависеть от класса
// DatabaseService и AuthenticationService класса.

import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';
import '../database/database_service.dart';
import 'authenticate_service.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  AuthenticationService service = AuthenticationService();
  DatabaseService dbService = DatabaseService();

  @override
  Stream<UserModel> getCurrentUser() {
    return service.retrieveCurrentUser();
  }

  @override
  Future<UserCredential?> signUp(UserModel user) {
    try {
      return service.signUp(user);
    } on FirebaseAuthException catch(e){
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<UserCredential?> signIn(UserModel user) {
    try {
      return service.signIn(user);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  @override
  Future<void> signOut() {
    return service.signOut();
  }

  @override
  Future<String?> retrieveUserName(UserModel user) {
    return dbService.retrieveUserName(user);
  }

  @override
  Future<String?> retrieveEmail(UserModel user) {
    return dbService.retrieveEmail(user);
  }

  @override
  Future<int?> retrieveAge(UserModel user) {
    return dbService.retrieveAge(user);
  }
}

abstract class AuthenticationRepository {
  Stream<UserModel> getCurrentUser();
  Future<UserCredential?> signUp(UserModel user);
  Future<UserCredential?> signIn(UserModel user);
  Future<void> signOut();
  Future<String?> retrieveUserName(UserModel user);
  Future<String?> retrieveEmail(UserModel user);
  Future<int?> retrieveAge(UserModel user);
}