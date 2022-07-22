// ignore_for_file: use_key_in_widget_constructors

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:eco_healing/Models/ElectronicItems.dart';
import 'package:eco_healing/Models/FoodItems.dart';
import 'package:eco_healing/Models/ClothItems.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

// ignore: camel_case_types
class itemScreen extends StatelessWidget {
  final Clothitems _clothitems;
  void initState() {
    initState();
  }

  const itemScreen(this._clothitems);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
          color: Colors.black,
        )),
        title: const Text("Item Details"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: "Varela",
          letterSpacing: 0,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 5, 10.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              FutureBuilder(
                  future: _clothitems.downloadUrl1(_clothitems.filename!),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Center(
                        child: Container(
                            width: 300,
                            height: 250,
                            child: Image.network(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            )),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting ||
                        !snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container();
                  }),
              const SizedBox(
                height: 20,
              ),
              // ---------- client Name --------------
              const Text(
                "Item Name",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Container(
                  constraints: BoxConstraints(
                    maxHeight: height / 10,
                  ),
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
                  width: width,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    _clothitems.name!,
                    softWrap: true,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),

              // ---------- Details ------------------
              const Text(
                "Item Details",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Container(
                  constraints: BoxConstraints(
                    maxHeight: height / 10,
                  ),
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
                  width: width,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    _clothitems.details!,
                    softWrap: true,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              // ---------- Details ------------------

              //Email
              const Text(
                "Uploader email",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Container(
                  constraints: BoxConstraints(
                    maxHeight: height / 10,
                  ),
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
                  width: width,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    _clothitems.email!,
                    softWrap: true,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),
              //Email

              // ---------- client Address --------------
              const Text(
                "Address",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Container(
                  // ignore: prefer_const_constructors
                  constraints: BoxConstraints(
                    maxHeight: height / 10,
                  ),
                  width: width,
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    _clothitems.address!,
                    softWrap: true,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),

              // ---------- Project stauts --------------
              const Text(
                "Item Cost",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              Container(
                  // ignore: prefer_const_constructors
                  constraints: BoxConstraints(
                    maxHeight: height / 10,
                  ),
                  width: width,
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Colors.black12))),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    _clothitems.cost!,
                    softWrap: true,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  )),
              const SizedBox(
                height: 10,
              ),

              // Container(
              //     width: 300,
              //     height: 250,
              //     child: Image.network(
              //       firebase_storage
              //           .FirebaseStorage.instance
              //           .ref('projects/permit/$pdfDrawing2FileName')
              //           .getDownloadURL();.data!,
              //       fit: BoxFit.cover,
              //     ));
            ],
          ),
        ),
      ),
    );
  }
}
