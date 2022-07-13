import 'package:flutter/material.dart';

class Customfield extends StatelessWidget {
  //const Customfield({Key? key}) : super(key: key);

  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  bool? isObsecure = true;
  bool? enabled = true;

  Customfield({
    this.controller,
    this.data,
    this.hintText,
    this.isObsecure,
    this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.all(10),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObsecure!,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Colors.cyan,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
