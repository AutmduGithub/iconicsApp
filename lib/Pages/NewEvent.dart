// ignore_for_file: depend_on_referenced_packages, prefer_typing_uninitialized_variables, use_build_context_synchronously, file_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewEvent extends StatefulWidget {
  const NewEvent({Key? key}) : super(key: key);

  @override
  State<NewEvent> createState() => _NewEventState();
}

class _NewEventState extends State<NewEvent> {
  final eventName = TextEditingController();
  final eventDate = TextEditingController();
  final eventDesc = TextEditingController();
  late String eventType = "";
  String posterFileName = "";
  String lines = "";
  var filePickerFile;
  bool namerr = false;
  bool dateerr = false;
  bool descerr = false;
  var eventDio = Dio();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Event"),
      ),
      body: Container(
        padding: const EdgeInsets.all(15.0),
        child: ListView(
          children: [
            const SizedBox(
              height: 15.0,
            ),
            TextField(
              controller: eventName,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Event Name",
                errorText: namerr == true ? "Name Can't Be Empty" : null,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            TextField(
              controller: eventDate,
              keyboardType: TextInputType.datetime,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: "Event Date",
                hintText: "YYYY-MM-DD",
                errorText: dateerr == true ? "Email Can't Be Empty" : null,
              ),
            ),
            RadioListTile(
                title: const Text("Inter College"),
                value: "inter",
                groupValue: eventType,
                onChanged: (value) {
                  setState(() {
                    eventType = value.toString();
                  });
                }),
            RadioListTile(
                title: const Text("Intra College"),
                value: "intra",
                groupValue: eventType,
                onChanged: (value) {
                  setState(() {
                    eventType = value.toString();
                  });
                }),
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
                          filePickerFile = (await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'png', 'mp4'],
                            //allowed extension to choose
                          ))!;
                          setState(() {
                            posterFileName = filePickerFile.files.single.path!;
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
                  child: posterFileName == ""
                      ? const Center(
                          child: Text("Image Preview"),
                        )
                      : Image(
                          image: FileImage(File(posterFileName)),
                        )),
            ),
            SizedBox(
              height: 150.0,
              child: TextFormField(
                minLines: 5,
                maxLines: 10,
                controller: eventDesc,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Event Description",
                  errorText:
                      descerr == false ? null : "Description can't be empty",
                ),
                onChanged: (val) {
                  setState(() {
                    lines = (990 - val.length).toString();
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [Text("$lines Characters left")],
            )
          ],
        ),
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        height: 40.0,
        child: ElevatedButton(
          onPressed: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            FocusScope.of(context).unfocus();
            if (eventDesc.text != "" &&
                posterFileName != "" &&
                eventName.text != "" &&
                eventDate.text != "" &&
                eventType != "") {
              var posturl = "https://cseassociation.autmdu.in/api/newEvent.php";
              FormData data = FormData.fromMap({
                "image": await MultipartFile.fromFile(posterFileName,
                    filename: basename(posterFileName)),
                "club_name": preferences.getString("club_name"),
                "description": eventDesc.text,
                "event_date": eventDate.text,
                "event_name": eventName.text,
                "event_type": eventType,
              });
              EasyLoading.show(status: 'Loading....', dismissOnTap: true);
              await eventDio
                  .post(
                    posturl,
                    data: data,
                  )
                  .then((value) => {
                        EasyLoading.showSuccess("Uploaded"),
                        setState(() {
                          eventName.clear();
                          eventDate.clear();
                          eventDesc.clear();
                          eventType = "";
                          posterFileName = "";
                        }),
                      });
            } else {
              if (eventName.text == "") {
                setState(() {
                  namerr = true;
                });
              }
              if (eventDate.text == "") {
                setState(() {
                  dateerr = true;
                });
              }
              if (eventDesc.text == "") {
                setState(() {
                  descerr = true;
                });
              }
              if (eventType == "") {
                Fluttertoast.showToast(msg: "Select Event Type");
              }
              if (posterFileName == "") {
                Fluttertoast.showToast(msg: "Select Event Poster");
              }
            }
          },
          child: const Text("Upload"),
        ),
      ),
    );
  }
}
