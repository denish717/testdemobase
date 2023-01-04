import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:testdemobase/main.dart';

void main()
{
  runApp(MaterialApp(
    home: home(),
    debugShowCheckedModeBanner: false,
  ));
}
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('Contact_Book').snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('Contact_Book');


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(
        "View_Data"),),
      body: StreamBuilder<QuerySnapshot>(
        stream: _usersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              print(document.id);
              return ListTile(
                title: Text(data['Name']),
                subtitle: Text(data['Contact']),
                trailing:Wrap(children: [
                  IconButton(onPressed: () {
                    users
                        .doc(document.id)
                        .delete()
                        .then((value) => print("User Deleted"))
                        .catchError((error) => print("Failed to delete user: $error"));
                  }, icon: Icon(Icons.delete)),
                  IconButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return first(document);
                    },));

                  }, icon: Icon(Icons.edit)),
                ],)

              );
            }).toList(),
          );
        },
      )
    );
  }

}

