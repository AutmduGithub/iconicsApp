// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, file_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as client;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  late String image;
  late String name;
  late String email;
  late String year;
  late String dept;
  late String clg;
  late var myAccountNameController;
  late var myAccountEmailController;
  late var myAccountYearController;
  late var myAccountDeptController;
  late var myAccountCollegeController;
  var myAccountSelectedFile;
  var fileName = "";
  bool loading = false;
  bool nameerr = false;
  bool mailerr = false;
  bool yrerr = false;
  bool depterr = false;
  bool clgerr = false;
  final updatedio = Dio();

  Future<void> _setPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    image = preferences.getString("image")!;
    name = preferences.getString("user_name")!;
    email = preferences.getString("email")!;
    year = preferences.getString("year")!;
    dept = preferences.getString("dept")!;
    clg = preferences.getString("clgname")!;
    myAccountNameController = TextEditingController(text: name);
    myAccountEmailController = TextEditingController(text: email);
    myAccountYearController = TextEditingController(text: year);
    myAccountDeptController = TextEditingController(text: dept);
    myAccountCollegeController = TextEditingController(text: clg);
    if (myAccountEmailController.text != "") {
      setState(() {
        loading = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _setPreferences();
  }

  Future<void> _updateDetails(String name, mail, year, dept, clg) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var posturl = "https://cseassociation.autmdu.in/api/updateProfile.php";
    var requrl =
        Uri.parse("https://cseassociation.autmdu.in/api/updateProfile.php");
    if (fileName != "") {
      FormData userData = FormData.fromMap({
        "image": await MultipartFile.fromFile(fileName,
            filename: basename(fileName)),
        "name": name,
        "email": mail,
        "yr": year,
        "dept": dept,
        "clgname": clg,
        "admin_id": preferences.getString("user_id"),
      });
      EasyLoading.show(status: "Updating...");
      await updatedio
          .post(
            posturl,
            data: userData,
          )
          .then((value) => {
                preferences.setString("user_name", name),
                preferences.setString("image", basename(fileName)),
                preferences.setString("email", mail),
                preferences.setString("year", year),
                preferences.setString("dept", dept),
                preferences.setString("clgname", clg),
                EasyLoading.showSuccess("Uploaded"),
              });
    } else {
      EasyLoading.show(status: "Updating...", dismissOnTap: true);
      await client.post(requrl, body: {
        "name": name,
        "email": mail,
        "yr": year,
        "dept": dept,
        "clgname": clg,
        "admin_id": preferences.getString("user_id"),
      }).then((value) {
        EasyLoading.showSuccess("updated");
        preferences.setString("user_name", name);
        preferences.setString("email", mail);
        preferences.setString("year", year);
        preferences.setString("dept", dept);
        preferences.setString("clgname", clg);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyAccount"),
      ),
      body: loading == false
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  GestureDetector(
                    onTap: () async {
                      myAccountSelectedFile =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'png'],
                        //allowed extension to choose
                      );
                      setState(() {
                        fileName = myAccountSelectedFile.files.single.path!;
                      });
                    },
                    child: SizedBox(
                      width: double.infinity,
                      height: 120.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 100.0,
                              height: 100.0,
                              child: Stack(
                                children: [
                                  ClipOval(
                                    child: fileName != ""
                                        ? Image.file(File(fileName))
                                        : Image.network(
                                            "https://cseassociation.autmdu.in/res/images/member_images/$image"),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Container(
                                      width: 30.0,
                                      height: 30.0,
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                      child: const Icon(
                                        Icons.camera_alt,
                                        color: Colors.white,
                                        size: 18.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: myAccountNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Name",
                      errorText: nameerr == true ? "Name Can't Be Empty" : null,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: myAccountEmailController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Email",
                      errorText:
                          mailerr == true ? "Email Can't Be Empty" : null,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: myAccountYearController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Year",
                      errorText: yrerr == true ? "Year Can't Be Empty" : null,
                    ),
                  ),
                  const SizedBox(
                    height: 15.0,
                  ),
                  TextField(
                    controller: myAccountDeptController,
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
                    controller: myAccountCollegeController,
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
            if (myAccountNameController.text != "") {
              if (myAccountEmailController.text != "") {
                if (myAccountYearController.text != "") {
                  if (myAccountDeptController.text != "") {
                    if (myAccountCollegeController.text != "") {
                      _updateDetails(
                          myAccountNameController.text,
                          myAccountEmailController.text,
                          myAccountYearController.text,
                          myAccountDeptController.text,
                          myAccountCollegeController.text);
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
                    yrerr = true;
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
          child: const Text("Submit"),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    myAccountNameController.dispose();
    myAccountEmailController.dispose();
    myAccountYearController.dispose();
    myAccountDeptController.dispose();
    myAccountCollegeController.dispose();
  }
}
