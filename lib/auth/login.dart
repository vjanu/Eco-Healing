import 'package:eco_healing/Widget/error_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_healing/Widget/loading_dialog.dart';
import 'package:eco_healing/mainScreen/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eco_healing/Widget/custom_field.dart';
import 'package:eco_healing/global/global.dart';
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
      //login
      loginNow();
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
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => const HomeScreen()));
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
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                "images/ecohealing.jpeg", //"images/loginpage.png",
                height: 270,
              ),
            ),
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),
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
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}
