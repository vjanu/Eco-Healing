import 'package:flutter/material.dart';
import 'package:eco_healing/Widget/custom_field.dart';
//import 'package:flutter/services.dart';

class login_page extends StatefulWidget {
  const login_page({Key? key}) : super(key: key);

  @override
  State<login_page> createState() => _login_pageState();
}

class _login_pageState extends State<login_page> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Image.asset(
                "images/healinghands.jpeg",//"images/loginpage.png",
                height:270,
              ),
            ),
          ),
          Form(
              key: _formkey,
              child: Column(
              children:[
               Customfield(
                 data: Icons.email,
                 controller: emailController,
                 hintText: "Email",
                 isObsecure:false,
               ),
                Customfield(
                  data: Icons.lock,
                  controller: passwordController,
                  hintText: "Password",
                  isObsecure:true,
                ),
              ],
              )
          ),
          ElevatedButton(
            child: const Text(
              "Login",
              style:TextStyle(
                color:Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.cyan,
              padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            ),

            onPressed: ()=> print("Clicked"),
          ),
          const SizedBox(height: 30,),
        ],

      ),
    );
  }
}
