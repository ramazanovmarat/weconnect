// Здесь использую MultiBlocListener и внутри него я слушаю любые изменения внутри
// FormBloc и AuthenticationBloc.
//
// Во-первых, если errorMessage в FormsValidate классе не пусто, это означает,
// что электронная почта не проверена или signUp метод выдает ошибку, поэтому мы показываем диалог с этой ошибкой.
//
// Если isFormValid истинно и isLoading ложно, то это означает, что signUp сработало,
// поэтому добавляем событие AuthenticationStarted(), которое вызовет
// обработчик события в AuthenticationBloc своем, и он вернет AuthenticationSuccess состояние.
// После того AuthenticationSuccess, как он будет испущен, он вызовет BlocListener тип AuthenticationBloc
// и перейдет на HomeView()страницу.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../auth_features/authentication/bloc/authentication_bloc.dart';
import '../auth_features/authentication/bloc/authentication_event.dart';
import '../auth_features/authentication/bloc/authentication_state.dart';
import '../auth_features/form_validation/bloc/form_bloc.dart';
import '../auth_features/form_validation/bloc/form_event.dart';
import '../auth_features/form_validation/bloc/form_state.dart';
import '../utils/constants.dart';
import 'welcome_view.dart';
import 'home_view.dart';

OutlineInputBorder border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(20)
);


class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
        listeners: [
          BlocListener<FormBloc, FormsValidate>(
              listener: (context, state){
                if(state.errorMessage.isNotEmpty){
                  showDialog(
                      context: context,
                      builder: (context) =>
                          VerificationDialog(verificationMessage: state.errorMessage),
                  );
                } else if(state.isFormValid && !state.isLoading){
                  context.read<AuthenticationBloc>().add(AuthenticationStarted());
                  context.read<FormBloc>().add(const FormSucceeded());
                } else if (state.isFormValidateFailed) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text(Constants.textFixIssues)));
                }
              },
          ),
          BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state){
                if(state is AuthenticationSuccess) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomeView()),
                          (Route<dynamic> route) => false);
                }
              }
          ),
        ],
        child: Scaffold(
          backgroundColor: Constants.kPrimaryColor,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(Constants.textWeconnect,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Constants.kBlackColor,
                        fontSize: 30.0,
                      )),
                  Padding(
                      padding: EdgeInsets.only(bottom: size.height * 0.02)),
                  const _EmailField(),
                  SizedBox(height: size.height * 0.01),
                  const _PasswordField(),
                  SizedBox(height: size.height * 0.01),
                  const _DisplayNameField(),
                  SizedBox(height: size.height * 0.01),
                  const _AgeField(),
                  SizedBox(height: size.height * 0.01),
                  const _SubmitButton()
                ],
              ),
            ),
          ),
        )
    );
  }
}

class VerificationDialog extends StatelessWidget {
  final String? verificationMessage;
  const VerificationDialog({Key? key, this.verificationMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      content: Text(verificationMessage!, textAlign: TextAlign.center),
      actions: [
        SizedBox(
          width: double.infinity,
          height: size.height / 15,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const WelcomeView()),
                    (Route<dynamic> route) => false),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              backgroundColor: MaterialStateProperty.all(
                Colors.blueGrey,
              )
            ),
            child: const Text('ОК'),
          ),
        ),
      ],
    );
  }
}

class _EmailField extends StatelessWidget {
  const _EmailField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
        builder: (context, state) {
      return SizedBox(
        width: size.width * 0.8,
        child: TextFormField(
          onChanged: (value) {
            context.read<FormBloc>().add(EmailChanged(value));
          },
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            errorMaxLines: 2,
            labelText: 'Email',
            labelStyle: const TextStyle(color: Constants.kBlackColor),
            errorText: !state.isEmailValid
                ? 'Пожалуйста, убедитесь, что введенный адрес электронной почты действителен'
                : null,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
            border: border,
            enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Constants.kBlackColor),
                borderRadius: BorderRadius.circular(20)),
            focusedBorder: OutlineInputBorder(
                borderSide:  const BorderSide(color: Constants.kBlackColor),
                borderRadius: BorderRadius.circular(20)
            ),
          ),
        ),
      );
    });
  }
}

class _PasswordField extends StatefulWidget {
  const _PasswordField({Key? key}) : super(key: key);

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {

  bool _obscureText = true;

  void _hidePassword() {
    _obscureText = !_obscureText;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            obscureText: _obscureText,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
              border: border,
              suffixIcon: IconButton(
                onPressed: _hidePassword,
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Constants.kBlackColor,
                ),
              ),
              labelText: 'Пароль',
              labelStyle: const TextStyle(color: Constants.kBlackColor),
              errorMaxLines: 3,
              errorText: !state.isPasswordValid
                  ? 'Пароль должен состоять не менее чем из 8 символов и содержать по крайней мере одну букву и цифру'
                  : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Constants.kBlackColor),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide:  const BorderSide(color: Constants.kBlackColor),
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
            onChanged: (value) {
              context.read<FormBloc>().add(PasswordChanged(value));
            },
          ),
        );
      },
    );
  }
}

class _DisplayNameField extends StatelessWidget {
  const _DisplayNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
              border: border,
              labelText: 'Имя пользователя',
              labelStyle: const TextStyle(color: Constants.kBlackColor),
              errorMaxLines: 2,
              errorText:
              !state.isNameValid ? 'Имя пользователя не может быть пустым!' : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Constants.kBlackColor),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide:  const BorderSide(color: Constants.kBlackColor),
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
            onChanged: (value) {
              context.read<FormBloc>().add(NameChanged(value));
            },
          ),
        );
      },
    );
  }
}

class _AgeField extends StatelessWidget {
  const _AgeField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return SizedBox(
          width: size.width * 0.8,
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
              border: border,
              labelText: 'Возраст',
              labelStyle: const TextStyle(color: Constants.kBlackColor),
              errorMaxLines: 1,
              errorText: !state.isAgeValid
                  ? 'Возраст должен быть действительным'
                  : null,
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Constants.kBlackColor),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide:  const BorderSide(color: Constants.kBlackColor),
                  borderRadius: BorderRadius.circular(20)
              ),
            ),
            onChanged: (value) {
              context.read<FormBloc>().add(AgeChanged(int.parse(value)));
            },
          ),
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<FormBloc, FormsValidate>(
      builder: (context, state) {
        return state.isLoading
            ? const Center(child: CircularProgressIndicator(
          color: Constants.kBlackColor,
        ))
            : SizedBox(
                width: size.width * 0.8,
                height: size.height / 9.5,
                child: ElevatedButton(
                  onPressed: !state.isFormValid
                      ? () => context
                          .read<FormBloc>()
                          .add(const FormSubmitted(value: Status.signUp))
                      : null,

                  style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(
                          Constants.kPrimaryColor),
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Constants.kBlackColor),
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide.none),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: const Text(Constants.textSignUpBtn,
                    style: TextStyle(
                        fontSize: 20
                    ),
                  ),
                ),
              );
      },
    );
  }
}
