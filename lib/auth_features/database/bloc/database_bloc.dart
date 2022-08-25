// Здесь, если событие DatabaseFetched сработает, оно вызовет метод _fetchUserData(),
// который затем вызовет метод retrieveUserData() и после
// получения ответа выдаст новое состояние с данными, полученными из Cloud Firestore.

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../models/user_model.dart';
import '../database_repository.dart';
import 'database_event.dart';
import 'database_state.dart';

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final DatabaseRepository _databaseRepository;
  DatabaseBloc(this._databaseRepository) : super(DatabaseInitial()) {
    on<DatabaseFetched>(_fetchUserData);
  }

  _fetchUserData(DatabaseFetched event, Emitter<DatabaseState> emit) async {
    List<UserModel> listofUserData = await _databaseRepository.retrieveUserData();
    emit(DatabaseSuccess(listofUserData,event.displayName));
  }
}