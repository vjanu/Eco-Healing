import 'dart:io';

import 'package:eco_healing/Widget/custom_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  TextEditingController phonecontroller = TextEditingController();

  TextEditingController locationcontroller = TextEditingController();

  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:Container(
        child:Column(
          mainAxisSize: MainAxisSize.max,
          children:[
            SizedBox(height:10,),
            InkWell(
              child:CircleAvatar(
                radius:MediaQuery.of(context).size.width*0.20,
                backgroundColor:Colors.white,
                backgroundImage: imageXFile==null?null:FileImage(File(imageXFile!.path)),
                child:imageXFile == null
                  ?
                    Icon(
                Icons.add_photo_alternate,
                size:MediaQuery.of(context).size.width * 0.20,
                color: Colors.grey,
                       ):null,
                ),
              ),
            SizedBox(height:10,),
            Form(
                key:_formkey,
              child:Column(
              children:
                  [
                    Customfield(
                      data:Icons.person,
                      controller: namecontroller,
                      hintText: "Name",
                      isObsecure: false,

                    ),
                    Customfield(
                      data:Icons.email,
                      controller: emailcontroller,
                      hintText: "Email",
                      isObsecure: false,

                    ),
                    Customfield(
                      data:Icons.lock,
                      controller: passwordcontroller,
                      hintText: "Password",
                      isObsecure: true,

                    ),
                    Customfield(
                      data:Icons.lock,
                      controller: confirmpasswordcontroller,
                      hintText: "Confirm Password",
                      isObsecure: true,

                    ),
                    Customfield(
                      data:Icons.phone,
                      controller: phonecontroller,
                      hintText: "Phone",
                      isObsecure: false,

                    ),
                   Customfield(
                   data:Icons.location_city,
                   controller: locationcontroller,
                   hintText: "Location",
                   isObsecure: false,
                   ),
                    Container(
                      width:400,
                      height: 50,
                      alignment: Alignment.center,
                      child:ElevatedButton.icon(
                        label:Text(
                          "Get my location",
                          style:TextStyle(color:Colors.white),
                        ),

                        icon:const Icon(
                          Icons.location_on,
                          color:Colors.white,
                        ),
                        onPressed: () => print("clicked"),
                        style:ElevatedButton.styleFrom(
                          primary:Colors.amber,
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )
                        )
                      )
                    )
                  ]
              ),

            ),
            SizedBox(height:30, ),
            ElevatedButton(
                child: const Text(
                  "Sign up",
                  style:TextStyle(
                    color:Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              style: ElevatedButton.styleFrom(
                primary: Colors.black12,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical:20),
              ),
              onPressed: ()=> print("Clicked"),
            )

          ],
        ),
      ),
    );
  }
}
