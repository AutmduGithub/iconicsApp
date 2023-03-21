// ignore_for_file: unnecessary_null_comparison, file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as client;
import 'package:iconics_app/resource/ClubImageChooser.dart';

import 'ApplyEvent.dart';

class NotificationActivity extends StatefulWidget {
  const NotificationActivity({Key? key}) : super(key: key);

  @override
  State<NotificationActivity> createState() => _NotificationActivityState();
}

Future<List> getUpcomingEvents() async {
  var reqUrl =
      Uri.parse("https://cseassociation.autmdu.in/api/getUpcomingEvents.php");
  var httpres = await client.get(reqUrl);
  var upcomingEvents = json.decode(httpres.body);
  return upcomingEvents;
}

class _NotificationActivityState extends State<NotificationActivity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upcoming Events"),
      ),
      body: FutureBuilder<List>(
        future: getUpcomingEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {}
          return snapshot.hasData
              ? EventBuilder(
                  eventCount: snapshot.data!,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}

class EventBuilder extends StatelessWidget {
  final List eventCount;
  const EventBuilder({Key? key, required this.eventCount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: eventCount == null ? 0 : eventCount.length,
        itemBuilder: (context, index) {
          return eventCount.isEmpty
              ? const Center(
                  child: Text("There is no Events!"),
                )
              : ListTile(
                  style: ListTileStyle.list,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      ClubImageChooser.findClub(eventCount[index]['club_name']),
                    ),
                  ),
                  title: Text(eventCount[index]['event_name']),
                  subtitle: Text("date:${eventCount[index]['event_date']}"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApplyEvent(
                                  eventId: eventCount[index]['event_id'],
                                )));
                  },
                );
        });
  }
}
