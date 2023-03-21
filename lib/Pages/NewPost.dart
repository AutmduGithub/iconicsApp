// ignore_for_file: file_names, depend_on_referenced_packages, non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../resource/MediaTypeChooser.dart';
import '../resource/VideoContainer.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  String Filename = "";
  final desccontroller = TextEditingController();
  late FilePickerResult selected_file;
  bool error = false;
  late String clubname;
  Dio dio = Dio();
  void setpreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    clubname = preferences.getString("club_name")!;
  }

  @override
  void initState() {
    super.initState();
    setpreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Post"),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 300.0,
                  child: Card(
                    elevation: 10.0,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.cloud_upload,
                            ),
                            onPressed: () async {
                              selected_file =
                                  (await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ['jpg', 'png', 'mp4'],
                                //allowed extension to choose
                              ))!;
                              setState(() {
                                Filename = selected_file.files.single.path!;
                              });
                            },
                            iconSize: 150,
                          ),
                          const Text("Click To Upload File")
                        ]),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 300,
                  child: Card(
                    child: Filename == ""
                        ? const Center(
                            child: Text("Image Preview"),
                          )
                        : MediaTypeChooser.ChooseMedia(Filename) == "photo"
                            ? Image(
                                image: FileImage(File(Filename)),
                              )
                            : LocalVideo(path: Filename),
                  ),
                ),
              ],
            ),
            TextField(
              onTap: () {
                setState(() {
                  error = false;
                });
              },
              keyboardType: TextInputType.text,
              controller: desccontroller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Description",
                errorText: error == true ? "Add Description Content" : null,
              ),
            ),
            const SizedBox(
              height: 50.0,
            ),
          ],
        ),
      ),
      bottomSheet: SizedBox(
        height: 45.0,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () async {
            FocusScope.of(context).unfocus();
            if (desccontroller.text != "" && Filename != "") {
              var posturl = "https://cseassociation.autmdu.in/api/newpost.php";
              FormData data = FormData.fromMap({
                "image": await MultipartFile.fromFile(Filename,
                    filename: basename(Filename)),
                "club_name": clubname,
                "description": desccontroller.text
              });
              EasyLoading.show(status: 'Loading....');
              var response = await dio
                  .post(
                    posturl,
                    data: data,
                  )
                  .then((value) => {
                        EasyLoading.showSuccess("Uploaded"),
                        Future.delayed(const Duration(milliseconds: 200), () {
                          EasyLoading.dismiss(animation: true);
                          setState(() {
                            desccontroller.clear();
                            Filename = "";
                          });
                          Navigator.of(context).pop();
                        })
                      });
            } else {
              setState(() {
                error = true;
              });
            }
          },
          child: const Text("Post"),
        ),
      ),
    );
  }
}
