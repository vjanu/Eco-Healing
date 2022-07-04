import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import '../mainScreen/HomeScreen.dart';

class AddFood_itmes extends StatefulWidget {
  const AddFood_itmes({Key? key}) : super(key: key);

  @override
  State<AddFood_itmes> createState() => _AddFood_itmesState();
}

class _AddFood_itmesState extends State<AddFood_itmes> {

  // Image Taker
  takeImage(nContext){
    return showDialog(
      context: nContext,
      builder: (context){
        return SimpleDialog(
          title: const Text(
              'Select Image From',
              style: TextStyle(
                  color: Colors.blue,
                  fontWeight:
                  FontWeight.bold)),
          children: [
            SimpleDialogOption(
              child: const Text(
                "Go with Camera",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: captureImageWithCamera,
            ),

            SimpleDialogOption(
              child: const Text(
                "Go with Gallery",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: captureImageWithGallery,
            ),

            SimpleDialogOption(
              child: const Text(
                "Cancel",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: ()=> Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async{
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720 ,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }
  captureImageWithGallery() async{
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720 ,
      maxWidth: 1280,
    );

    setState(() {
      imageXFile;
    });
  }
  // Add Items
  menusUploadFormScreen(){

  }

  @override
  Widget build(BuildContext context) {
    return imageXFile == null ? defaultScreen() : menusUploadFormScreen();
  }

  // Image Picker Handler
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().millisecondsSinceEpoch.toString();

  // Default Screen
  defaultScreen(){
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add Food Items"),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green,
                    Colors.greenAccent,
                  ],
                  begin: FractionalOffset(0.0,0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                )
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black54,),
            onPressed: ()
            {
              Navigator.push(context, MaterialPageRoute(builder: (c)=>const HomeScreen()));
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
                begin: FractionalOffset(0.0,0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_shopping_cart, color: Colors.orange, size: 200,),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.orangeAccent),
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
                    "Add Food Item Image",
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