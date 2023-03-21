// To parse this JSON data, do
//
//     final clubMemberDetail = clubMemberDetailFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

List<ClubMemberDetail> clubMemberDetailFromJson(String str) =>
    List<ClubMemberDetail>.from(
        json.decode(str).map((x) => ClubMemberDetail.fromJson(x)));

String clubMemberDetailToJson(List<ClubMemberDetail> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ClubMemberDetail {
  ClubMemberDetail({
    required this.memberName,
    required this.designation,
    required this.mailId,
    required this.memberImage,
  });

  String memberName;
  String designation;
  String mailId;
  String memberImage;

  factory ClubMemberDetail.fromJson(Map<String, dynamic> json) =>
      ClubMemberDetail(
        memberName: json["member_name"],
        designation: json["designation"],
        mailId: json["mail_id"],
        memberImage: json["member_image"],
      );

  Map<String, dynamic> toJson() => {
        "member_name": memberName,
        "designation": designation,
        "mail_id": mailId,
        "member_image": memberImage,
      };
}
