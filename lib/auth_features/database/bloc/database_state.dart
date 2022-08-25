// Здесь есть 3 состояния: начальное состояние, состояние успеха,
// которое будет содержать данные, и состояние ошибки.

import 'package:equatable/equatable.dart';

import '../../../models/user_model.dart';

abstract class DatabaseState extends Equatable {
  const DatabaseState();

  @override
  List<Object?> get props => [];
}

class DatabaseInitial extends DatabaseState {}

class DatabaseSuccess extends DatabaseState {
  final List<UserModel> listOfUserData;
  final String? displayName;
  const DatabaseSuccess(this.listOfUserData,this.displayName);

  @override
  List<Object?> get props => [listOfUserData,displayName];
}

class DatabaseError extends DatabaseState {
  @override
  List<Object?> get props => [];
}