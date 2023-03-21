// ignore_for_file: file_names

import 'dart:convert';

List<ClubDetails> clubDetailsFromJson(String str) => List<ClubDetails>.from(json.decode(str).map((x) => ClubDetails.fromJson(x)));

String clubDetailsToJson(List<ClubDetails> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClubDetails {
  ClubDetails({
    required this.clubId,
    required this.clubName,
    required this.clubSDesc,
    required this.clubFDesc,
    required this.clubImage,
    required this.curoImage,
    required this.posterImage,
  });

  String clubId;
  String clubName;
  String clubSDesc;
  String clubFDesc;
  String clubImage;
  String curoImage;
  String posterImage;

  factory ClubDetails.fromJson(Map<String, dynamic> json) => ClubDetails(
    clubId: json["club_id"],
    clubName: json["club_name"],
    clubSDesc: json["club_s_desc"],
    clubFDesc: json["club_f_desc"],
    clubImage: json["club_image"],
    curoImage: json["curo_image"],
    posterImage: json["poster_image"],
  );

  Map<String, dynamic> toJson() => {
    "club_id": clubId,
    "club_name": clubName,
    "club_s_desc": clubSDesc,
    "club_f_desc": clubFDesc,
    "club_image": clubImage,
    "curo_image": curoImage,
    "poster_image": posterImage,
  };
}
