// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison, file_names, unrelated_type_equality_checks
import 'dart:convert';

import 'package:badges/badges.dart' as badges;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:iconics_app/HomePages/ClubHome.dart';
import 'package:iconics_app/Pages/EventsPage.dart';
import 'package:iconics_app/Pages/Notifications.dart';
import 'package:iconics_app/Pages/PostsPage.dart';
import 'package:iconics_app/chat%20pages/personalChat.dart';
import 'package:iconics_app/resource/ClubImageChooser.dart';
import 'package:iconics_app/resource/MediaTypeChooser.dart';
import 'package:iconics_app/resource/VideoContainer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Pages/CommunicationPage.dart';
import '../Pages/MyAccount.dart';
import '../main.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'iconics',
  'flutter_iconics_App',
  importance: Importance.high,
  playSound: true,
);

Future onDidReceiveLocalNotification(
    int id, String? title, String? body, String? payload) async {
  // display a dialog with the notification details, tap ok to go to another page
  var context;
  showDialog(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title!),
      content: Text(body!),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          child: const Text('Ok'),
          onPressed: () async {},
        )
      ],
    ),
  );
}

final FlutterLocalNotificationsPlugin plugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  RemoteNotification? notification = message.notification;
  AndroidNotification? androidNotification = message.notification?.android;
  if (notification != null && androidNotification != null) {
    plugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          playSound: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: message.data["route"].toString(),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyHomePage());
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<List> getClubs() async {
  var url = Uri.parse("https://cseassociation.autmdu.in/api/getClubs.php");
  final res = await http.get(url);
  var receivedData = json.decode(res.body);
  return receivedData;
}

Future<List> getPosts() async {
  var url = Uri.parse("https://cseassociation.autmdu.in/api/getPosts.php");
  final res = await http.get(url);
  var receivedData = json.decode(res.body);
  return receivedData;
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Home(),
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      routes: {
        '/main': (context) => const MainActivity(),
        '/adasclub': (context) => const PersonalChat(clubName: "adasclub"),
        '/aryabhatta': (context) => const PersonalChat(clubName: "aryabhatta"),
        '/iyalisainadagam': (context) =>
            const PersonalChat(clubName: "iyalisainadagam"),
        '/outreach': (context) => const PersonalChat(clubName: "outreach"),
        '/iconics': (context) => const PersonalChat(clubName: "iconics"),
        '/discussion': (context) => const PersonalChat(clubName: "discussion"),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String image = "";
  String name = "";
  String email = "";
  String adminLevel = "";
  int bottomIndex = 0;
  String clubName = "";
  late String eventCount = "";
  // ignore: prefer_typing_uninitialized_variables
  var listener;
  final tabs = [const CluBuilder(), const PostBuilder()];

  Future<void> logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/main', (Route<dynamic> route) => false);
  }

  Future<void> getPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString("email")!;
      image = preferences.getString("image")!;
      name = preferences.getString("user_name")!;
      adminLevel = preferences.getString("admin_level")!;
      clubName = preferences.getString("club_name")!;
    });
  }

  Future<void> getEventCount() async {
    var reqUrl = Uri.parse(
        "https://cseassociation.autmdu.in/api/CountUpcomingEvents.php");
    await http.get(reqUrl).then((value) => {
          setState(() {
            eventCount = json.decode(value.body).toString();
          })
        });
  }

  Future pluginInit() async {
    await plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  @override
  void initState() {
    super.initState();
    getPrefs();
    getEventCount();
    pluginInit();
    // listener = InternetConnectionChecker().onStatusChange.listen((status) {
    //   switch (status) {
    //     case InternetConnectionStatus.connected:
    //       Fluttertoast.showToast(
    //           msg: "Internet Connected",
    //           toastLength: Toast.LENGTH_LONG,
    //           gravity: ToastGravity.BOTTOM,
    //           timeInSecForIosWeb: 1,
    //           backgroundColor: Colors.green,
    //           textColor: Colors.white,
    //           fontSize: 16.0);
    //       Navigator.pushAndRemoveUntil(
    //         context,
    //         MaterialPageRoute(builder: (context) => const MyHomePage()),
    //         (Route<dynamic> route) => false,
    //       );
    //       break;
    //     case InternetConnectionStatus.disconnected:
    //       Fluttertoast.showToast(
    //         msg: "Connection Lost",
    //         toastLength: Toast.LENGTH_LONG,
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.red,
    //         textColor: Colors.white,
    //         fontSize: 16.0,
    //       );
    //       break;
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iconics'),
        actions: [
          Container(
            padding: const EdgeInsets.only(right: 20.0, top: 15.0),
            child: badges.Badge(
              badgeContent: Text(
                eventCount == "null" ? "0" : eventCount,
                style: const TextStyle(color: Colors.white),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const NotificationActivity()));
                },
                icon: const Icon(Icons.notifications, size: 25.0),
                tooltip: "Upcoming Events",
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        elevation: 10.0,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://cseassociation.autmdu.in/res/images/member_images/$image",
                ),
              ),
              accountName: Text(name),
              accountEmail: Text(email),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle_outlined),
              title: const Text("My Account"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const MyAccount()));
              },
            ),
            adminLevel != 5
                ? ListTile(
                    leading: const Icon(Icons.message),
                    title: const Text("Chat"),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Communication()));
                    },
                  )
                : Container(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                logout();
              },
            )
          ],
        ),
      ),
      body: tabs[bottomIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: bottomIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Clubs",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Social Media",
          )
        ],
        onTap: (currentIndex) {
          setState(() {
            bottomIndex = currentIndex;
          });
        },
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: adminLevel != "5"
          ? ExpandableFab(
              distance: 70.0,
              type: ExpandableFabType.up,
              child: const Icon(Icons.add),
              overlayStyle: ExpandableFabOverlayStyle(
                blur: 5,
              ),
              children: [
                FloatingActionButton(
                  heroTag: "btn1",
                  child: const Icon(Icons.calendar_month_outlined),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyEvents()));
                  },
                ),
                FloatingActionButton(
                  heroTag: "btn2",
                  child: const Icon(Icons.add_comment_rounded),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ManagePosts()));
                  },
                ),
                adminLevel == "0"
                    ? FloatingActionButton(
                        heroTag: "btn3",
                        child: const Icon(Icons.group_add),
                        onPressed: () {},
                      )
                    : Container(),
              ],
            )
          : Container(),
    );
  }

  @override
  void dispose() {
    listener.cancel();
    super.dispose();
  }
}

