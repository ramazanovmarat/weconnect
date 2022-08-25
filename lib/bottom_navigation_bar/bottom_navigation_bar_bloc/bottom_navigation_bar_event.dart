import 'package:equatable/equatable.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends BottomNavigationEvent {
  @override
  String toString() => 'AppStarted';
}

class ViewTapped extends BottomNavigationEvent {
  final int index;

  const ViewTapped({required this.index});

  @override
  String toString() => 'ViewTapped: $index';
}