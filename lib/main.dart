// призываю Firebase.initializeApp() чтобы иметь возможность использовать службы Firebase.
// Затем использую тот runZoned(), который будет содержать blocObserver свойство,
// которое позволит наблюдать за любыми изменениями, происходящими в блоке.

// также использую MultiBlocProvider для объявления нескольких блоков,
// В приведенном выше коде у меня есть , AuthenticationBloc который будет использоваться
// для аутентификации, я также сразу добавляю событие AuthenticationStarted,
// которое вызовет обработчик событий внутри класса Bloc. также создал FormBloc
// для проверки формы и DatabaseBloc для операций с базой данных.
// и BottomNavigateBloc для нижней панели навигации

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'app.dart';
import 'app_bloc_observer.dart';
import 'auth_features/authentication/authentication_repository.dart';
import 'auth_features/authentication/bloc/authentication_bloc.dart';
import 'auth_features/authentication/bloc/authentication_event.dart';
import 'auth_features/database/bloc/database_bloc.dart';
import 'auth_features/database/database_repository.dart';
import 'auth_features/form_validation/bloc/form_bloc.dart';
import 'bottom_navigation_bar/bottom_navigation_bar_bloc/bottom_navigation_bar_bloc.dart';
import 'bottom_navigation_bar/bottom_navigation_bar_bloc/bottom_navigation_bar_event.dart';


void main() async {
  await SentryFlutter.init((options) {
    options.dsn = 'https://1cf07c7420e14978bda60857901b7afa@o1365859.ingest.sentry.io/6662062';
  }, appRunner: () async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    BlocOverrides.runZoned(
      () => runApp(MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthenticationBloc(AuthenticationRepositoryImpl())
                  ..add(AuthenticationStarted()),
          ),
          BlocProvider(
            create: (context) => FormBloc(
                AuthenticationRepositoryImpl(), DatabaseRepositoryImpl()),
          ),
          BlocProvider(
            create: (context) => DatabaseBloc(DatabaseRepositoryImpl()),
          ),
          BlocProvider(
            create: (context) => BottomNavigationBloc()..add(AppStarted()),
          ),
        ],
        child: const App(),
      )),
      blocObserver: AppBlocObserver(),
    );
  });
}
