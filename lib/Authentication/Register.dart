// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconics_app/main.dart';

Future<void> main() async {
  runApp(const RegisterApp());
}

class RegisterApp extends StatefulWidget {
  const RegisterApp({Key? key}) : super(key: key);

  @override
  State<RegisterApp> createState() => _RegisterAppState();
}

class _RegisterAppState extends State<RegisterApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RegisterContent(),
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      routes: {
        '/home': (context) => const MainActivity(),
      },
    );
  }
}

class RegisterContent extends StatefulWidget {
  const RegisterContent({Key? key}) : super(key: key);

  @override
  State<RegisterContent> createState() => _RegisterContentState();
}

class _RegisterContentState extends State<RegisterContent> {
  final unamecontroller = TextEditingController();
  final mailcontroller = TextEditingController();
  final pwdcontroller = TextEditingController();
  final cnpasscontroller = TextEditingController();
  var showpass = true;
  var chkval = false;
  var mailerr = false;
  var mailerrtext = "";
  @override
  Widget build(BuildContext context) {
    void _finishAccountCreation() {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainActivity()),
        (Route<dynamic> route) => false,
      );
    }

    Future register(String userName, email, password) async {
      final token = await FirebaseMessaging.instance.getToken(
          vapidKey:
              'AAAAq5K4UIE:APA91bEXeukfXIzW5-8NAaCl0pyFFbQLsmMfzeOJXPXSzgpXrSjLnCXYa9pQ7q9VdyQU-WNJyAihnpXKQJcOHDjP8xA4jQCfGXvw_g2oSc6WvMfkBpDyW5FjUjeDeXvDnvVNH2GI2Iah');
      var requestUrl =
          Uri.parse("https://cseassociation.autmdu.in/api/register.php");
      var response = await http.post(requestUrl, body: {
        'username': userName,
        'email': email,
        'pwd': password,
        'api_key': token
      });
      var resResult = json.decode(response.body);
      if (resResult == "exists") {
        setState(() {
          mailerr = true;
          mailerrtext = "Mail Already Registered try to login!";
        });
      } else {
        // setState(() {
        //   mailerr = false;
        // });
        if (resResult == "registered") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Hurray!"),
                  content: const Text("Your Account Registered Successfully!"),
                  actions: [
                    ElevatedButton(
                      child: const Text("ok"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              }).then((value) => {
                _finishAccountCreation(),
              });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
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
                  controller: unamecontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: mailcontroller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: "Email Id",
                    errorText: mailerr ? mailerrtext : null,
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
                TextField(
                  obscureText: showpass == true ? true : false,
                  controller: cnpasscontroller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Confirm Password",
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
                ElevatedButton(
                  child: const Text("Register"),
                  onPressed: () => {
                    if (unamecontroller.text != "" &&
                        mailcontroller.text != "" &&
                        pwdcontroller.text != "" &&
                        cnpasscontroller.text != "")
                      {
                        if (pwdcontroller.text == cnpasscontroller.text)
                          {
                            register(unamecontroller.text, mailcontroller.text,
                                pwdcontroller.text)
                          }
                        else
                          {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text("Alert"),
                                    content:
                                        const Text("Password Must be Same"),
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
                      }
                    else
                      {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Alert"),
                                content: const Text("Fill all Details!"),
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
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
