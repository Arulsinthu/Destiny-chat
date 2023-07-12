import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gvchat/helpers/database_methods.dart';
import 'package:gvchat/screens/choose_username_screen.dart';
import 'package:new_version/new_version.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';

import '../widgets/unread_messages.dart';
import './chat_screen.dart';

import '../helpers/screen_arguements.dart';
import '../widgets/search/search.dart';
import '../helpers/encrytion.dart';

class GroupScreen extends StatefulWidget {
  static const routeName = '/Groups';
  const GroupScreen({Key? key}) : super(key: key);

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  // var _enteredUsername = '';
  final user = FirebaseAuth.instance.currentUser;

  String username = '';
  String imageUrl = '';
  String email = '';
  String uid = '';

  verifyDetails() async {
    DatabaseMethods().updateTime();
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    if (!documentSnapshot.exists) {
      Navigator.of(context).popAndPushNamed(ChooseUsernameScreen.routeName);
    }
  }

  @override
  void initState() {
    //  super.initState();
    verifyDetails();

    final fbm = FirebaseMessaging.instance;
    // FirebaseAuth.instance.signOut();
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((message) {
      print(message);
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print(message);
      return;
    });
    fbm.subscribeToTopic('chat');
  }

  @override
  Widget build(BuildContext context) {
    verifyDetails();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.brown,
          child: Icon(
            Icons.add,
          ),
          onPressed: () {
            showSearch(
                context: context,
                delegate: SearchUser(isGroup: true, currentMembers: []));
          }),
      appBar: AppBar(
        backgroundColor:
            Theme.of(context).colorScheme.primary.withOpacity(0.25),
        title: Text(
          'Destiny Chat',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("group")
              .where('members', arrayContains: user!.uid)
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> groupSnapshot) {
            if (groupSnapshot.connectionState == ConnectionState.waiting ||
                !groupSnapshot.hasData) {
              return Container();
            }
            final groupDocs = groupSnapshot.data!.docs;
            return groupDocs.isEmpty
                ? Container()
                : Container(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Groups",
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: groupDocs.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                int len =
                                    groupDocs[index]['title'].toString().length;
                                return GestureDetector(
                                  onTap: () {
                                    DatabaseMethods().updateTime();
                                    Navigator.of(context).pushNamed(
                                        ChatScreen.routeName,
                                        arguments: ScreenArguments(
                                          username: groupDocs[index]['title']
                                              .toString(),
                                          chatRoomId: groupDocs[index]
                                                  ['groupId']
                                              .toString(),
                                          imageUrl:
                                              groupDocs[index]['dp'].toString(),
                                          isGroup: true,
                                        ));
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        ListTile(
                                            leading: CircleAvatar(
                                              radius: 25,
                                              backgroundImage: groupDocs[index]
                                                          ['dp']
                                                      .toString()
                                                      .isEmpty
                                                  ? AssetImage(
                                                      'assets/images/group.png',
                                                    )
                                                  : NetworkImage(
                                                          groupDocs[index]['dp']
                                                              .toString())
                                                      as ImageProvider,
                                            ),
                                            title: Text(
                                              groupDocs[index]['title']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            subtitle: Text(
                                                Encryption.decryptAES(encrypt
                                                        .Encrypted
                                                    .fromBase64(groupDocs[index]
                                                        ['latestMessage'])),
                                                style: TextStyle(
                                                    color: Colors.grey))),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                    height: double.infinity,
                    width: double.infinity,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  );
          }),
    );
  }
}
