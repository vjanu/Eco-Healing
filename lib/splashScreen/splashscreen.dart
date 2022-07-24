import 'dart:async';
import 'dart:math';
import 'package:eco_healing/auth/VerifyEmail.dart';
import 'package:eco_healing/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_healing/mainScreen/HomeScreen.dart';

import '../global/global.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 4), () async {
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      if (firebaseAuth.currentUser != null &&
          firebaseAuth.currentUser!.emailVerified) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const HomeScreen()));
      } else if (firebaseAuth.currentUser != null &&
          !(firebaseAuth.currentUser!.emailVerified)) {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => VerifyEmail()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (c) => const AuthScreen()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    Random random = new Random();

    List<String> strArr = [
      'Reduce, reuse, and recycle. Cut down on what you throw away. Follow the three "Rs" to conserve natural resources and landfill space.',
      'Volunteer. Volunteer for cleanups in your community. You can get involved in protecting your watershed, too.',
      'Educate. When you further your own education, you can help others understand the importance and value of our natural resources.',
      'Conserve water. The less water you use, the less runoff and wastewater that eventually end up in the ocean.',
      'Shop wisely. Buy less plastic and bring a reusable shopping bag.',
      'Plant a tree. Trees provide food and oxygen. They help save energy, clean the air, and help combat climate change.',
      'Bike more. Drive less.',
      'Donate unessential items',
    ];
    int randomNumber = random.nextInt(strArr.length);
    String s = strArr.elementAt(randomNumber);
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
            height: 205,
          ),
          Image.asset("images/Logo_ECO_HEALING.png", scale: 0.5),
          const SizedBox(
            height: 70,
          ),
          const Icon(
            Icons.tips_and_updates,
            color: Colors.green,
            size: 30.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Text(
              s,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 15, fontFamily: 'Varela'),
            ),
          ),
        ]),
      ),
    );
  }
}
