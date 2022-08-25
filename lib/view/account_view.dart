
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weconnect/view/welcome_view.dart';

import '../auth_features/authentication/bloc/authentication_bloc.dart';
import '../auth_features/authentication/bloc/authentication_event.dart';
import '../auth_features/authentication/bloc/authentication_state.dart';
import '../utils/constants.dart';

class AccountView extends StatefulWidget {
  const AccountView({Key? key}) : super(key: key);

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  File? _image;
  String? _imagePath;

  @override
  void initState() {
    loadImage();
    super.initState();
  }

  void pickImage() async {

    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image == null) return;
    final file = File(image.path);
    setState(() {
      _image = file;
    });
  }

  void saveImage(path) async {
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    saveImage.setString("imagePath", path);
  }

  void loadImage() async {
    SharedPreferences saveImage = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = saveImage.getString("imagePath");
    });
  }

  void removeImage() async {
    SharedPreferences removeImage = await SharedPreferences.getInstance();
    await removeImage.clear();
  }



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
      }),
      builder: (context, state) {
        return Scaffold (
          appBar: AppBar (
            backgroundColor: Constants.kPrimaryColor,
            title: Text((state as AuthenticationSuccess).displayName!,
              style: const TextStyle(color: Constants.kBlackColor),
            ),
            actions: [
              IconButton(
                  onPressed: () async {
                    context.read<AuthenticationBloc>()
                        .add(AuthenticationSignedOut());
                  },
                  icon: const Icon(
                    Icons.logout_outlined,
                    color: Constants.kBlackColor,
                  ),
              ),
            ],
          ),
          body: Center(
            child: Column(
              children: [
                const SizedBox(height: 10),
               _imagePath != null ? CircleAvatar(
                   radius: 100,
                   backgroundImage: FileImage(File(_imagePath!)),
               ) : CircleAvatar(
                 radius: 100,
                 backgroundImage: _image != null ? FileImage(_image!) as ImageProvider : const AssetImage('assets/image/user_default_avatar.jpeg')
               ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                  ),
                    onPressed: () {
                      pickImage();
                    },
                    child: const Text("Добавить фото")
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    ),
                    onPressed: () {
                      saveImage(_image!.path);
                    },
                    child: const Text("Сохранить изменения")
                ),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                    ),
                    onPressed: () {
                      removeImage();
                    },
                    child: const Text("Удалить фото")
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Text(' имя пользователя:  ', style: TextStyle(color: Constants.kDarkGreyColor)),
                    Text((state).displayName!),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(' эл. почта:  ', style: TextStyle(color: Constants.kDarkGreyColor),),
                    Text((state).email!),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const Text(' возраст:  ', style: TextStyle(color: Constants.kDarkGreyColor),),
                    Text('${(state).age!} лет'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
