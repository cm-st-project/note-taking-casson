import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';

import 'login.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final Future<FirebaseApp> _fpApp = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: _fpApp,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print("Error");
              return Text("Something went wrong.");
            } else if (snapshot.hasData) {
              print("yay");
              return Login();
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}


