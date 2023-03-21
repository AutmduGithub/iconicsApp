// ignore_for_file: file_names, prefer_typing_uninitialized_variables, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconics_app/models/ClubDetail.dart';
import 'package:intl/intl.dart';

import '../models/EventDetail.dart';
import '../models/clubMemberDetail.dart';

class HomeContent extends StatefulWidget {
  final _clubid;
  final club_name;
  const HomeContent(this._clubid, this.club_name, {Key? key}) : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  List<ClubDetails>? detail;
  List<EventDetails>? eventDetails;
  List<ClubMemberDetail>? memberdetails;
  bool isLoaded = false;
  @override
  void initState() {
    super.initState();
    getClubDetails();
  }

  Future<void> getClubDetails() async {
    var url = Uri.parse("https://cseassociation.autmdu.in/club/app.php");
    var eventurl =
        Uri.parse("https://cseassociation.autmdu.in/api/getEvents.php");
    var memberurl =
        Uri.parse("https://cseassociation.autmdu.in/api/getClubMembers.php");
    var eventResponse =
        await http.post(eventurl, body: {"q": widget.club_name});
    var response = await http.post(url, body: {"q": widget._clubid});
    var memberresponse =
        await http.post(memberurl, body: {"q": widget.club_name});

    detail = clubDetailsFromJson(response.body);
    eventDetails = eventDetailsFromJson(eventResponse.body);
    memberdetails = clubMemberDetailFromJson(memberresponse.body);

    if ((detail != null) && (eventDetails != null) && (memberdetails != null)) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoaded == false
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: detail?[0].clubName == 'Iconics'
                  ? const Text("Iconics Association")
                  : detail?[0].clubName == 'adasclub'
                      ? const Text("Ada's Club")
                      : detail?[0].clubName == 'aryabhatta'
                          ? const Text("Aryabhatta Club")
                          : detail?[0].clubName == 'iyalisainadagam'
                              ? const Text("Iyal Isai Nadagam  Club")
                              : const Text("Outreach Club"),
            ),
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: const [
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Club Events",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: eventDetails?.length,
                        (context, index) => Card(
                              margin: const EdgeInsets.all(10.0),
                              elevation: 12.0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Container(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    SizedBox(
                                      height: 30.0,
                                      child: Text(
                                        eventDetails![index].eventName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 23.0,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    SizedBox(
                                      height: 400.0,
                                      child: Image.network(
                                          "https://cseassociation.autmdu.in/res/images/event_images/${eventDetails![index].eventImage}"),
                                    ),
                                    const SizedBox(
                                      height: 19.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Event Date: ",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                        Text(DateFormat.yMMMMd().format(
                                            eventDetails![index].eventDate)),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 19.0,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Event Details: ",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                        ),
                                        Expanded(
                                            child: Text(eventDetails![index]
                                                .eventSDesc)),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                SliverToBoxAdapter(
                  child: Column(
                    children: const [
                      SizedBox(
                        height: 15.0,
                      ),
                      Text(
                        "Club Members",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                    ],
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: memberdetails?.length,
                        (context, index) => Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Card(
                                elevation: 10.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 40.0,
                                            backgroundImage: NetworkImage(
                                                "https://cseassociation.autmdu.in/res/images/member_images/${memberdetails![index].memberImage}"),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Name: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                          Text(
                                              memberdetails![index].memberName),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Position: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                          Text(memberdetails![index]
                                              .designation),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 15.0,
                                      ),
                                      Row(
                                        children: [
                                          const Text(
                                            "Contact: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.0),
                                          ),
                                          Text(memberdetails![index].mailId),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ))),
              ],
            ));
  }
}
