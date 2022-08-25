// Поскольку этот блок будет использоваться только для проверки,
// поэтому создаем только одно состояние, отличное от начального.
// Мы обновляем состояние формы проверки с помощью метода copyWith().

import 'package:equatable/equatable.dart';

abstract class FormState extends Equatable{
  const FormState();
}

class FormInitial extends Equatable{
  @override
  List<Object?> get props => [];
}

class FormsValidate extends FormState {

  final String email;
  final String? displayName;
  final int age;
  final String password;
  final bool isEmailValid;
  final bool isPasswordValid;
  final bool isFormValid;
  final bool isNameValid;
  final bool isAgeValid;
  final bool isFormValidateFailed;
  final bool isLoading;
  final String errorMessage;
  final bool isFormSuccessful;

  const FormsValidate({
    required this.email,
    required this.password,
    required this.isEmailValid,
    required this.isPasswordValid,
    required this.isFormValid,
    required this.isLoading,
    this.errorMessage = "",
    required this.isNameValid,
    required this.isAgeValid,
    required this.isFormValidateFailed,
    this.displayName,
    required this.age,
    this.isFormSuccessful = false
  });

  FormsValidate copyWith ({
    String? email,
    String? password,
    String? displayName,
    bool? isEmailValid,
    bool? isPasswordValid,
    bool? isFormValid,
    bool? isLoading,
    int? age,
    String? errorMessage,
    bool? isNameValid,
    bool? isLastNameValid,
    bool? isAgeValid,
    bool? isFormValidateFailed,
    bool? isFormSuccessful
  }) {
    return FormsValidate(
        email: email ?? this.email,
        password: password ?? this.password,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        isPasswordValid: isPasswordValid ?? this.isPasswordValid,
        isFormValid: isFormValid ?? this.isFormValid,
        isLoading: isLoading ?? this.isLoading,
        errorMessage: errorMessage ?? this.errorMessage,
        isNameValid: isNameValid ?? this.isNameValid,
        age: age ?? this.age,
        isAgeValid: isAgeValid ?? this.isAgeValid,
        displayName: displayName ?? this.displayName,
        isFormValidateFailed: isFormValidateFailed ?? this.isFormValidateFailed,
        isFormSuccessful: isFormSuccessful ?? this.isFormSuccessful
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    isEmailValid,
    isPasswordValid,
    isFormValid,
    isLoading,
    errorMessage,
    isNameValid,
    displayName,
    age,
    isFormValidateFailed,
    isFormSuccessful,
  ];
}
