import 'package:eco_healing/auth/login.dart';
import 'package:eco_healing/global/global.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final auth = FirebaseAuth.instance;
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future passwordreset() async {
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      final text = "The mail has been sent to provided email address";
      final snackbar = SnackBar(
        content: Text(text),
        // action: SnackBarAction(
        //   label: 'Dismiss',
        //   onPressed: () {
        //     Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => login_page(),
        //         ));
        //   },
        // ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      print(e);
      final text = e.message.toString();
      final snackbar = SnackBar(
        content: Text(text),
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {
            emailController.clear();
          },
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        title: Text('Reset Password'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 22.0),
            child: Text(
              "Enter your email and we will end you a password reset link",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 20),
            ),
          ),
          SizedBox(height: 10),

          //email textfield
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: emailController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purpleAccent),
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'E-mail',
                  fillColor: Colors.grey[200],
                  filled: true),
            ),
          ),
          SizedBox(height: 10),
          MaterialButton(
            onPressed: () => passwordreset(),
            child: const Text('Reset Password'),
            color: Colors.green,
          ),
        ],
      ),
    );
  }
}
