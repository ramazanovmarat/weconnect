import 'package:flutter_bloc/flutter_bloc.dart';
import 'bottom_navigation_bar_event.dart';
import 'bottom_navigation_bar_state.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState>{
  int currentIndex = 0;

  BottomNavigationBloc() : super(ViewLoading()) {
    on<BottomNavigationEvent>((event, emit) async {
      if(event is AppStarted) {
        add(ViewTapped(index: currentIndex));
      }
      if(event is ViewTapped){
        currentIndex = event.index;
        emit(CurrentIndexChanged(currentIndex: currentIndex));
        emit(ViewLoading());
      }
      if(currentIndex == 0) {
        emit(HomeViewLoaded());
      }
      if(currentIndex == 1) {
        emit(AccountViewLoaded());
      }
    });
  }
}