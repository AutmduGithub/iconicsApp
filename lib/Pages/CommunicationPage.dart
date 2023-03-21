import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../chat pages/personalChat.dart';
import '../resource/ClubImageChooser.dart';

class Communication extends StatefulWidget {
  const Communication({Key? key}) : super(key: key);

  @override
  State<Communication> createState() => _CommunicationState();
}

class _CommunicationState extends State<Communication> {
  String name = "";
  String clubName = "";
  late IO.Socket socket;

  Future<void> getPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      name = preferences.getString("user_name")!;
      clubName = preferences.getString("club_name")!;
    });
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iconics Communication"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(ClubImageChooser.findClub("")),
            ),
            title: const Text("Iconics Discussion"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PersonalChat(
                            clubName: 'discussion',
                          )));
            },
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
                  NetworkImage(ClubImageChooser.findClub(clubName)),
            ),
            title: const Text("Club Chat"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PersonalChat(
                            clubName: clubName,
                          )));
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
