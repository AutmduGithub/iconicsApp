import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iconics_app/Authentication/login.dart';
import 'package:iconics_app/HomePages/Home.dart';
import 'package:iconics_app/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainActivity());
}

class MainActivity extends StatelessWidget {
  const MainActivity({Key? key}) : super(key: key);

  Future<Object?> _checkLogin() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final token = preferences.get("logintoken");
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      home: FutureBuilder(
        future: _checkLogin(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return const MyHomePage();
          } else {
            return const LoginApp();
          }
        },
      ),
    );
  }
}
