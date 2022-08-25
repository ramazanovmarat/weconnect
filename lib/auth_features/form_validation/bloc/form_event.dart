// Здесь создаем перечисление с именем Status, чтобы различать вход и регистрацию.
// Затем создаем событие для каждого поля.
// есть событие изменения электронной почты, которое будет
// содержать поле с именем email. Добавим эти события в OnChanged() каждого
// текстового поля, таким образом, всякий раз, когда пользователь вводит что-либо,
// событие будет добавлено, а затем будет вызван обработчик событий внутри класса Bloc,
// который затем выдаст новое состояние, и в соответствии с этим состоянием
// покажем пользователю ошибку.

import 'package:equatable/equatable.dart';

enum Status { signIn, signUp }

abstract class FormEvent extends Equatable{
  const FormEvent();

  @override
  List<Object?> get props => [];
}

class EmailChanged extends FormEvent{
  final String email;
  const EmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class PasswordChanged extends FormEvent {
  final String password;
  const PasswordChanged(this.password);

  @override
  List<Object> get props => [password];
}

class NameChanged extends FormEvent {
  final String displayName;

  const NameChanged(this.displayName);

  @override
  List<Object> get props => [displayName];
}

class AgeChanged extends FormEvent {
  final int age;
  const AgeChanged(this.age);

  @override
  List<Object> get props => [age];
}

class FormSubmitted extends FormEvent {
  final Status value;
  const FormSubmitted({required this.value});

  @override
  List<Object> get props => [value];
}

class FormSucceeded extends FormEvent {
  const FormSucceeded();

  @override
  List<Object> get props => [];
}