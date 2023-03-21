// ignore_for_file: prefer_typing_uninitialized_variables, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as client;
import 'package:shared_preferences/shared_preferences.dart';

class ApplyInterEvent extends StatefulWidget {
  final String eventId;
  const ApplyInterEvent({Key? key, required this.eventId}) : super(key: key);

  @override
  State<ApplyInterEvent> createState() => _ApplyInterEventState();
}

class _ApplyInterEventState extends State<ApplyInterEvent> {
  late var nameController;
  late var mailController;
  late var yearController;
  late var deptController;
  late var collegeController;

  bool nameerr = false;
  bool mailerr = false;
  bool yearerr = false;
  bool depterr = false;
  bool clgerr = false;
  bool loaded = false;
  Future<void> _setValues() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    nameController =
        TextEditingController(text: preferences.getString("user_name"));
    mailController =
        TextEditingController(text: preferences.getString("email"));
    yearController = TextEditingController(text: preferences.getString("year"));
    deptController = TextEditingController(text: preferences.getString("dept"));
    collegeController =
        TextEditingController(text: preferences.getString("clgname"));
    if (nameController.text != "") {
      setState(() {
        loaded = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setValues();
  }

  Future<void> _apply(String name, mail, year, dept, clg) async {
    EasyLoading.show(status: "loading...", dismissOnTap: true);
    var reqUrl =
        Uri.parse("https://cseassociation.autmdu.in/api/applyEvent.php");
    await client.post(reqUrl, body: {
      "EventId": widget.eventId,
      "Name": name,
      "MailID": mail,
      "Year": year,
      "Department": dept,
      "College": clg
    }).then((value) {
      if (json.decode(value.body) == "exists") {
        EasyLoading.showError("Already Applied!", dismissOnTap: true);
        Future.delayed(
          const Duration(milliseconds: 200),
          () {
            Navigator.of(context).pop();
          },
        );
      } else {
        EasyLoading.showSuccess("Applied");
        Future.delayed(
          const Duration(milliseconds: 200),
          () {
            Navigator.of(context).pop();
          },
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loaded == false
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Inter College Application"),
            ),
            body: Container(
              padding: const EdgeInsets.all(15.0),
              child: ListView(
                children: [
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: nameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Name(As Per Your Certificate)",
                      errorText: nameerr == true ? "Name Can't Be Empty" : null,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: mailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Enter Email",
                      errorText:
                          mailerr == true ? "Email Can't Be Empty" : null,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: yearController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Year",
                      errorText: yearerr == true ? "Year Can't Be Empty" : null,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: deptController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Department",
                      errorText:
                          depterr == true ? "Department Can't Be Empty" : null,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: collegeController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "College Name",
                      errorText:
                          clgerr == true ? "College Name Can't Be Empty" : null,
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: SizedBox(
              height: 40.0,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  if (nameController.text != "") {
                    if (mailController.text != "") {
                      if (yearController.text != "") {
                        if (deptController.text != "") {
                          if (collegeController.text != "") {
                            _apply(
                                nameController.text,
                                mailController.text,
                                yearController.text,
                                deptController.text,
                                collegeController.text);
                          } else {
                            setState(() {
                              clgerr = true;
                            });
                          }
                        } else {
                          setState(() {
                            depterr = true;
                          });
                        }
                      } else {
                        setState(() {
                          yearerr = true;
                        });
                      }
                    } else {
                      setState(() {
                        mailerr = true;
                      });
                    }
                  } else {
                    setState(() {
                      nameerr = true;
                    });
                  }
                },
                child: const Text("Apply"),
              ),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    mailController.dispose();
    yearController.dispose();
    deptController.dispose();
    collegeController.dispose();
  }
}
