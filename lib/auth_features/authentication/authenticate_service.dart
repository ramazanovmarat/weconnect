// внутри AuthenticationService используем Firebase

// сначала получаем экземпляр FirebaseAuth.
// Затем в методе retrieveCurrentUser() используем метод
// authStateChanges() который будет прослушивать любые изменения,
// касающиеся состояния аутентификации пользователя.
// Если пользователь не null, то возвращаем экземпляр UserModel
// с действительным userId, иначе возвращаем экземпляр UserModel со строкой uid,
// которая означает, что пользователь не вошел в систему.

// Затем в методе signUp() вызываем createUserWithEmailAndPassword(),
// чтобы создать нового пользователя в консоли аутентификации Firebase,
// также вызываем verifyEmail(), который проверит адрес электронной почты,
// добавленный пользователем в форме регистрации.

// Затем создаем метод signIn(), который будет содержать метод входа
// с помощью электронной почты и пароля() или возвращать ошибку, если
// электронная почта не прошла проверку подлинности.
// Мы также создаем метод SignOut() для выхода пользователя из системы.

import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';

class AuthenticationService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<UserModel> retrieveCurrentUser(){
    return auth.authStateChanges().map((User? user){
      if(user != null) {
        return UserModel(uid: user.uid, email: user.email);
      } else {
        return UserModel(uid: "uid");
      }
    });
  }

  Future<UserCredential?> signUp(UserModel user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: user.email!, password: user.password!);
      verifyEmail();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }



  }

  Future<UserCredential?> signIn(UserModel user) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: user.email!, password: user.password!);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    }
  }

  Future<void> verifyEmail() async{
    User? user = FirebaseAuth.instance.currentUser;
    if(user != null && !user.emailVerified){
      return await user.sendEmailVerification();
    }
  }

  Future<void> signOut() async {
    return await FirebaseAuth.instance.signOut();
  }
}