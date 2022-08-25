// Здесь есть 3 состояния: начальное, состояние успеха и состояние отказа.

import 'package:equatable/equatable.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  @override
  List<Object?> get props => [];
}

class AuthenticationSuccess extends AuthenticationState {
  final String? email;
  final String? displayName;
  final int? age;
  const AuthenticationSuccess({this.age, this.email, this.displayName});

  @override
  List<Object?> get props => [displayName, email, age];
}

class AuthenticationFailure extends AuthenticationState {
  @override
  List<Object?> get props => [];
}