// ignore_for_file: non_constant_identifier_names, file_names, library_prefixes, unnecessary_null_comparison

import 'dart:convert';

import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as client;
import 'package:iconics_app/resource/SocketChooser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../Security/EncryptDecrypt.dart';
import '../models/MessageModel.dart';
import '../resource/ClubName.dart';
import '../resource/bubble.dart';

class PersonalChat extends StatefulWidget {
  final String clubName;
  const PersonalChat({Key? key, required this.clubName})
      : super(key: key);

  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  String Name = "";
  final scrollController = ScrollController();
  late IO.Socket socket;
  List<MessageModel?>? messages;
  bool isLoaded = false;
  List<String> devices = [];

  scrollBottom() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), curve: Curves.easeOut);
  }

  void _getOldMessages() async {
    var url =
        Uri.parse("https://chat-api-m3ec.onrender.com/${widget.clubName}");
    var result = await client.get(url);
    messages = messageModelFromJson(result.body);
    setState(() {
      isLoaded = true;
    });
  }

  void getDevices() async {
    var url = Uri.parse("https://cseassociation.autmdu.in/api/MessageApi.php");
    var result = await client.post(url, body: {"clubname": widget.clubName});
    var res1 = json.decode(result.body);
    for (var ele in res1) {
      devices.add(ele.toString());
    }
  }

  void _connect() {
    socket = IO.io("https://chat-api-m3ec.onrender.com", {
      "transports": ['websocket'],
      "autoConnect": false
    });
    socket.connect();
    socket.onConnect((data) {
      socket.on(SocketChooser.selectSocket(widget.clubName), (msg) {
        MessageModel messageModel = MessageModel(
            fullName: msg["full_name"],
            msg: AESAlgorithm.decryptWithAES(
                "Iconics Message Private Message.", msg["msg"]),
            time: msg["time"]);
        setState(() {
          messages?.add(messageModel);
          scrollBottom();
        });
      });
    });
  }

  getName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    Name = preferences.getString("user_name")!;
  }

  @override
  void initState() {
    super.initState();
    _connect();
    _getOldMessages();
    getDevices();
    getName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${ClubNameChooser.findClub(widget.clubName)} Chat"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoaded == false
            ? const Center(
                child: Text("Loading Messages..."),
              )
            : ListView.builder(
                controller: scrollController,
                itemCount: messages == null ? 0 : (messages?.length)! + 1,
                itemBuilder: (context, index) {
                  if (index == messages?.length) {
                    return Container(height: 100.0);
                  }
                  return MyBubble(
                    text: messages?[index]?.msg ?? '',
                    sender: messages?[index]?.fullName ?? '',
                    isSender: messages?[index]?.fullName == Name
                        ? true
                        : false,
                    tail: true,
                  );
                }),
      ),
      bottomSheet: SizedBox(
        height: 80.0,
        child: MessageBar(
          onSend: (msg) {
            socket.emit("/${widget.clubName}", {
              "full_name": Name,
              "msg": AESAlgorithm.encryptWithAES(
                      "Iconics Message Private Message.", msg)
                  .base64,
              "time": DateTime.now().toString().substring(11, 16)
            });
            sendMessage(Name, msg);
            scrollBottom();
          },
        ),
      ),
    );
  }

  void sendMessage(String title, msg) async {
    var json_data = {
      "registration_ids": devices,
      "notification": {
        "body": msg,
        "title": title,
        "icon": "@drawable/splash"
      },
      "data":{
        "route":"/${widget.clubName}"
      }
    };

    var data = json.encode(json_data);
    var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    var serverKey =
        'AAAAq5K4UIE:APA91bEXeukfXIzW5-8NAaCl0pyFFbQLsmMfzeOJXPXSzgpXrSjLnCXYa9pQ7q9VdyQU-WNJyAihnpXKQJcOHDjP8xA4jQCfGXvw_g2oSc6WvMfkBpDyW5FjUjeDeXvDnvVNH2GI2Iah';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey'
    };
    var res = await client.post(url, headers: headers, body: data);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socket.close();
    socket.dispose();
    scrollController.dispose();
  }
}
