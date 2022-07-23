import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:eco_healing/mainScreen/HomeScreen.dart';
import 'package:eco_healing/auth/auth_screen.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  @override
  _VerifyEmailPageState createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmail> {
  bool isEmailVerified = false;
  Timer? timer;
  bool canResenEmail = false;

  @override
  void initState() {
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isEmailVerified) {
      sendVerificationEmail();
      timer = Timer.periodic(
        Duration(seconds: 3),
        (_) => checkEmailVerified(),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isEmailVerified) timer?.cancel();
  }

  Future sendVerificationEmail() async {
    final user = FirebaseAuth.instance.currentUser;
    try {
     // final user = FirebaseAuth.instance.currentUser;
      await user?.sendEmailVerification();
      setState(() => canResenEmail = false);
      await Future.delayed(Duration(seconds: 5));
      setState(() => canResenEmail = true);
    } catch (e) {
      await user?.sendEmailVerification();
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? HomeScreen()
      : Scaffold(
          appBar: AppBar(
            title: Text('Verify Email'),
            backgroundColor: Colors.lightGreen,
          ),
          body: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'A verification email has been sent to your email address'),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50),
                        primary: Colors.lightGreen,
                      ),
                      icon: Icon(Icons.email, size: 32),
                      label: const Text(
                        'Resent Email',
                        style: TextStyle(
                            fontSize: 24),
                      ),

                      onPressed: () {
              sendVerificationEmail();
            },
                      //onPressed: ()=>sendVerificationEmail()
                      // onPressed: () {
                      //   if (canResenEmail) {
                      //     sendVerificationEmail();
                        // }
                      ),
                  const SizedBox(height: 8),
                  TextButton(
                      style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                    ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 24,color:Colors.lightGreen),
                      ),
                  
                      onPressed: () {
                      FirebaseAuth.instance.signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const AuthScreen()));
                      
                    });
                  },
                  ),
                  
                ],
              )));
}
