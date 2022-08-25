import 'package:equatable/equatable.dart';

abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();
}

class CurrentIndexChanged extends BottomNavigationState {
  final int currentIndex;

  const CurrentIndexChanged({required this.currentIndex});

  @override
  String toString() => 'CurrentIndexChanged to $currentIndex';

  @override
  List<Object?> get props => [currentIndex];
}

class ViewLoading extends BottomNavigationState {
  @override
  List<Object?> get props => [];
}

class HomeViewLoaded extends BottomNavigationState {
  @override
  List<Object?> get props => [];

}

class AccountViewLoaded extends BottomNavigationState {
  @override
  List<Object?> get props => [];
}