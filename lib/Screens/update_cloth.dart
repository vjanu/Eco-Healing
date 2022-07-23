import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../Models/ClothItems.dart';
import '../Models/ElectronicItems.dart';
import '../Models/FoodItems.dart';
import '../storage_service.dart';

class updateClothItem extends StatefulWidget {
  // const updateItem({Key? key}) : super(key: key);
  Clothitems clothitems;
  updateClothItem(this.clothitems);

  @override
  State<updateClothItem> createState() => _updateClothItemState();
}

class _updateClothItemState extends State<updateClothItem> {
  final nameController = TextEditingController();
  final detailController = TextEditingController();
  final addressController = TextEditingController();
  final costController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late final User user = _auth.currentUser!;
  late final uid = user.uid;
  // Similarly we can get email as well
  late final uemail = user.email;

  String path = "";
  String filename = "";
  File? file;
  Position? position;
  List<Placemark>? placeMarks;
  String completeAddress = "";
  String time = DateTime.now().millisecondsSinceEpoch.toString();

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

  getImageData() async {
    final results = await FilePicker.platform.pickFiles(
        allowMultiple: false,
        type: FileType.custom,
        allowedExtensions: ['png', 'jgp', 'jpeg']);
    if (results == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Upload an image'),
        ),
      );
      return null;
    }
    path = results.files.single.path!;
    filename = results.files.single.name;
    setState(() => file = File(path!));
  }

  @override
  void initState() {
    super.initState();

    nameController.addListener(() => setState(() {}));
    detailController.addListener(() => setState(() {}));
    addressController.addListener(() => setState(() {}));
    costController.addListener(() => setState(() {}));

    nameController.text = widget.clothitems.name!;
    detailController.text = widget.clothitems.details!;
    addressController.text = widget.clothitems.address!;
    costController.text = widget.clothitems.cost!;
    filename = widget.clothitems.filename!;
  }

// save data to firebase
  Future saveDataToFirebase() async {
    Map<String, dynamic> data = {
      "name": nameController.text.trim(),
      "details": detailController.text.trim(),
      "address": addressController.text.trim(),
      "cost": costController.text,
      "id": widget.clothitems.id,
      "email": uemail,
      "filepath": path,
      "filename": filename,
    };
    FirebaseFirestore.instance
        .collection("cloth")
        .doc(widget.clothitems.id)
        .set(data);
    firebase_storage.FirebaseStorage.instance
        .ref('projects/cloth/$filename')
        .putFile(file!);
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
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text('Yes'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
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
                color: Colors.lightGreen,
              )),
          title: const Text("Update Cloth Item"),
          centerTitle: true,
          automaticallyImplyLeading: true,
          titleTextStyle: const TextStyle(
            color: Colors.white60,
            fontSize: 21,
            fontFamily: "Signatra",
            letterSpacing: 2,
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
                  buildDetails(),
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
                  UploadPicture(),
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
  Widget buildDetails() => TextFormField(
    controller: detailController,
    validator: (detailController) {
      if (detailController!.isEmpty) {
        return 'Enter item details';
      } else {
        return null;
      }
    },
    decoration: InputDecoration(
        hintText: 'Details',
        labelText: 'Item Details',
        border: const OutlineInputBorder(),
        suffixIcon: detailController.text.isEmpty
            ? Container(
          width: 0,
        )
            : IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => detailController.clear(),
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
  Widget UploadPicture() => ElevatedButton(
    onPressed: () {
      getImageData();
    },
    child: Text('Upload Image'),
  );
}
