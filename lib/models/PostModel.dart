import 'dart:convert';

List<Posts> postsFromJson(String str) =>
    List<Posts>.from(json.decode(str).map((x) => Posts.fromJson(x)));

String postsToJson(List<Posts> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Posts {
  Posts({
    required this.postId,
    required this.clubName,
    required this.imagePath,
    required this.description,
    required this.postDate,
  });

  String postId;
  String clubName;
  String imagePath;
  String description;
  DateTime postDate;

  factory Posts.fromJson(Map<String, dynamic> json) => Posts(
        postId: json["post_id"],
        clubName: json["club_name"],
        imagePath: json["image_path"],
        description: json["description"],
        postDate: DateTime.parse(json["post_date"]),
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "club_name": clubName,
        "image_path": imagePath,
        "description": description,
        "post_date":
            "${postDate.year.toString().padLeft(4, '0')}-${postDate.month.toString().padLeft(2, '0')}-${postDate.day.toString().padLeft(2, '0')}",
      };
}
