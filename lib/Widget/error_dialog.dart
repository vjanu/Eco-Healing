
import 'package:flutter/material.dart';
class ErrorDialog extends StatelessWidget {
  //const ErrorDialog({Key? key}) : super(key: key);
 final String? message;
 ErrorDialog({this.message});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        key: key,
        content: Text(message!),
        actions:[
          ElevatedButton(
              child: const Center(
                child:Text('Ok!'),
              ),
            style: ElevatedButton.styleFrom(
              primary: Colors.red,
            ),
            onPressed: ()
            {
              Navigator.pop(context);
            },
          ),
        ],
    );
  }
}
