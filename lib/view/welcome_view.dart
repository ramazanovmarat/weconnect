import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/animation_navigate.dart';
import '../utils/constants.dart';
import 'sign_in_view.dart';
import 'sign_up_view.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
       body: Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text(Constants.textWeconnect, style: GoogleFonts.hind(
                 fontSize: 30,
             )),
             Padding(padding: EdgeInsets.only(bottom: size.height * 0.03)),
             SizedBox(
               width: size.width * 0.8,
               height: size.height / 9.5,
               child: ElevatedButton(
                 onPressed: () {
                   Navigator.push(
                     context,
                     AnimationNavigate(widget: const SignInView())
                   );
                 },

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
                 child: const Text(Constants.textStart, style: TextStyle(
                   fontSize: 20
                 ),
                 ),
               ),
             ),
             SizedBox(height: size.height * 0.01),
             SizedBox(
               width: size.width * 0.8,
               height: size.height / 9.5,
               child: ElevatedButton(
                 onPressed: () {
                   Navigator.push(
                     context,
                     AnimationNavigate(widget: const SignUpView()),
                   );
                 },
                 style: ButtonStyle(
                     backgroundColor: MaterialStateProperty.all<Color>(
                         Constants.kBlackColor),
                     side: MaterialStateProperty.all<BorderSide>(
                         BorderSide.none,
                     ),
                     shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                         RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(20),
                         ),
                 ),
                 ),
                 child: const Text(
                   Constants.textCreateAccount,
                   style: TextStyle(color: Constants.kPrimaryColor,
                   fontSize: 20
                   ),
                 ),
               ),
             )
           ],
         ),
       )
    );
  }
}