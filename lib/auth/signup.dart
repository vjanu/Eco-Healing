import 'dart:io';
import 'package:eco_healing/mainScreen/HomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_healing/Widget/custom_field.dart';
import 'package:eco_healing/Widget/loading_dialog.dart';
import 'package:eco_healing/Widget/error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;

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

  Position? position;
  List<Placemark>? placeMarks;
  String completeAddress='';
  String usersImageUrl='';

  Future<void> _getImage() async {
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageXFile;
    });
  }

  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
        position!.latitude,
        position!.longitude);

    Placemark pMark = placeMarks![0];

     completeAddress = '${pMark.subThoroughfare} ${pMark
        .thoroughfare},  ${pMark.subLocality} ${pMark.locality}, ${pMark
        .subAdministrativeArea}, ${pMark.administrativeArea} ${pMark
        .postalCode}, ${pMark.country}';
    locationcontroller.text = completeAddress;
  }

  Future<void> formValidation() async
  {
    if (imageXFile == null) {
      showDialog(context: context,
          builder: (c) {
            return ErrorDialog(
              message: "Please select an image",
            );
          }
      );
    }
    else {
      if (passwordcontroller.text != confirmpasswordcontroller.text) {
        showDialog(context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Password do not match",
              );
            }
        );
      }
      else if (passwordcontroller.text.isEmpty ||
          confirmpasswordcontroller.text.isEmpty) {
        showDialog(context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Password field cannot be empty!",
              );
            }
        );
      }
      else if (emailcontroller.text.isEmpty) {
        showDialog(context: context,
            builder: (c) {
              return ErrorDialog(
                message: "Email field is empty!",
              );
            }
        );
      }
      else{
        showDialog(
            context: context,
            builder: (c)
            {
              return LoadDialog(
                message: "Registering Account",
              );
            }
        );
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      fStorage.Reference reference = fStorage.FirebaseStorage.instance.ref().child("Users").child(fileName);
      fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
      fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
      await taskSnapshot.ref.getDownloadURL().then((url) {
        usersImageUrl= url;

        authenticateUserAndSignUp();

      });
      }
    }
  }
 void authenticateUserAndSignUp() async {
   User? currentUser;
   final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
   await firebaseAuth.createUserWithEmailAndPassword(
     email: emailcontroller.text.trim(),
     password: passwordcontroller.text.trim(),
   ).then((auth) {
     currentUser = auth.user;
   }).catchError((error){
     Navigator.pop(context);
     showDialog(
       context:context,
       builder:(c)
         {
           return ErrorDialog(
             message: error.message.toString(),
           );
         }
     );
   });

   if (currentUser != null) {
     saveDataToFirestore(currentUser!).then((value) {
       Navigator.pop(context);

       Route newRoute = MaterialPageRoute(builder: (c)=>HomeScreen());
       Navigator.pushReplacement(context, newRoute);
     });
   }
 }
  Future saveDataToFirestore(User currentUser) async{
    FirebaseFirestore.instance.collection("Users").doc(currentUser.uid).set({

    "userID" : currentUser.uid,
    "userEmail" : emailcontroller.text.trim(),
    "userName" : namecontroller.text.trim(),
    "phone" : phonecontroller.text.trim(),
      "password":passwordcontroller.text.trim(),
    "address": completeAddress,
    "userAvatarUrl":imageXFile,
    "status":"approved",

    });
    //Future<SharedPreferences> sharedPreferences = SharedPreferences.getInstance();
    //SharedPreferences? sharedPreferences;// = await SharedPreferences.getInstance();
    //await sharedPreferences!.setString("uid", currentUser.uid);
    //await sharedPreferences!.setString("name", namecontroller.text.trim());
    //await sharedPreferences!.setString("ImageUrl", usersImageUrl);

  }
    @override
    Widget build(BuildContext context) {
      return SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 10,),
              InkWell(
                onTap: () {
                  _getImage();
                },
                child: CircleAvatar(
                  radius: MediaQuery
                      .of(context)
                      .size
                      .width * 0.20,
                  backgroundColor: Colors.white,
                  backgroundImage: imageXFile == null ? null : FileImage(
                      File(imageXFile!.path)),
                  child: imageXFile == null
                      ?
                  Icon(
                    Icons.add_photo_alternate,
                    size: MediaQuery
                        .of(context)
                        .size
                        .width * 0.20,
                    color: Colors.grey,
                  ) : null,
                ),
              ),
              SizedBox(height: 10,),
              Form(
                key: _formkey,
                child: Column(
                    children:
                    [
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
                      Customfield(
                        data: Icons.phone,
                        controller: phonecontroller,
                        hintText: "Phone",
                        isObsecure: false,

                      ),
                      Customfield(
                        data: Icons.location_city,
                        controller: locationcontroller,
                        hintText: "Location",
                        isObsecure: false,
                      ),
                      Container(
                          width: 400,
                          height: 50,
                          alignment: Alignment.center,
                          child: ElevatedButton.icon(
                              label: Text(
                                "Get my location",
                                style: TextStyle(color: Colors.white),
                              ),

                              icon: const Icon(
                                Icons.location_on,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                getCurrentLocation();
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.amber,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  )
                              )
                          )
                      )
                    ]
                ),

              ),
              SizedBox(height: 30,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.cyan,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                ),
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
              const SizedBox(height: 30,),
            ],
          ),
        ),
      );
    }

}

