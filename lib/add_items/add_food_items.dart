import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import '../Widget/error_dialog.dart';
import '../Widget/progress_bar.dart';
import '../global/global.dart';
import '../mainScreen/HomeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;


class AddFood_itmes extends StatefulWidget {
  const AddFood_itmes({Key? key}) : super(key: key);

  @override
  State<AddFood_itmes> createState() => _AddFood_itmesState();
}

class _AddFood_itmesState extends State<AddFood_itmes> {

  // Image Picker Handler
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  // Image Uploading
  uploadImage(nImageFile) async {
    storageRef.Reference reference = storageRef.FirebaseStorage
        .instance
        .ref()
        .child("foods");

    storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(nImageFile);

    storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

    String downloadURL = await taskSnapshot.ref.getDownloadURL();

    return downloadURL;
  }

  saveInfo(String downloadUrl) {
    final ref = FirebaseFirestore.instance.collection("food");

    ref.doc(uniqueIdName).set({
      "menuID": uniqueIdName,
      // "sellerUID": sharedPreferences!.getString("uid"),
      "menuInfo": shortInfoController.text.toString(),
      "menuTitle": titleController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    });

    Clear_menu_upload_form();

    setState(() {
      uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();
      uploading = false;
    });
  }

  // Image Taker
  takeImage(nContext){
    return showDialog(
      context: nContext,
      builder: (context){
        return SimpleDialog(
          title: const Text(
              'Select Image From',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight:
                  FontWeight.bold)),
          children: [
            SimpleDialogOption(
              child: const Text(
                "Go with Camera",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: captureImageWithCamera,
            ),

            SimpleDialogOption(
              child: const Text(
                "Go with Gallery",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: captureImageWithGallery,
            ),

            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async{
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720 ,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }
  captureImageWithGallery() async{
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720 ,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }
  // Add Items
  menusUploadFormScreen(){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Food Item Menu"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Colors.greenAccent,
                ],
                begin: FractionalOffset(0.0,0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()
          {
            Clear_menu_upload_form();
          },
        ),
      ),
      body: ListView(
        children: [
          uploading == true ? linearProgress() : const Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
               child: AspectRatio(
                 aspectRatio: 16/9,
                 child: Container(
                   decoration: BoxDecoration(
                     image: DecorationImage(
                       image: FileImage(
                         File(imageXFile!.path)
                       ),
                       fit: BoxFit.cover,
                     ),
                   ),
                 ),
               ),
            ),
          ),
          Divider(
            color: Colors.green,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.perm_device_information,
              color: Colors.green,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black54),
                controller: shortInfoController,
                decoration: const InputDecoration(
                  hintText: "Menu Info",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),

            ),
          ),
          Divider(
            color: Colors.green,
            thickness: 2,
          ),
          ListTile(
            leading: const Icon(
              Icons.title,
              color: Colors.green,
            ),
            title: Container(
              width: 250,
              child: TextField(
                style: const TextStyle(color: Colors.black54),
                controller: titleController,
                decoration: const InputDecoration(
                  hintText: "Menu Title",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),

            ),
          ),
          Divider(
            color: Colors.green,
            thickness: 2,
          ),
          ElevatedButton(
            child: const Text(
              "Add Item",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Lobster",
                letterSpacing: 3,
              ),
            ),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                )
            ),
            onPressed: uploading ? null : ()=> validateUploadForm(),
          ),
        ],
      ),
    );
  }

  Clear_menu_upload_form(){
    setState(() {
      shortInfoController.clear();
      titleController.clear();
      imageXFile = null;
    });
  }

  validateUploadForm() async {
    setState(() {
      uploading = true;
    });

    if(imageXFile != null)
    {
      if(shortInfoController.text.isNotEmpty && titleController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
        });

        //upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));

        //save info to firestore
        saveInfo(downloadUrl);
      }
      else
      {
        showDialog(
            context: context,
            builder: (c)
            {
              return ErrorDialog(
                message: "Please write title and info for menu.",
              );
            }
        );
      }
    }
    else
    {
      showDialog(
          context: context,
          builder: (c)
          {
            return ErrorDialog(
              message: "Please pick an image for menu.",
            );
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }

  // Default Screen
  defaultScreen(){
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Food Items"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.greenAccent,
                  ],
                  begin: FractionalOffset(0.0,0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black54,),
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=>const HomeScreen()));
            },
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green,
                  Colors.greenAccent,
                  // Color(Colors.green.shade200),
                ],
                begin: FractionalOffset(0.0,0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_shopping_cart, color: Colors.orange, size: 200,),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          )
                      )
                  ),
                  onPressed: () {
                    takeImage(context);

                  },
                  child: const Text(
                    "Add Food Item Image",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}