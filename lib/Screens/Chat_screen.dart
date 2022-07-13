import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_healing/Models/user_model.dart';
import 'package:flutter/material.dart';

class Chatscreen1 extends StatefulWidget {
  UserModel user;

  Chatscreen1(this.user);

  @override
  State<Chatscreen1> createState() => _Chatscreen1State();
}

class _Chatscreen1State extends State<Chatscreen1> {
  TextEditingController searchController = TextEditingController();
  List<Map> searchResult = [];
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("search your friend"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                    hintText: "type username....",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ),
          IconButton(
              onPressed: () {
                onSearch();
              },
              icon: Icon(Icons.search))
        ],
      ),
    );
  }

  Future<void> onSearch() async {
    setState(() {
      searchResult = [];
      isLoading = true;
    });
    await FirebaseFirestore.instance
        .collection('users')
        .where("email", isEqualTo: searchController.text)
        .get()
        .then((value) {
      if (value.docs.length < 1) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("No User Found")));
        setState(() {
          isLoading = false;
        });
        return;
      }
      value.docs.forEach((user) {
        if (user.data()['email'] != widget.user.email) {
          searchResult.add(user.data());
        }
      });
      setState(() {
        isLoading = false;
      });
    });
  }
}
