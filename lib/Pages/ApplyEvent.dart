// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as client;
import 'package:iconics_app/resource/ClubImageChooser.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/EventDetail.dart';
import 'ApplyInterEvent.dart';

class ApplyEvent extends StatefulWidget {
  final String eventId;
  const ApplyEvent({Key? key, required this.eventId}) : super(key: key);

  @override
  State<ApplyEvent> createState() => _ApplyEventState();
}

class _ApplyEventState extends State<ApplyEvent> {
  late List<EventDetails> events;
  bool isLoaded = false;
  bool isChecked = false;
  Future<void> getDetails() async {
    var reqUrl =
        Uri.parse("https://cseassociation.autmdu.in/api/getEventById.php");
    await client.post(reqUrl, body: {"id": widget.eventId}).then((value) => {
          setState(() {
            events = eventDetailsFromJson(value.body);
            isLoaded = true;
          })
        });
  }

  Future<void> _applyEvent() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var reqUrl =
        Uri.parse("https://cseassociation.autmdu.in/api/applyEvent.php");
    if (preferences.getString("year") != "" &&
        preferences.containsKey("dept") != false) {
      if (events[0].eventType == "intra") {
        EasyLoading.show(status: "Loading...");
        await client.post(reqUrl, body: {
          "Name": preferences.getString("user_name"),
          "MailID": preferences.getString("email"),
          "Year": preferences.getString("year"),
          "Department": preferences.getString("dept"),
          "EventId": widget.eventId,
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
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ApplyInterEvent(eventId: events[0].eventId),
          ),
        );
      }
    } else {
      Fluttertoast.showToast(
        msg:
            "Go To Myaccount on Home Page and Set Value for Year and Department",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        fontSize: 16.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded == false
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  ClubImageChooser.findClub(events[0].clubName),
                ),
              ),
              title: Text(events[0].eventName),
            ),
            body: ListView(
              padding: const EdgeInsets.all(15.0),
              children: [
                SizedBox(
                  height: 500.0,
                  child: Image(
                    image: NetworkImage(events[0].eventImage),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    const Text(
                      "Event Date:",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(DateFormat.yMMMMd().format(events[0].eventDate))
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Row(
                  children: [
                    const Text(
                      "About The Event:",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(child: Text(events[0].eventSDesc)),
                  ],
                ),
              ],
            ),
            bottomSheet: SizedBox(
              width: double.infinity,
              height: events[0].eventType == "intra" ? 88.0 : 40.0,
              child: Column(
                children: [
                  events[0].eventType == "intra"
                      ? SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isChecked == true) {
                                  isChecked = false;
                                } else {
                                  isChecked = true;
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Checkbox(
                                    value: isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        if (isChecked == true) {
                                          isChecked = false;
                                        } else {
                                          isChecked = true;
                                        }
                                      });
                                    }),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                const Text("Yes! Iam AURCM Student"),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: events[0].eventType == "intra" &&
                              isChecked == true
                          ? _applyEvent
                          : events[0].eventType == 'inter' && isChecked == false
                              ? _applyEvent
                              : null,
                      child: const Text("Apply"),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
