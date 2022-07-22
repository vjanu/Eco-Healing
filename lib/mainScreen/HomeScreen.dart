import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_healing/Models/ElectronicItems.dart';
import 'package:eco_healing/Widget/electronic_item_screen.dart';
import 'package:eco_healing/Widget/food_item_screen.dart';
import 'package:eco_healing/Widget/cloth_item_screen.dart';
import 'package:eco_healing/add_items/add_cloth_items.dart';
import 'package:eco_healing/add_items/add_electronic_items.dart';
import 'package:flutter/material.dart';
import 'package:eco_healing/add_items/add_food_items.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../Models/FoodItems.dart';
import '../Models/ClothItems.dart';
import '../Widget/my_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: DefaultTabController(
        length: 3,
        child: WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Eco-healing"),
              backgroundColor: Colors.lightGreen,
              centerTitle: true,
              bottom: const TabBar(
                tabs: [
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
            drawer: const MyDrawer(),
            body: TabBarView(
              children: [
                StreamBuilder<List<Fooditems>>(
                  stream: readFooditems(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final fooditems = snapshot.data;

                      return ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        children: fooditems!.map(buildfooditem).toList(),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                StreamBuilder<List<Clothitems>>(
                  stream: readClothitems(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final clothitems = snapshot.data;
                      return ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        children: clothitems!.map(buildclothitem).toList(),
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
                StreamBuilder<List<Electronicitems>>(
                  stream: readElectronicitems(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final electronicitems = snapshot.data;
                      return ListView(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 10.0),
                        children:
                            electronicitems!.map(buildelectronicitem).toList(),
                      );
                    }

                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ],
            ),
            //use incae tabbar fails
            // StreamBuilder<List<Fooditems>>(
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

            floatingActionButton: SpeedDial(
              animatedIcon: AnimatedIcons.add_event,
              backgroundColor: Colors.deepOrangeAccent,
              overlayColor: Colors.lightGreen,
              openCloseDial: isDialOpen,
              overlayOpacity: 0,
              spacing: 10,
              spaceBetweenChildren: 10,
              children: [
                SpeedDialChild(
                    child: const Icon(Icons.fastfood_rounded),
                    label: 'Upload Food Items',
                    backgroundColor: Colors.lightGreen,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => const add_food()));
                    }),
                SpeedDialChild(
                    child: const Icon(Icons.local_shipping_rounded),
                    label: 'Upload Cloth Items',
                    backgroundColor: Colors.lightGreen,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => const add_cloth()));
                    }),
                SpeedDialChild(
                    child: const Icon(Icons.electrical_services_rounded),
                    label: 'Upload Eletronic Items',
                    backgroundColor: Colors.lightGreen,
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const add_electronic()));
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildfooditem(Fooditems fooditems) => Padding(
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
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => foodItemScreen(fooditems)));
            },
          ),
        ),
      );

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
            trailing: const Icon(Icons.keyboard_arrow_right),
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
            trailing: const Icon(Icons.keyboard_arrow_right),
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
        .where("email", isNotEqualTo: auth.currentUser!.email)
        .snapshots();
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
        .where("email", isNotEqualTo: auth.currentUser!.email)
        .snapshots();
    return stream.map((snapshot) => snapshot.docs.map((snap) {
          return Electronicitems.fromDocumentSnapshot(snap);
        }).toList());
  }

  Stream<List<Clothitems>> readClothitems() {
    final CollectionReference noticeCollection =
        FirebaseFirestore.instance.collection('cloth');

    Stream<QuerySnapshot> stream = noticeCollection
        .where("email", isNotEqualTo: auth.currentUser!.email)
        .snapshots();
    return stream.map((snapshot) => snapshot.docs.map((snap) {
          return Clothitems.fromDocumentSnapshot(snap);
        }).toList());
  }
}