class ClubList extends StatefulWidget {
  const ClubList({Key? key, required this.returnedList}) : super(key: key);
  final List returnedList;

  @override
  State<ClubList> createState() => _ClubListState();
}

class _ClubListState extends State<ClubList> {
  @override
  Widget build(BuildContext context) {
    void changeroute(String routename, clubid) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => HomeContent(clubid, routename)));
    }

    return ListView.builder(
        itemCount: widget.returnedList == null ? 0 : widget.returnedList.length,
        itemBuilder: (context, i) {
          return InkWell(
            onTap: () {
              changeroute(widget.returnedList[i]['club_name'],
                  widget.returnedList[i]['club_id']);
            },
            child: Card(
              elevation: 12.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              child: SizedBox(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 30.0,
                    ),
                    SizedBox(
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: NetworkImage(
                            "https://cseassociation.autmdu.in/res/logos/${widget.returnedList[i]['club_image']}"),
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        widget.returnedList[i]['club_s_desc'],
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class CluBuilder extends StatelessWidget {
  const CluBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: getClubs(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {}
          return snapshot.hasData
              ? ClubList(
                  returnedList: snapshot.data!,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
}

class PostBuilder extends StatelessWidget {
  const PostBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List>(
        future: getPosts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {}
          return snapshot.hasData
              ? PostList(
                  posts: snapshot.data!,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                );
        });
  }
}

class PostList extends StatelessWidget {
  final List posts;
  const PostList({Key? key, required this.posts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: posts == null ? 0 : posts.length,
      itemBuilder: (context, i) {
        return Card(
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(ClubImageChooser.findClub(
                          posts[i]["club_name"].toString())),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text(
                      posts[i]["club_name"] == "adasclub"
                          ? "Ada's Club"
                          : posts[i]["Club_name"] == "aryabhatta"
                              ? "Aryabhatta Club"
                              : posts[i]["club_name"] == "iyalisainadagam"
                                  ? "Iyal Isai Nadagam Club"
                                  : posts[i]["club_name"] == "Iconics"
                                      ? "ICONICS Association"
                                      : "Outreach Club",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  height: 400.0,
                  child: MediaTypeChooser.ChooseMedia(posts[i]["image_path"]) ==
                          "photo"
                      ? Image(image: NetworkImage(posts[i]["image_path"]))
                      : Video(videoLink: posts[i]["image_path"]),
                ),
                const SizedBox(
                  height: 5.0,
                ),
                Row(
                  children: [
                    Text(
                      posts[i]["club_name"] == "adasclub"
                          ? "Ada's Club"
                          : posts[i]["Club_name"] == "aryabhatta"
                              ? "Aryabhatta Club"
                              : posts[i]["club_name"] == "iyalisainadagam"
                                  ? "Iyal Isai Nadagam Club"
                                  : posts[i]["club_name"] == "Iconics"
                                      ? "ICONICS Association"
                                      : "Outreach Club",
                      style: const TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Text("${posts[i]["description"]}"),
                  ],
                ),
                const SizedBox(
                  height: 5.0,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
