import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences? sharedPreferences;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;

// final FirebaseAuth _authGlobal = FirebaseAuth.instance;

// late final User user = _authGlobal.currentUser!;
// late final uid = user.uid;
// // Similarly we can get email as well
// late final uemail = user.email;
