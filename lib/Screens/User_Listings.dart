import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_healing/Models/ElectronicItems.dart';
import 'package:eco_healing/Screens/update_electronic.dart';
import 'package:eco_healing/Widget/electronic_item_screen.dart';
import 'package:eco_healing/Widget/food_item_screen.dart';
import 'package:eco_healing/Widget/cloth_item_screen.dart';
import 'package:eco_healing/add_items/add_cloth_items.dart';
import 'package:eco_healing/add_items/add_electronic_items.dart';
import 'package:eco_healing/mainScreen/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:eco_healing/add_items/add_food_items.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../Models/FoodItems.dart';
import '../Models/ClothItems.dart';
import '../Widget/my_drawer.dart';

class myListing extends StatefulWidget {
  const myListing({Key? key}) : super(key: key);

  @override
  State<myListing> createState() => _myListingState();
}

final FirebaseAuth auth1 = FirebaseAuth.instance;

class _myListingState extends State<myListing> {
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  // final CollectionReference noticeCollection =
  //     FirebaseFirestore.instance.collection('clothes');
  // late final Query unapproved =
  //     noticeCollection.where("email", isNotEqualTo: "test@google.com");

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(HomeScreen()),
            ),
            title: const Text("Your Listings"),
            backgroundColor: Colors.lightGreen,
            centerTitle: true,
            bottom: TabBar(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              unselectedLabelColor: Colors.white60,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Colors.blueAccent, Colors.deepPurple]),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.redAccent),
              tabs: const [
                Tab(
                  text: 'Food',
                  icon: Icon(Icons.fastfood_rounded),
                ),
                Tab(
                  text: 'Clothing',
                  icon: Icon(Icons.local_shipping_rounded),
                ),
                Tab(
                  text: 'Electronics',
                  icon: Icon(Icons.electrical_services_rounded),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              StreamBuilder<List<Fooditems>>(
                stream: readFooditems(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final fooditems = snapshot.data;
                    final size = snapshot.data?.length;
                    if (size == 0) {
                      return const Center(
                        child: Text("No listings found :(",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      );
                    } else {
                      return ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        children: fooditems!.map(buildfooditem).toList()!,
                      );
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              StreamBuilder<List<Clothitems>>(
                stream: readClothitems(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final clothitems = snapshot.data;
                    final size = snapshot.data?.length;
                    if (size == 0) {
                      return const Center(
                        child: Text("No listings found :(",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      );
                    } else {
                      return ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        children: clothitems!.map(buildclothitem).toList(),
                      );
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
              StreamBuilder<List<Electronicitems>>(
                stream: readElectronicitems(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final electronicitems = snapshot.data;
                    final size = snapshot.data?.length;
                    if (size == 0) {
                      return const Center(
                        child: Text("No listings found :(",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      );
                    } else {
                      return ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        children:
                            electronicitems!.map(buildelectronicitem).toList(),
                      );
                    }
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
          //use incae tabbar fails
          // StreamBuilder<List<ooditems>>(
          //   stream: readFooditems(),
          //   builder: (context, snapshot) {
          //     if (snapshot.hasData) {
          //       final fooditems = snapshot.data;
          //
          //       return ListView(
          //         children: fooditems!.map(buildfooditem).toList(),
          //       );
          //     }
          //
          //     return const Center(child: CircularProgressIndicator());
          //   },
          // ),
        ),
      ),
    );
  }

  Widget buildfooditem(Fooditems fooditems) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black12))),
        child: ListTile(
          title: Text(
            fooditems.name!,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          subtitle: Text(fooditems.address!),
          trailing: SizedBox(
            width: 107,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => foodItemScreen(fooditems))),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    String? id = fooditems.id;
                    FirebaseFirestore.instance
                        .collection('food')
                        .doc(id)
                        .delete()
                        .then(
                          (doc) => print("Document deleted"),
                          onError: (e) => print("Error updating document $e"),
                        );
                    ;
                  },
                ),
              ],
            ),
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => foodItemScreen(fooditems)));
          },
        ),
      ),
    );
  }

  Widget buildclothitem(Clothitems clothitems) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12))),
          child: ListTile(
            title: Text(
              clothitems.name!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            subtitle: Text(clothitems.address!),
            trailing: SizedBox(
              width: 107,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => itemScreen(clothitems))),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      String? id = clothitems.id;
                      FirebaseFirestore.instance
                          .collection('cloth')
                          .doc(id)
                          .delete()
                          .then(
                            (doc) => print("Document deleted"),
                            onError: (e) => print("Error updating document $e"),
                          );
                      ;
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => itemScreen(clothitems)));
            },
          ),
        ),
      );

  Widget buildelectronicitem(Electronicitems electronicitems) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0),
        child: Container(
          decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12))),
          child: ListTile(
            title: Text(
              electronicitems.name!,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
            subtitle: Text(electronicitems.address!),
            trailing: SizedBox(
              width: 107,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => updateItem(electronicitems))),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      String? id = electronicitems.id;
                      FirebaseFirestore.instance
                          .collection('electronic')
                          .doc(id)
                          .delete()
                          .then(
                            (doc) => print("Document deleted"),
                            onError: (e) => print("Error updating document $e"),
                          );
                      ;
                    },
                  ),
                ],
              ),
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          electronicItemScreen(electronicitems)));
            },
          ),
        ),
      );

  // Stream<List<Fooditems>> readFooditems() => FirebaseFirestore.instance
  //     .collection('food')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => Fooditems.fromJSON(doc.data())).toList());

  Stream<List<Fooditems>> readFooditems() {
    final CollectionReference noticeCollection =
        FirebaseFirestore.instance.collection('food');

    Stream<QuerySnapshot> stream = noticeCollection
        .where("email", isEqualTo: auth.currentUser!.email)
        .snapshots();
    print(auth.currentUser!.email);
    return stream.map((snapshot) => snapshot.docs.map((snap) {
          return Fooditems.fromDocumentSnapshot(snap);
        }).toList());
  }

  // Stream<List<Clothitems>> readClothitems() => FirebaseFirestore.instance
  //     .collection('cloth')
  //     .snapshots()
  //     .map((snapshot) =>
  //         snapshot.docs.map((doc) => Clothitems.fromJSON(doc.data())).toList());

  // Stream<List<Electronicitems>> readElectronicitems() =>
  //     FirebaseFirestore.instance.collection('electronic').snapshots().map(
  //         (snapshot) => snapshot.docs
  //             .map((doc) => Electronicitems.fromJSON(doc.data()))
  //             .toList());

  Stream<List<Electronicitems>> readElectronicitems() {
    final CollectionReference noticeCollection =
        FirebaseFirestore.instance.collection('electronic');

    Stream<QuerySnapshot> stream = noticeCollection
        .where("email", isEqualTo: auth.currentUser!.email)
        .snapshots();
    return stream.map((snapshot) => snapshot.docs.map((snap) {
          return Electronicitems.fromDocumentSnapshot(snap);
        }).toList());
  }

  Stream<List<Clothitems>> readClothitems() {
    final CollectionReference noticeCollection =
        FirebaseFirestore.instance.collection('cloth');

    Stream<QuerySnapshot> stream = noticeCollection
        .where("email", isEqualTo: auth.currentUser!.email)
        .snapshots();

    // if (snapshot.data!.docs.isEmpty) {
    //   return Text("NO ITEMS FOUND");
    // }

    return stream.map((snapshot) => snapshot.docs.map((snap) {
          return Clothitems.fromDocumentSnapshot(snap);
        }).toList());
  }
}
