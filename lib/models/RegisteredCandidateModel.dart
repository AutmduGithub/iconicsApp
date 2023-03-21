// To parse this JSON data, do
//
//     final registeredCandidates = registeredCandidatesFromJson(jsonString);

import 'dart:convert';

List<RegisteredCandidates> registeredCandidatesFromJson(String str) =>
    List<RegisteredCandidates>.from(
        json.decode(str).map((x) => RegisteredCandidates.fromJson(x)));

String registeredCandidatesToJson(List<RegisteredCandidates> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RegisteredCandidates {
  RegisteredCandidates({
    required this.applicationId,
    required this.eventId,
    required this.usrname,
    required this.mailid,
    required this.year,
    required this.department,
    required this.clgName,
  });

  String applicationId;
  String eventId;
  String usrname;
  String mailid;
  String year;
  String department;
  String clgName;

  factory RegisteredCandidates.fromJson(Map<String, dynamic> json) =>
      RegisteredCandidates(
        applicationId: json["application_id"],
        eventId: json["event_id"],
        usrname: json["usrname"],
        mailid: json["mailid"],
        year: json["year"],
        department: json["department"],
        clgName: json["clg_name"],
      );

  Map<String, dynamic> toJson() => {
        "application_id": applicationId,
        "event_id": eventId,
        "usrname": usrname,
        "mailid": mailid,
        "year": year,
        "department": department,
        "clg_name": clgName,
      };
}
