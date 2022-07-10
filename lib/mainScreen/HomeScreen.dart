import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_healing/add_items/add_cloth_items.dart';
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
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Welcome"),
          backgroundColor: Colors.lightGreen,
        ),
        drawer: MyDrawer(),
        body: StreamBuilder<List<Clothitems>>(
          stream: readClothitems(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final clothitems = snapshot.data;

              return ListView(
                children: clothitems!.map(buildclothitem).toList(),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
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
                child: Icon(Icons.fastfood_rounded),
                label: 'Upload Food Items',
                backgroundColor: Colors.lightGreen,
                onTap: () {
                  print('Food Button Selected');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const AddFood_itmes()));
                }),
            SpeedDialChild(
                child: Icon(Icons.local_shipping_rounded),
                label: 'Upload Cloth Items',
                backgroundColor: Colors.lightGreen,
                onTap: () {
                  print('Cloth Button Selected');
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => const add_cloth()));
                }),
            SpeedDialChild(
                child: Icon(Icons.electrical_services_rounded),
                label: 'Upload Eletronic Items',
                backgroundColor: Colors.lightGreen,
                onTap: () {
                  print('Electoric  Selected');
                })
          ],
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
            // onTap: () {
            //   Navigator.push(
            //      context,
            //       MaterialPageRoute(
            //          builder: (context) => projectScreen(projects)));
            // },
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
            // onTap: () {
            //   Navigator.push(
            //      context,
            //       MaterialPageRoute(
            //          builder: (context) => projectScreen(projects)));
            // },
          ),
        ),
      );

  Stream<List<Fooditems>> readFooditems() => FirebaseFirestore.instance
      .collection('food')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Fooditems.fromJSON(doc.data())).toList());

  Stream<List<Clothitems>> readClothitems() => FirebaseFirestore.instance
      .collection('cloth')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Clothitems.fromJSON(doc.data())).toList());
}
