import 'package:eco_healing/Widget/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_healing/Widget/loading_dialog.dart';
import 'package:eco_healing/mainScreen/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eco_healing/Widget/custom_field.dart';
import 'package:eco_healing/global/global.dart';
import 'package:eco_healing/auth/VerifyEmail.dart';

import '../Screens/forgot_password_page.dart';
// import 'package:flutter/services.dart';

class login_page extends StatefulWidget {
  const login_page({Key? key}) : super(key: key);

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  formValidation() {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? true)
        loginNow();
      else {
        ErrorDialog(
          message: "Please write email/password.",
        );
      }
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please write email/password.",
            );
          });
    }
  }

  loginNow() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadDialog(
            message: "Checking Credentials",
          );
        });

    User? currentUser;
    await firebaseAuth
        .signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user!;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: error.message.toString(),
            );
          });
    });
    if (currentUser != null) {
      // readDataAndSetDataLocally(currentUser!).then((value) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously

      if (currentUser!.emailVerified) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => VerifyEmail()));
      }
      // });
    }
  }

  // Future readDataAndSetDataLocally(User currentUser) async {
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(currentUser.uid)
  //       .get()
  //       .then((snapshot) async {
  //     await sharedPreferences!.setString("userID", currentUser.uid);
  //     await sharedPreferences!
  //         .setString("email", snapshot.data()!["userEmail"]);
  //     await sharedPreferences!
  //         .setString("name", snapshot.data()!["userName"]);
  //     await sharedPreferences!
  //         .setString("photoUrl", snapshot.data()!["userAvatarUrl"]);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        //margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Image.asset(
                "images/Logo-white.png",
                scale: 1,
                width: 250,
                height: 250,
              ),
              Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Customfield(
                        data: Icons.email,
                        controller: emailController,
                        hintText: "Email",
                        isObsecure: false,
                      ),
                      Customfield(
                        data: Icons.lock,
                        controller: passwordController,
                        hintText: "Password",
                        isObsecure: true,
                      ),
                    ],
                  )),
              SizedBox(
                height: 5,
              ),
              GestureDetector(
                child: const Text(
                  'Forgot Password ?',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForgotPasswordPage(),
                      ));
                },
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blueAccent, Colors.deepPurple]),
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.redAccent),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      shadowColor: Colors.transparent,
                      textStyle: const TextStyle(fontSize: 20),
                      minimumSize: const Size(200, 50),
                      onPrimary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onPressed: () {
                    formValidation();
                  },
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
