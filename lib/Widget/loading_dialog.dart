
import 'package:eco_healing/Widget/progress_bar.dart';
import 'package:flutter/material.dart';
class LoadDialog extends StatelessWidget {
  //const ErrorDialog({Key? key}) : super(key: key);
  final String? message;
  LoadDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
       mainAxisSize: MainAxisSize.min,
        children:[
          circularProgress(),
          SizedBox(height: 10,),
          Text(message!+", Please wait..."),
        ],
      ),
    );
  }
}
