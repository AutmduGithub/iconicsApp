import 'package:flutter/material.dart';
import 'package:http/http.dart' as client;
import 'package:iconics_app/Pages/NewPost.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/PostModel.dart';

class ManagePosts extends StatefulWidget {
  const ManagePosts({Key? key}) : super(key: key);

  @override
  State<ManagePosts> createState() => _ManagePostsState();
}

class _ManagePostsState extends State<ManagePosts> {
  bool isLoaded = false;
  List<Posts> posts = [];

  getPosts() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String clubName = preferences.getString("club_name")!;
    var url =
        Uri.parse("https://cseassociation.autmdu.in/api/getPostsById.php");
    var response = await client.post(url, body: {"id": clubName});
    posts = postsFromJson(response.body);
    if (posts.isNotEmpty) {
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Posts"),
        ),
        body: isLoaded != true
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                        backgroundImage: NetworkImage(posts[index].imagePath)),
                    title: Text(posts[index].description),
                    subtitle:
                        Text(DateFormat.yMMMMd().format(posts[index].postDate)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Warning!"),
                                content:
                                    const Text("Are you sure to delete post"),
                                actions: [
                                  ElevatedButton(
                                      onPressed: () async {
                                        var requrl = Uri.parse(
                                            "https://cseassociation.autmdu.in/api/deletePost.php");
                                        var response = await client.post(requrl,
                                            body: {"id": posts[index].postId});
                                        // ignore: use_build_context_synchronously
                                        Navigator.of(context).pop();
                                        setState(() {
                                          posts.removeAt(index);
                                        });
                                      },
                                      child: const Text("Ok")),
                                  ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("Cancel"))
                                ],
                              );
                            });
                      },
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const NewPost()));
            },
            child: const Icon(Icons.add)));
  }
}
