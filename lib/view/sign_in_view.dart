import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../auth_features/authentication/bloc/authentication_bloc.dart';
import '../auth_features/authentication/bloc/authentication_event.dart';
import '../auth_features/authentication/bloc/authentication_state.dart';
import '../auth_features/form_validation/bloc/form_bloc.dart';
import '../auth_features/form_validation/bloc/form_event.dart';
import '../auth_features/form_validation/bloc/form_state.dart';
import '../utils/animation_navigate.dart';
import '../utils/constants.dart';
import 'home_view.dart';
import 'sign_up_view.dart';

OutlineInputBorder border = OutlineInputBorder(
  borderRadius: BorderRadius.circular(20)
);

class SignInView extends StatelessWidget {
  const SignInView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MultiBlocListener(
      listeners: [
        BlocListener<FormBloc, FormsValidate>(
          listener: (context, state) {
            if (state.errorMessage.isNotEmpty) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      const ErrorDialog());
            } else if (state.isFormValid && !state.isLoading) {
              context.read<AuthenticationBloc>().add(AuthenticationStarted());
            } else if (state.isFormValidateFailed) {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text(Constants.textFixIssues)));
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                  AnimationNavigate(widget: const HomeView()),
                      (Route<dynamic> route) => false);
            }
          },
        ),
      ],
      child: Scaffold(
          backgroundColor: Constants.kPrimaryColor,
          body: Center(
              child: SingleChildScrollView(
                child:
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                  Text(Constants.textWeconnect,
                            style: GoogleFonts.hind(
                                fontSize: 30,
                              color: Constants.kBlackColor
                            ),
                  ),
                  Padding(padding: EdgeInsets.only(bottom: size.height * 0.03)),
                  const _EmailField(),
                  SizedBox(height: size.height * 0.01),
                  const _PasswordField(),
                  SizedBox(height: size.height * 0.01),
                  const _SubmitButton(),
                  SizedBox(height: size.height * 0.02),
                  const _SignInNavigate(),
                ]),
              ))),
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
                labelText: 'Email',
                labelStyle: const TextStyle(color: Constants.kBlackColor),
                errorMaxLines: 2,
                errorText: !state.isEmailValid
                    ? 'Пожалуйста, убедитесь, что введенный адрес электронной почты действителен'
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                    vertical: 25.0, horizontal: 10.0),
                enabledBorder: OutlineInputBorder(
                  borderSide:  const BorderSide(color: Constants.kBlackColor),
                  borderRadius: BorderRadius.circular(20)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide:  const BorderSide(color: Constants.kBlackColor),
                    borderRadius: BorderRadius.circular(20)
                ),
                border: border
              )
          ),
        );
      },
    );
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
              labelText: 'Пароль',
              labelStyle: const TextStyle(color: Constants.kBlackColor),
              errorMaxLines: 3,
              errorText: !state.isPasswordValid
                  ? 'Пароль должен состоять не менее чем из 8 символов и содержать по крайней мере одну букву и цифру'
                  : null,
                enabledBorder: OutlineInputBorder(
                    borderSide:  const BorderSide(color: Constants.kBlackColor),
                    borderRadius: BorderRadius.circular(20)
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide:  const BorderSide(color: Constants.kBlackColor),
                    borderRadius: BorderRadius.circular(20)
                ),
                border: border,
              suffixIcon: IconButton(
                onPressed: _hidePassword,
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
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
                          .add(const FormSubmitted(value: Status.signIn))
                      : null,
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        Constants.kPrimaryColor),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Constants.kBlackColor),
                    side:
                        MaterialStateProperty.all<BorderSide>(BorderSide.none),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  child: const Text(Constants.textSignIn, style: TextStyle(
                    fontSize: 20
                  ),
                  ),
                ),
              );
      },
    );
  }
}

class _SignInNavigate extends StatelessWidget {
  const _SignInNavigate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: <TextSpan>[
          const TextSpan(
              text: Constants.textAcc,
              style: TextStyle(
                color: Constants.kDarkGreyColor,
              )),
          TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => {
                  Navigator.of(context).pop(),
                  Navigator.push(
                    context,
                      AnimationNavigate(widget: const SignUpView())
                  )
                },
              text: Constants.textSignUp,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Constants.kBlackColor,
              )),
        ]));
  }
}

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
      title: Column(
        children: const [
          Text("Ошибка", textAlign: TextAlign.center),
          Divider(thickness: 1, color: Constants.kBlackColor,)
        ],
      ),
      content: const Text('Пользователь не найден', textAlign: TextAlign.center),
      actions: [
        SizedBox(
          width: double.infinity,
          height: size.height / 15,
          child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              ),
              backgroundColor: MaterialStateProperty.all(Colors.blueGrey)
            ),
              child: const Text('ОК'),
          ),
        ),
      ],
    );
  }
}