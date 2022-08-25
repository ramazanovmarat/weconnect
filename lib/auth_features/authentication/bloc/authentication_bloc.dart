// внутри bloc if (событие AuthenticationStarted)
// извлекаю uid, если это действительный uid я выдаю состояние
// AuthenticationSuccess с отображаемым именем пользователя или эл.почтой, или возрастом, или же все вместе, иначе,
// если это не удалось, я выдаю AuthenticationFailure.
// Поскольку выдали новое состояние, то blocBuilder<AuthenticationBlock, AuthenticationState>
// в файле app.dart перестроит виджет и перейдет на нужную страницу.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';
import '../authentication_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState>{
  final AuthenticationRepository _authenticationRepository;

  AuthenticationBloc(this._authenticationRepository) : super(AuthenticationInitial()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is AuthenticationStarted) {
        UserModel user = await _authenticationRepository.getCurrentUser().first;
        if (user.uid != "uid") {
          String? displayName = await _authenticationRepository.retrieveUserName(user);
          String? email = await _authenticationRepository.retrieveEmail(user);
          int? age = await _authenticationRepository.retrieveAge(user);

          FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);

          emit(AuthenticationSuccess(displayName: displayName, email: email, age: age));
        } else {
          emit(AuthenticationFailure());
        }
      }
      else if(event is AuthenticationSignedOut){
        await _authenticationRepository.signOut();
        emit(AuthenticationFailure());
      }
    });
  }
}