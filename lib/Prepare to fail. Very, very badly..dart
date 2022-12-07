import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:this_is_a_project/thisisafile.dart';
import 'package:this_is_a_project/wahooo.dart';
import 'database.dart';
import 'Widgets.dart';
import'authentication.dart';
import 'main.dart';
import 'package:page_transition/page_transition.dart';

class lettheembarassmentcommence extends StatefulWidget {
  const lettheembarassmentcommence({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<lettheembarassmentcommence> createState() => _lettheembarassmentcommenceState();
}

class _lettheembarassmentcommenceState extends State<lettheembarassmentcommence> {
  String url="";
  DatabaseHelper db= DatabaseHelper();
  List<taskpage> data = [];
  AuthenticationHelper Auth= AuthenticationHelper();
  List<dynamic> thisisalist = [];
 //listening ofr firebase changes
  _lettheembarassmentcommenceState() {
    refreshNotes();
    FirebaseDatabase.instance.ref().child(Auth.user.uid).onChildChanged.listen((event) {
      print("Data changed!");
      refreshNotes();
    });
    FirebaseDatabase.instance.ref().child(Auth.user.uid).onChildRemoved.listen((event) {
      refreshNotes();
    });
    FirebaseDatabase.instance.ref().child(Auth.user.uid).onChildAdded.listen((event) {
      refreshNotes();
    });
  }
  //refresh the taskpage array data
  void refreshNotes() {
  FirebaseDatabase.instance.ref().child(Auth.user.uid).once().then((event) {
  List<taskpage> notetmplist = [];
  bool toggledelete = false;
  for (DataSnapshot i in event.snapshot.children){
  // title = event.snapshot.children.elementAt(i).value.toString();

  setState( () => notetmplist.add(taskpage(
  i.children.elementAt(2).value.toString(),
  i.children.elementAt(1).value.toString(),
  i.children.elementAt(0).value.toString()
  )));
  };
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
      for (DataSnapshot i in event.snapshot.children){
        // title = event.snapshot.children.elementAt(i).value.toString();

        setState(() => data.insert(t, (taskpage(
            i.children.elementAt(2).value.toString(),
          i.children.elementAt(1).value.toString(),
          i.children.elementAt(0).value.toString(),

        ))));
        // data[t] = TaskCardWidget(i.children.elementAt(1).value.toString(), i.children.elementAt(0).value.toString());
        t++;
      };
    });
    super.initState();
  }

  void list() async {
    setState(() => data = db.getValue());
    print(data);
  }

  void thisisaloop() {
    print("Test");
    for (int placeholdervariable = 0;
        placeholdervariable < 21;
        placeholdervariable++) {
      if (placeholdervariable < 10) {
        print("Unholy Screaming");
      } else if (placeholdervariable == 10) {
        print("Perfectly balanced, as all things should be.");
      } else if (placeholdervariable > 10) {
        print("More unholy screaming");
      }
    }
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => nextpage(title: "I give up")));
  }



  String CassonsBraincells = "no.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false,title: Row(
          children: <Widget>[

            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyHomePage(title:"recording page")));

              },
            ),
        //
        // IconButton(
        // icon: Icon(Icons.arrow_back_ios),
        // onPressed: () {
        //   Navigator.push(
        //       context,
        //       PageTransition(type: PageTransitionType.leftToRight, child: wahooo(thisisalist,"Editing Page", url,)));
        // },
      // ),
          Text(widget.title)
          ]),
        actions:[

        ]

      ),
      body: SingleChildScrollView(
        reverse: true,
        // Center is a layout widget. It takes a single child and positions it
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: data,

 /*             Padding(
                padding: EdgeInsets.all(10.0),
                child: InkWell(
                  onTap: () {
                    thisisaloop();
                  },
                  child: Container(
                    // A fixed-height child.
                    color: const Color(0xffeeee00), // Yellow
                    height: 120.0,
                    alignment: Alignment.center,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Container(
                  // A fixed-height child.
                  color: const Color(0xffee002c), // Yellow
                  height: 120.0,
                  alignment: Alignment.center,
                  child: const Text('Fixed Height Content'),
                ),
              ),*/

          ),
        ),
      ),
    );
  }
}
