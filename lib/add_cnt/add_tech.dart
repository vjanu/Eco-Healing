import 'package:flutter/material.dart';
import '../mainScreen/HomeScreen.dart';


class Add_tech extends StatefulWidget {
  const Add_tech({Key? key}) : super(key: key);

  @override
  State<Add_tech> createState() => _Add_techState();
}

class _Add_techState extends State<Add_tech> {

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
          title: const Text("Add Tech Items"),
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
                  Icons.electrical_services_rounded, color: Colors.orange, size: 200,),
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
                    "Upload Tech Image",
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
