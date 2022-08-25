import 'package:flutter/material.dart';

class AnimationNavigate extends PageRouteBuilder {
  final Widget widget;

  AnimationNavigate({required this.widget}) : super(
      transitionDuration: const Duration(milliseconds: 800),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
      Animation<double> secAnimation, Widget child) {
      animation = CurvedAnimation(parent: animation, curve: Curves.decelerate);

    return ScaleTransition(
      alignment: Alignment.centerRight,
      scale: animation,
      child: child,
    );
  },
      pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation) {
        return widget;
      }
  );
}