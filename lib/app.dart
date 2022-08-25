import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weconnect/view/chat_room.dart';
import 'package:weconnect/view/create_post_view.dart';
import 'package:weconnect/view/welcome_view.dart';
import 'view/home_view.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const BlocNavigate(),
      routes: {
          CreatePostView.id : (context) => const CreatePostView(),
        ChatRoom.id : (context) => const ChatRoom(),
      },
       );
  }
}

class BlocNavigate extends StatelessWidget {
  const BlocNavigate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return const HomeView();
        }
        else {
          return const WelcomeView();
        }
      },
    );
  }
}