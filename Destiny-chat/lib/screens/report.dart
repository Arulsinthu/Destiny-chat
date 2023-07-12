import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class reportpage extends StatefulWidget {
  const reportpage({Key? key}) : super(key: key);
  static const routeName = '/report';
  @override
  _reportpageState createState() => _reportpageState();
}

class _reportpageState extends State<reportpage> {
  @override
  Widget build(BuildContext context) {
    final members = ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Memebers Report View'),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> groupSnapshot) {
            if (groupSnapshot.connectionState == ConnectionState.waiting ||
                !groupSnapshot.hasData) {
              return Container();
            }
            final groupDocs = groupSnapshot.data!.docs;
            return groupDocs.isEmpty
                ? Container()
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: groupSnapshot.data!.docs.length,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (context, index) {
                      final groupDocs = groupSnapshot.data!.docs;
                      int len = groupDocs[index]['username'].toString().length;
                      final imageUrl = groupDocs[index]['image'];
                      return members.contains(groupDocs[index]['uid'])
                          ? Column(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(50),
                                    leading: Image(
                                        image: imageUrl.isEmpty
                                            ? AssetImage(
                                                'assets/images/person.png',
                                              )
                                            : NetworkImage(
                                                imageUrl,
                                              ) as ImageProvider),
                                    subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Email :' +
                                                groupDocs[index]['email'],
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                          Text(
                                            'Last Seen : ' +
                                                groupDocs[index]['Timestamp'],
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ]),
                                    title: Text(groupDocs[index]['username']),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            )
                          : SizedBox();
                    });
          }),
    );
  }
}
