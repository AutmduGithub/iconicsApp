// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconics_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Register.dart';

Future<void> main() async {
  runApp(const LoginApp());
}

class LoginApp extends StatefulWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  State<LoginApp> createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginContent(),
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      routes: {
        '/home': (context) => const MainActivity(),
      },
    );
  }
}

class LoginContent extends StatefulWidget {
  const LoginContent({Key? key}) : super(key: key);

  @override
  State<LoginContent> createState() => _LoginContentState();
}

class _LoginContentState extends State<LoginContent> {
  final mailcontroller = TextEditingController();
  final pwdcontroller = TextEditingController();
  var showpass = true;
  var chkval = false;

  @override
  Widget build(BuildContext context) {
    Future login(String userName, password) async {
      final fcmToken = await FirebaseMessaging.instance.getToken(
          vapidKey:
              "BJTobJqXZoQTZfjJocSfcPX4znee7eN6S9ZpBYlFF9tb4Rd08q2BgeSdf0-6BWG8DMQyobq5REZ6gQdX6XyXG0g");
      var requestUrl =
          Uri.parse("https://cseassociation.autmdu.in/api/login.php");
      var response = await http.post(requestUrl,
          body: {'username': userName, 'pwd': password, 'api_key': fcmToken});
      var resResult = json.decode(response.body);
      if (resResult == "nodatafound") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Alert"),
                content: const Text("user not found"),
                actions: [
                  ElevatedButton(
                    child: const Text("ok"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            });
      } else {
        var resMap = jsonDecode(response.body);
        for (var singledetail in resMap) {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString("user_id", singledetail["admin_id"] ?? '');
          preferences.setString("user_name", singledetail["name"]!);
          preferences.setString("club_name", singledetail["club_name"] ?? '');
          preferences.setString("admin_level", singledetail["admin_level"]!);
          preferences.setString("image", singledetail["image"]!);
          preferences.setString("logintoken", singledetail["password"]!);
          preferences.setString("email", singledetail["email"]!);
          preferences.setString("year", singledetail["year"] ?? '');
          preferences.setString("dept", singledetail["department"] ?? '');
          preferences.setString("clgname", singledetail["college_name"] ?? '');
        }
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
          child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100.0,
                  child: Image(
                    image: NetworkImage(
                        "https://cseassociation.autmdu.in/res/logos/iconics.png"),
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: mailcontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  obscureText: showpass == true ? true : false,
                  controller: pwdcontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  children: [
                    Checkbox(
                        checkColor: Colors.lightBlue,
                        value: chkval,
                        onChanged: (value) => {
                              setState(() {
                                if (chkval == false && value == true) {
                                  showpass = false;
                                  chkval = true;
                                } else {
                                  showpass = true;
                                  chkval = false;
                                }
                              }),
                            }),
                    const Text("Show Password"),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      child: const Text("login"),
                      onPressed: () => {
                        if (mailcontroller.text != "" &&
                            pwdcontroller.text != "")
                          {login(mailcontroller.text, pwdcontroller.text)}
                        else
                          {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Alert"),
                                    content: const Text("Fill The Details"),
                                    actions: [
                                      ElevatedButton(
                                        child: const Text("ok"),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  );
                                })
                          }
                      },
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    ElevatedButton(
                      child: const Text("Register"),
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterApp()))
                      },
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
