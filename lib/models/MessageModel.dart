// To parse this JSON data, do
//
//     final messageModel = messageModelFromJson(jsonString);

import 'dart:convert';

import '../Security/EncryptDecrypt.dart';

List<MessageModel?>? messageModelFromJson(String str) =>
    json.decode(str) == null
        ? []
        : List<MessageModel?>.from(
            json.decode(str)!.map((x) => MessageModel.fromJson(x)));

String messageModelToJson(List<MessageModel?>? data) => json.encode(
    data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())));

class MessageModel {
  MessageModel({
    this.fullName,
    this.msg,
    this.time,
  });

  String? fullName;
  String? msg;
  String? time;

  factory MessageModel.fromJson(Map<String, dynamic> json) => MessageModel(
        fullName: json["full_name"],
        msg: AESAlgorithm.decryptWithAES(
            "Iconics Message Private Message.", json["msg"]),
        time: json["time"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "msg": msg,
        "time": time,
      };
}
