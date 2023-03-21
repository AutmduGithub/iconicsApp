import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as client;
import 'package:iconics_app/Pages/NewEvent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'EventViewer.dart';

class MyEvents extends StatefulWidget {
  const MyEvents({Key? key}) : super(key: key);

  @override
  State<MyEvents> createState() => _MyEventsState();
}

class _MyEventsState extends State<MyEvents> {
  Future getEvents() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? clubName = preferences.getString("club_name");
    var url = Uri.parse("https://cseassociation.autmdu.in/api/getEvents.php");
    var response = await client.post(url, body: {"q": clubName});
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Club Events"),
      ),
      body: FutureBuilder(
        future: getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          return snapshot.hasData
              ? BuildEvent(events: snapshot.data!)
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NewEvent()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class BuildEvent extends StatefulWidget {
  final List events;
  const BuildEvent({Key? key, required this.events}) : super(key: key);

  @override
  State<BuildEvent> createState() => _BuildEventState();
}

class _BuildEventState extends State<BuildEvent> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget.events.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(
                widget.events[index]["event_name"].toString().substring(0, 1),
              ),
            ),
            title: Text(widget.events[index]["event_name"]),
            subtitle: Text(widget.events[index]["event_date"].toString()),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => EventViewer(
                          eventId: widget.events[index]["event_id"])));
            },
            trailing: IconButton(
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Warning!"),
                          content: const Text("Are you sure to delete event"),
                          actions: [
                            ElevatedButton(
                                onPressed: () async {
                                  var requrl = Uri.parse(
                                      "https://cseassociation.autmdu.in/api/deleteEvent.php");
                                  var response = await client.post(requrl,
                                      body: {
                                        "id": widget.events[index]["event_id"]
                                      });
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                  setState(() {
                                    widget.events.removeAt(index);
                                  });
                                },
                                child: const Text("Ok")),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"))
                          ],
                        );
                      });
                },
                icon: const Icon(Icons.delete)),
          );
        });
  }
}
