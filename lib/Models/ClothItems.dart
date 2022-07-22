import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Clothitems {
  String? name;
  String? address;
  String? cost;
  String? details;
  String? id;
  String? email;
  String? filename;
  String? downloadUrl;

  Clothitems({
    this.name,
    this.address,
    this.cost,
    this.details,
    this.email,
    this.id,
    this.filename,
    this.downloadUrl,
  });

  static Clothitems fromJSON(Map<String, dynamic> json) => Clothitems(
        name: json["name"],
        address: json["address"],
        cost: json["cost"],
        details: json["details"],
        id: json["id"],
        email: json["email"],
        filename: json["filename"],
        downloadUrl: json["downloadUrl"],
      );
  Future<String> downloadUrl1(String imageName) async {
    String downloadURL = await FirebaseStorage.instance
        .ref('projects/cloth/$filename')
        .getDownloadURL();
    return downloadURL;
  }

  ////////////
  Clothitems.fromDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    //feild name should be exactly same as you given in friebase

    name = snapshot.get('name');
    address = snapshot.get('address');
    cost = snapshot.get('cost');
    details = snapshot.get('details');
    id = snapshot.get('id');
    email = snapshot.get('email');
    filename = snapshot.get('filename');
    // downloadUrl = snapshot.get('downloadUrl');
  }
  ////////////

  Map<String, dynamic> toJson() {
    // ignore: prefer_collection_literals
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["name"] = name;
    data["address"] = address;
    data["cost"] = cost;

    return data;
  }
}
