import 'package:flutter/material.dart';
import '../mainScreen/HomeScreen.dart';


class Add_cloth extends StatefulWidget {
  const Add_cloth({Key? key}) : super(key: key);

  @override
  State<Add_cloth> createState() => _Add_clothState();
}

class _Add_clothState extends State<Add_cloth> {

  takeImage(nContext) {
    return showDialog(
      context: nContext,
      builder: (context) {
        return const SimpleDialog(
          title: Text(
              'Select Image From',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight:
                  FontWeight.bold)),
          children: [

            SimpleDialogOption(
              child: Text(
                "Camera",
                style: TextStyle(color: Colors.white),
              ),
            )

          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Cloth Items"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.greenAccent,
                  ],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black54,),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => const HomeScreen()));
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
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.local_shipping_rounded, color: Colors.orange, size: 200,),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Colors.orangeAccent),
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
                    "Upload Cloth Image",
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
