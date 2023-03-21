// To parse this JSON data, do
//
//     final eventDetails = eventDetailsFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

List<EventDetails> eventDetailsFromJson(String str) => List<EventDetails>.from(
    json.decode(str).map((x) => EventDetails.fromJson(x)));

String eventDetailsToJson(List<EventDetails> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class EventDetails {
  EventDetails({
    required this.eventId,
    required this.eventName,
    required this.eventImage,
    required this.eventSDesc,
    required this.clubName,
    required this.eventDate,
    required this.eventType,
  });

  String eventId;
  String eventName;
  String eventImage;
  String eventSDesc;
  String clubName;
  DateTime eventDate;
  String eventType;

  factory EventDetails.fromJson(Map<String, dynamic> json) => EventDetails(
        eventId: json["event_id"],
        eventName: json["event_name"],
        eventImage: json["event_image"],
        eventSDesc: json["event_s_desc"],
        clubName: json["club_name"],
        eventDate: DateTime.parse(json["event_date"]),
        eventType: json["event_type"],
      );

  Map<String, dynamic> toJson() => {
        "event_id": eventId,
        "event_name": eventName,
        "event_image": eventImage,
        "event_s_desc": eventSDesc,
        "club_name": clubName,
        "event_date":
            "${eventDate.year.toString().padLeft(4, '0')}-${eventDate.month.toString().padLeft(2, '0')}-${eventDate.day.toString().padLeft(2, '0')}",
        "event_type": eventType,
      };
}
