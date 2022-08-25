import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';
import '../../authentication/authentication_repository.dart';
import '../../database/database_repository.dart';
import 'form_event.dart';
import 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormsValidate> {
  final AuthenticationRepository _authenticationRepository;
  final DatabaseRepository _databaseRepository;


  // Здесь приведенная ниже форма будет зависеть как от AuthenticationRepository,
  // так и от DatabaseRepository. также используем обработчик событий on,
  // присваивая ему тип каждого события, которое может произойти.
  FormBloc(this._authenticationRepository, this._databaseRepository)
      : super(const FormsValidate(
      email: "example@gmail.com",
      password: "",
      isEmailValid: true,
      isPasswordValid: true,
      isFormValid: false,
      isLoading: false,
      isNameValid: true,
      age: 0,
      isAgeValid: true,
      isFormValidateFailed: false)) {
    on<EmailChanged>(_onEmailChanged);
    on<PasswordChanged>(_onPasswordChanged);
    on<NameChanged>(_onNameChanged);
    on<AgeChanged>(_onAgeChanged);
    on<FormSubmitted>(_onFormSubmitted);
    on<FormSucceeded>(_onFormSucceeded);
  }

  final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  final RegExp _passwordRegExp = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$',
  );

  bool _isEmailValid(String email) {
    return _emailRegExp.hasMatch(email);
  }

  bool _isPasswordValid(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  bool _isNameValid(String? displayName) {
    return displayName!.isNotEmpty;
  }

  bool _isAgeValid(int age) {
    return age >= 1 && age <= 120 ? true : false;
  }

  // Здесь использую copyWith() для обновления состояния и выдачи нового состояния,
  // которое будет наблюдаться либо с помощью BlocBuilder, BlocListener либо BlocConsumer
  // с типом FormsBloc. Внутри copyWith() снова инициализирую все поля этого состояния
  // и использую _isEmailValid() метод, чтобы проверить, является ли электронное письмо
  // действительным в соответствии с регулярным выражением. То же самое делается и с другими методами.
  _onEmailChanged(EmailChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValid: false,
      isFormValidateFailed: false,
      errorMessage: "",
      email: event.email,
      isEmailValid: _isEmailValid(event.email),
    ));
  }

  _onPasswordChanged(PasswordChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      password: event.password,
      isPasswordValid: _isPasswordValid(event.password),
    ));
  }

  _onNameChanged(NameChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      displayName: event.displayName,
      isNameValid: _isNameValid(event.displayName),
    ));
  }

  _onAgeChanged(AgeChanged event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(
      isFormSuccessful: false,
      isFormValidateFailed: false,
      errorMessage: "",
      age: event.age,
      isAgeValid: _isAgeValid(event.age),
    ));
  }

  // Здесь использую событие FormSubmitted которое имеет переменную экземпляра
  // типа Status. Итак, сначала инициализирую UserModel класс, а затем в зависимости
  // от значения Status я либо вызываю, _updateUIAndSignUp() либо _authenticateUser().
  _onFormSubmitted(FormSubmitted event, Emitter<FormsValidate> emit) async {
    UserModel user = UserModel(
        email: state.email,
        password: state.password,
        age: state.age,
        displayName: state.displayName,
    );

    if (event.value == Status.signUp) {
      await _updateUIAndSignUp(event, emit, user);
    } else if (event.value == Status.signIn) {
      await _authenticateUser(event, emit, user);
    }
  }

  // Итак, здесь сначала emit() новое состояние, которое проверит,
  // является ли форма действительной, и присвоит значение true для isLoading,
  // которое покажет на экране индикатор CircularProgressIndicator. Затем, если
  // форма действительна, вызываю метод signUp(), который видели ранее
  // в AuthenticationRepository, затем вызываю метод copyWith() и возвращаю
  // новый экземпляр UserModel. После этого я вызываю saveUserData(), который добавит
  // данные в Cloud Firestore
  //
  // Если пользователь верифицирован, то удаляем циклический индикатор выполнения,
  // присваивая значение false для is Loading и удаляя любое сообщение об ошибке,
  // в противном случае мы показываем ошибку с приведенным выше сообщением.

  _updateUIAndSignUp(FormSubmitted event, Emitter<FormsValidate> emit, UserModel user) async{
    emit(
        state.copyWith(
                 errorMessage: "",
                 isFormValid: _isPasswordValid(state.password) &&
                _isEmailValid(state.email) &&
                _isAgeValid(state.age) &&
                _isNameValid(state.displayName),
            isLoading: true
        ));
    if (state.isFormValid) {
      try {
        UserCredential? authUser = await _authenticationRepository.signUp(user);
        UserModel updatedUser = user.copyWith(
            uid: authUser!.user!.uid, isVerified: authUser.user!.emailVerified);
        await _databaseRepository.saveUserData(updatedUser);
        if (updatedUser.isVerified!) {
          emit(state.copyWith(isLoading: false, errorMessage: ""));
        } else {
          emit(state.copyWith(isFormValid: false,errorMessage: "Пожалуйста, подтвердите свой адрес электронной почты, перейдя по ссылке, отправленной вам по почте.",isLoading: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _authenticateUser(
      FormSubmitted event, Emitter<FormsValidate> emit, UserModel user) async {
    emit(state.copyWith(errorMessage: "",
        isFormValid:
        _isPasswordValid(state.password) && _isEmailValid(state.email),
        isLoading: true));
    if (state.isFormValid) {
      try {
        UserCredential? authUser = await _authenticationRepository.signIn(user);
        UserModel updatedUser = user.copyWith(isVerified: authUser!.user!.emailVerified);
        if (updatedUser.isVerified!) {
          emit(state.copyWith(isLoading: false, errorMessage: ""));
        } else {
          emit(state.copyWith(isFormValid: false,errorMessage: "Пожалуйста, подтвердите свой адрес электронной почты, перейдя по ссылке, отправленной вам по почте.",isLoading: false));
        }
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(
            isLoading: false, errorMessage: e.message, isFormValid: false));
      }
    } else {
      emit(state.copyWith(
          isLoading: false, isFormValid: false, isFormValidateFailed: true));
    }
  }

  _onFormSucceeded(FormSucceeded event, Emitter<FormsValidate> emit) {
    emit(state.copyWith(isFormSuccessful: true));
  }
}