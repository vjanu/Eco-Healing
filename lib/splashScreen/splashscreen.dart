import 'dart:async';
import 'package:eco_healing/auth/auth_screen.dart';
import 'package:flutter/material.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}


class _MySplashScreenState extends State<MySplashScreen> {

  startTimer()
  {
    Timer(const Duration(seconds:4), () async{
      Navigator.push(context, MaterialPageRoute(builder:(c)=>const AuthScreen()));
    });
  }

  @override
  void initState(){
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child:Container(
        color:Colors.green,
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Image.asset(
             "images/ecohealing.png",
                scale: 0.5
            ),
            const SizedBox(height:15,),

          ]
        ),
      ),


    );
  }
}

