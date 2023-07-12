import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gvchat/helpers/screen_arguements.dart';
import 'package:gvchat/screens/profile_screen.dart';
import 'package:gvchat/screens/public_chat.dart';
import 'package:gvchat/screens/welcome_screen1.dart';
import 'package:gvchat/screens/welcome_screen2.dart';

import '../main.dart';
import 'Group_screen.dart';
import 'contacts_screen.dart';

class ChatMenu extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }

  showDialogLogout(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        title: Text(
          'Are you sure want to logout?',
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          ElevatedButton(
            child: Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            onPressed: () {
              logout();
              Navigator.of(ctx).pop();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              primary: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user!.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting ||
                  !snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              Map<String, dynamic>? data =
                  snapshot.data!.data() as Map<String, dynamic>?;
              final username = data!['username'];
              final imageUrl = data['image'];
              return Scaffold(
                appBar: AppBar(
                  title: Text('Select a Option'),
                ),
                body: Container(
                  alignment: Alignment.bottomCenter,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 0,
                              height: 30,
                            ),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ContactsScreen()));
                                  },
                                  icon: Icon(Icons.archive),
                                  label: Text('Personal Chats')),
                            ),
                            SizedBox(height: 50),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                GroupScreen()));
                                  },
                                  icon: Icon(Icons.group),
                                  label: Text('Groups Chats')),
                            ),
                            SizedBox(height: 50),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                publicChat()));
                                  },
                                  icon: Icon(Icons.public),
                                  label: Text('Public Chats')),
                            ),
                            SizedBox(height: 50),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    print('should implemented here!!!!!!!');
                                  },
                                  icon: Icon(Icons.report),
                                  label: Text('Report')),
                            ),
                            SizedBox(height: 50),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.of(context).pushNamed(
                                        ProfileScreen.routeName,
                                        arguments: ScreenArguments(
                                            chatRoomId: '',
                                            username: username,
                                            imageUrl: imageUrl,
                                            email: data['email']));
                                  },
                                  icon: Icon(Icons.settings),
                                  label: Text('Settings')),
                            ),
                            SizedBox(height: 50),
                            SizedBox(
                              width: 200,
                              child: ElevatedButton.icon(
                                  onPressed: () async {
                                    await FirebaseAuth.instance.signOut().then(
                                        (value) => Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyApp())));
                                  },
                                  icon: Icon(Icons.logout),
                                  label: Text('Logout')),
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
                        SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
