// Здесь создаем событие DatabaseFetched, которое будет вызываться для получения данных из Cloud Firestore.

import 'package:equatable/equatable.dart';

abstract class DatabaseEvent extends Equatable {
  const DatabaseEvent();

  @override
  List<Object?> get props => [];
}

class DatabaseFetched extends DatabaseEvent {
  final String? displayName;
  const DatabaseFetched(this.displayName);
  @override
  List<Object?> get props => [displayName];
}