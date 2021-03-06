import 'dart:io';

import 'package:flutter/material.dart';
import 'package:eco_healing/auth/signup.dart';
import 'package:eco_healing/auth/login.dart';
import 'package:flutter/services.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Future<bool> _onWillPop() async {
    SystemNavigator.pop();
    return false;
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          appBar: AppBar(
              flexibleSpace: Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Colors.lightGreen,
                  // Colors.lightGreenAccent
                ],
                // begin:FractionalOffset(0.0,0.0),
                //end:FractionalOffset(1.0,0.0),
                //stops:[0.0, 1.0],
                // tileMode: TileMode.clamp,
              ))),
              automaticallyImplyLeading: false,
              title: const Text('Eco-Healing'),
              centerTitle: true,
              bottom: const TabBar(tabs: [
                Tab(
                  icon: Icon(Icons.person, color: Colors.white),
                  text: "Sign Up",
                ),
                Tab(
                  icon: Icon(Icons.lock, color: Colors.white),
                  text: "Login",
                )
              ])),
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Colors.green,
                Colors.lightGreen,
                // Colors.lightGreenAccent
              ],
              // begin:FractionalOffset(0.0,0.0),
              //end:FractionalOffset(1.0,0.0),
              //stops:[0.0, 1.0],
              // tileMode: TileMode.clamp,
            )),
            child: const TabBarView(
              children: [
                SignupScreen(),
                login_page(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
