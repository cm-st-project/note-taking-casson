import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'editingPage.dart';
import 'database.dart';
import 'Widgets.dart';
import 'authentication.dart';
import 'home.dart';
import 'package:page_transition/page_transition.dart';

class SaveFilePage extends StatefulWidget {
  const SaveFilePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<SaveFilePage> createState() => _SaveFilePageState();
}

class _SaveFilePageState extends State<SaveFilePage> {
  String url = "";
  DatabaseHelper db = DatabaseHelper();
  List<taskpage> data = [];
  AuthenticationHelper Auth = AuthenticationHelper();
  List<dynamic> thisisalist = [];

  //listening ofr firebase changes
  _SaveFilePageState() {
    refreshNotes();
    FirebaseDatabase.instance
        .ref()
        .child(Auth.user.uid)
        .onChildChanged
        .listen((event) {
      print("Data changed!");
      refreshNotes();
    });
    FirebaseDatabase.instance
        .ref()
        .child(Auth.user.uid)
        .onChildRemoved
        .listen((event) {
      refreshNotes();
    });
    FirebaseDatabase.instance
        .ref()
        .child(Auth.user.uid)
        .onChildAdded
        .listen((event) {
      refreshNotes();
    });
  }

  //refresh the taskpage array data
  void refreshNotes() {
    FirebaseDatabase.instance.ref().child(Auth.user.uid).once().then((event) {
      List<taskpage> notetmplist = [];
      bool toggledelete = false;
      for (DataSnapshot i in event.snapshot.children) {
        // title = event.snapshot.children.elementAt(i).value.toString();

        setState(() => notetmplist.add(taskpage(
            i.children.elementAt(2).value.toString(),
            i.children.elementAt(1).value.toString(),
            i.children.elementAt(0).value.toString())));
      }
      ;
      data = notetmplist;
    });
  }

  @override
  void initState() {
    DatabaseReference _db1 = FirebaseDatabase.instance.ref();
    var ref = _db1.child(Auth.user.uid);
    ref.onValue.listen((event) {
      //i = 0;
      int x = event.snapshot.children.length;
      print(x);
      data.clear();
      int t = 0;
      for (DataSnapshot i in event.snapshot.children) {
        // title = event.snapshot.children.elementAt(i).value.toString();

        setState(() => data.insert(
            t,
            (taskpage(
              i.children.elementAt(2).value.toString(),
              i.children.elementAt(1).value.toString(),
              i.children.elementAt(0).value.toString(),
            ))));
        // data[t] = TaskCardWidget(i.children.elementAt(1).value.toString(), i.children.elementAt(0).value.toString());
        t++;
      }
      ;
    });
    super.initState();
  }

  void list() async {
    setState(() => data = db.getValue());
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: EditingPage(
                          thisisalist,
                          "Editing Page",
                          url,
                        )));
              },
            ),
            Text(widget.title)
          ]),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            MyHomePage(title: "recording page")));
              },
            )
          ]),
      body: SingleChildScrollView(
        reverse: true,
        // Center is a layout widget. It takes a single child and positions it
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: data,
          ),
        ),
      ),
    );
  }
}
