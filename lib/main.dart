import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:testdemobase/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(home: first(),debugShowCheckedModeBanner: false,));
}

class first extends StatefulWidget {
  DocumentSnapshot? document;
  first([this.document]);
  @override
  
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('Contact_Book');
  @override
  void initState()
  {
    super.initState();
    if(widget.document!=null){
      Map<String, dynamic> data =widget.document!.data()! as Map<String, dynamic>;
      t1.text=data['Name'];
      t2.text=data['Contact'];
    }
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ADD CONTACT"),
      ),
      body: Column(children: [
        TextField(controller: t1,),
        TextField(controller: t2,),
        ElevatedButton(onPressed:() {
         if(widget.document!=null) {
           updateUser();
         }
         else
           {
             addUser();
           }
        }, child: Text("Submit")),

        ElevatedButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return home();
          },));
        }, child: Text("View Contact")),
      ],),
    );
  }
  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .add({
      'Name':t1.text , // John Doe
      'Contact': t2.text, // Stokes and Sons

    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Future<void> updateUser() {
    return users
        .doc(widget.document!.id)
        .update({'Name': t1.text,'Contact' :t2.text
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
}

