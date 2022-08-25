// Здесь используем BlocConsumer что позволяет комбинировать и ,
// listener и builder.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_features/authentication/bloc/authentication_bloc.dart';
import '../auth_features/authentication/bloc/authentication_state.dart';
import '../bottom_navigation_bar/bottom_navigation_bar_bloc/bottom_navigation_bar_bloc.dart';
import '../bottom_navigation_bar/bottom_navigation_bar_bloc/bottom_navigation_bar_event.dart';
import '../bottom_navigation_bar/bottom_navigation_bar_bloc/bottom_navigation_bar_state.dart';
import '../utils/constants.dart';
import 'account_view.dart';
import 'home_tab_view.dart';
import 'welcome_view.dart';

OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20)
);

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
      if (state is AuthenticationFailure) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const WelcomeView()),
            (Route<dynamic> route) => false);
      }
    },
        buildWhen: ((previous, current) {
      if (current is AuthenticationFailure) {
        return false;
      }
      return true;
    }), builder: (context, state) {
      return Scaffold(
        body: BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
          builder: (BuildContext context, BottomNavigationState state) {
            if (state is ViewLoading) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Constants.kBlackColor,
              ));
            }
            if (state is HomeViewLoaded) {
              return const HomeTabView();
            }
            if (state is AccountViewLoaded) {
              return const AccountView();
            }
            return Container();
          },
        ),
        bottomNavigationBar:
            BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
             builder: (BuildContext context, BottomNavigationState state) {
             return BottomNavigationBar(
              selectedItemColor: Colors.blueGrey,
              unselectedItemColor: Colors.black,
              currentIndex: context.select((BottomNavigationBloc bloc) => bloc.currentIndex),
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded, color: Colors.black),
                    label: 'Главная',
                    activeIcon: Icon(
                      Icons.home_rounded,
                      color: Colors.blueGrey,
                      size: 30,
                    )),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle_rounded,
                        color: Colors.black),
                    label: 'Аккаунт',
                    activeIcon: Icon(
                      Icons.account_circle_rounded,
                      color: Colors.blueGrey,
                      size: 30,
                    )),
              ],
              onTap: (index) => context
                  .read<BottomNavigationBloc>()
                  .add(ViewTapped(index: index)),
            );
          },
        ),
      );
    }
    );
  }
}
