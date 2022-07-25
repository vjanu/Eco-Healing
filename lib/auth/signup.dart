import 'dart:io';
import 'package:eco_healing/auth/VerifyEmail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_healing/Widget/custom_field.dart';
import 'package:eco_healing/Widget/loading_dialog.dart';
import 'package:eco_healing/Widget/error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController namecontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController confirmpasswordcontroller = TextEditingController();
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  Position? position;
  List<Placemark>? placeMarks;
  String completeAddress = '';
  String usersImageUrl = '';

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  bool validateStructure(String value) {
    String pattern = r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*\W)";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<void> formValidation() async {
    if (passwordcontroller.text != confirmpasswordcontroller.text) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Password do not match",
            );
          });
    } else if (!validateStructure(passwordcontroller.text)) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message:
                  "Password should be at-least 8 or longer and should have upper case letter,lower case letter, number and a special symbol",
            );
          });
    } else if (passwordcontroller.text.isEmpty ||
        confirmpasswordcontroller.text.isEmpty) {
      showDialog(
          context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Password field cannot be empty!",
            );
          });
    } else {
      showDialog(
          context: context,
          builder: (c) {
            return LoadDialog(
              message: "Registering Account",
            );
          });
      authenticateUserAndSignUp();
    }
  }

  void authenticateUserAndSignUp() async {
    User? currentUser;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    await firebaseAuth
        .createUserWithEmailAndPassword(
      email: emailcontroller.text.trim(),
      password: passwordcontroller.text.trim(),
    )
        .then((auth) {
      currentUser = auth.user;
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
      saveDataToFirestore(currentUser!).then((value) {
        Navigator.pop(context);
        Route newRoute = MaterialPageRoute(builder: (c) => VerifyEmail());
        Navigator.pushReplacement(context, newRoute);
      });
    }
  }

  Future saveDataToFirestore(User currentUser) async {
    FirebaseFirestore.instance.collection("Users").doc(currentUser.uid).set({
      "userID": currentUser.uid,
      "userEmail": emailcontroller.text.trim(),
      "userName": namecontroller.text.trim(),
      "password": passwordcontroller.text.trim(),
      "userAvatarUrl": imageXFile,
      "status": "approved",
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
              child: Column(children: [
                Customfield(
                  data: Icons.person,
                  controller: namecontroller,
                  hintText: "Name",
                  isObsecure: false,
                ),
                Customfield(
                  data: Icons.email,
                  controller: emailcontroller,
                  hintText: "Email",
                  isObsecure: false,
                ),
                Customfield(
                  data: Icons.lock,
                  controller: passwordcontroller,
                  hintText: "Password",
                  isObsecure: true,
                ),
                Customfield(
                  data: Icons.lock,
                  controller: confirmpasswordcontroller,
                  hintText: "Confirm Password",
                  isObsecure: true,
                ),
              ]),
            ),
            SizedBox(
              height: 30,
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
                  "Register",
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
    );
  }
}
