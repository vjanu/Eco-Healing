import 'package:eco_healing/Models/user_model.dart';
import 'package:eco_healing/Screens/Chat_screen.dart';
import 'package:eco_healing/Widget/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:eco_healing/global/global.dart';
import 'package:eco_healing/auth/auth_screen.dart';
import 'package:eco_healing/Widget/ChatScreen.dart';

import '../Screens/User_Listings.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          //body drawer
          Container(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
                // use when implementing chat

                ListTile(
                  leading: const Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "My Listing",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (c) => const myListing()));
                  },
                ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),

                ListTile(
                  leading: const Icon(
                    Icons.exit_to_app,
                    color: Colors.black,
                  ),
                  title: const Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () {
                    firebaseAuth.signOut().then((value) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => const AuthScreen()));
                    });
                  },
                ),

                // ListTile(
                //   leading: const Icon(
                //     Icons.message,
                //     color: Colors.black,
                //   ),
                //   title: const Text(
                //     "My Listings",
                //     style: TextStyle(color: Colors.black),
                //   ),
                //   onTap: () {
                //     firebaseAuth.signOut().then((value) {
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (c) => const myListing()));
                //     });
                //   },
                // ),
                const Divider(
                  height: 10,
                  color: Colors.grey,
                  thickness: 2,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
