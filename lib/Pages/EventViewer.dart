import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as client;
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/EventDetail.dart';
import '../models/RegisteredCandidateModel.dart';

class EventViewer extends StatefulWidget {
  final String eventId;
  const EventViewer({Key? key, required this.eventId}) : super(key: key);

  @override
  State<EventViewer> createState() => _EventViewerState();
}

class _EventViewerState extends State<EventViewer> {
  List<EventDetails> details = [];
  List<RegisteredCandidates> regDetails = [];
  bool isLoaded = false;
  bool sync = false;
  void getEventDetails() async {
    var reqUrl =
        Uri.parse("https://cseassociation.autmdu.in/api/getEventById.php");
    var response = await client.post(reqUrl, body: {"id": widget.eventId});
    details = eventDetailsFromJson(response.body);
    if (details.isNotEmpty) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  void getRegistrations() async {
    var reqUrl =
        Uri.parse("https://cseassociation.autmdu.in/api/getRegistration.php");
    var response = await client.post(reqUrl, body: {"id": widget.eventId});
    regDetails = registeredCandidatesFromJson(response.body);
  }

  void reload() async {
    var reqUrl =
        Uri.parse("https://cseassociation.autmdu.in/api/getRegistration.php");
    var response = await client.post(reqUrl, body: {"id": widget.eventId});
    regDetails = registeredCandidatesFromJson(response.body);
    if (regDetails.isNotEmpty) {
      setState(() {
        sync = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEventDetails();
    getRegistrations();
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded != true
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text(details[0].eventName),
              actions: [
                IconButton(
                    onPressed: sync != true
                        ? () {
                            reload();
                            setState(() {
                              sync = true;
                            });
                          }
                        : null,
                    icon: const Icon(Icons.sync))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      width: double.infinity,
                      height: 300.0,
                      child: Image(
                          image: NetworkImage(
                              "https://cseassociation.autmdu.in/res/images/event_images/${details[0].eventImage}")),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Event Date: ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        Text(DateFormat.yMMMMd().format(details[0].eventDate))
                      ],
                    ),
                  ),
                  ListTile(
                    leading: CircleAvatar(
                      child: Text(regDetails.length.toString()),
                    ),
                    title: const Text("Registrations!"),
                    trailing: IconButton(
                      onPressed: () async {
                        List registerData =
                            List<List<dynamic>>.empty(growable: true);
                        List<dynamic> row = List.empty(growable: true);
                        row.add("Application ID");
                        row.add("Name");
                        row.add("Department Name");
                        row.add("Year");
                        row.add("College Name");
                        registerData.add(row);
                        for (int i = 0; i < regDetails.length; i++) {
                          List<dynamic> row = List.empty(growable: true);
                          row.add(regDetails[i].applicationId);
                          row.add(regDetails[i].usrname);
                          row.add(regDetails[i].department);
                          row.add(regDetails[i].year);
                          row.add(regDetails[i].clgName);
                          registerData.add(row);
                        }
                        if (await Permission.manageExternalStorage
                            .request()
                            .isGranted) {
                          var dir = Directory("/storage/emulated/0/Iconics");
                          if (await dir.exists()) {
                            String csvData = const ListToCsvConverter()
                                .convert(registerData.cast<List?>());
                            File file =
                                File("${dir.path}/${details[0].eventName}.csv");
                            file.writeAsString(csvData);
                          } else {
                            dir.create();
                          }
                        } else {
                          Map<Permission, PermissionStatus> statuses = await [
                            Permission.storage,
                          ].request();
                        }
                      },
                      icon: const Icon(Icons.download),
                    ),
                  )
                ],
              ),
            ));
  }
}
