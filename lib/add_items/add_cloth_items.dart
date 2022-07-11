// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_brace_in_string_interps, use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../storage_service.dart';

class add_cloth extends StatefulWidget {
  const add_cloth({Key? key}) : super(key: key);

  @override
  State<add_cloth> createState() => _add_clothState();
}

class _add_clothState extends State<add_cloth> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final costController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Position? position;
  List<Placemark>? placeMarks;
  String completeAddress = "";

  getCurrentLocation() async {
    Position newPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    position = newPosition;

    placeMarks = await placemarkFromCoordinates(
      position!.latitude,
      position!.longitude,
    );

    Placemark pMark = placeMarks![0];

    completeAddress =
        '${pMark.subThoroughfare} ${pMark.thoroughfare}, ${pMark.subLocality} ${pMark.locality}, ${pMark.subAdministrativeArea}, ${pMark.administrativeArea} ${pMark.postalCode}, ${pMark.country}';

    addressController.text = completeAddress;
  }

  @override
  void initState() {
    super.initState();

    nameController.addListener(() => setState(() {}));
    addressController.addListener(() => setState(() {}));
    costController.addListener(() => setState(() {}));
  }

// save data to firebase
  Future saveDataToFirebase() async {
    Map<String, dynamic> data = {
      "name": nameController.text.trim(),
      "address": addressController.text.trim(),
      "cost": costController.text,
    };
    FirebaseFirestore.instance.collection("cloth").doc().set(data);
  }

  @override
  Widget build(BuildContext context) {
    final Storage storage = Storage();

    return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Do you want to Cancel?'),
                actions: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Cancel'),
                  ),
                ],
              );
            });
        if (value != null) {
          return Future.value(value);
        } else {
          return Future.value(false);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
              decoration: const BoxDecoration(
            color: Colors.black,
          )),
          title: const Text("Add Cloting Items"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          titleTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontFamily: "Signatra",
            letterSpacing: 3,
          ),
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  buildName(),
                  const SizedBox(
                    height: 20,
                  ),
                  buildAddress(),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 400,
                    height: 40,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      label: const Text(
                        "Get my Current Location",
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
                        primary: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildCost(),
                  const SizedBox(
                    height: 20,
                  ),

                  // ----------- submit button ------------
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 20),
                          minimumSize: const Size(200, 50),
                          primary: Colors.black,
                          onPrimary: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () async {
                        final isValid = _formKey.currentState!.validate();
                        if (isValid == true) {
                          saveDataToFirebase();
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        validator: (nameController) {
          if (nameController!.isEmpty) {
            return 'Enter the Name';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: 'Name',
            labelText: 'Item Name',
            border: const OutlineInputBorder(),
            suffixIcon: nameController.text.isEmpty
                ? Container(
                    width: 0,
                  )
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => nameController.clear(),
                  )),
        textInputAction: TextInputAction.done,
      );

  Widget buildAddress() => TextFormField(
        controller: addressController,
        validator: (addresscontroller) {
          if (addresscontroller!.isEmpty) {
            return 'Enter the Address';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: 'Address',
            labelText: 'Address',
            border: const OutlineInputBorder(),
            suffixIcon: addressController.text.isEmpty
                ? Container(width: 0)
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => addressController.clear(),
                  )),
        textInputAction: TextInputAction.done,
      );

  Widget buildCost() => TextFormField(
        controller: costController,
        validator: (costController) {
          if (costController!.isEmpty) {
            return 'Enter the Project Cost';
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
            hintText: 'Project Cost',
            labelText: 'Cost',
            prefixIcon: const Icon(
              Icons.attach_money,
            ),
            border: const OutlineInputBorder(),
            suffixIcon: costController.text.isEmpty
                ? Container(
                    width: 0,
                  )
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => costController.clear(),
                  )),
        textInputAction: TextInputAction.done,
        keyboardType: TextInputType.number,
      );
}