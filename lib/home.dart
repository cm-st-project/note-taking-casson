import 'package:flutter/material.dart';
import 'package:this_is_a_project/speech_api.dart';

import 'package:this_is_a_project/editingPage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

import 'package:highlight_text/highlight_text.dart';
import 'package:page_transition/page_transition.dart';
import 'saveFile.dart';
import 'login.dart';
import 'authentication.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AuthenticationHelper auth = new AuthenticationHelper();
  double thisisntafloat = 0.15;
  bool amIstupid = true;
  String text =
      "In geometry, two rays sharing a endpoint area an angle. The common endpoint is called the vertex, and the two rays are called the arms of the angle.";

  // String text = "Welcome to AutoNote!";
  bool _isListening = false;
  List<dynamic> thisisalist = [];
  Map<String, HighlightedWord> thisisamap = {};
  String linkURL = "";
  late stt.SpeechToText _speech;
  bool _isLoading = false;


  Future<String> getLinks() async {
    // This example uses the Google Books API to search for books about http.
    // https://developers.google.com/books/docs/overview
    var url = Uri.https('extractmathterms.marisabelchang.repl.co',
        '/extract/${text}', {'q': '{http}'});
    linkURL = "links";
    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
      convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
      linkURL = convert.jsonEncode(jsonResponse);
      return linkURL;
    } else {
      print('Request failed with status: ${response.statusCode}.');
      linkURL = "";
      return linkURL;
    }
  }



  dataLoadFunction() async {
    setState(() {
      _isLoading = true; // your loader has started to load
    });
    // fetch you data over here
    await getLinks();
    STJ();
    setState(() {
      _isLoading = false; // your loder will stop to finish after the data fetch
    });
  }

  void listen() async {
    stt.SpeechToText speech = stt.SpeechToText();
    bool available = await speech.initialize();
    if (available) {
      print("Available");
      //speech.listen(onResult: (val) => setState(() {text = val.recognizedWords;}),);
      speech.listen(onResult: print, listenFor: Duration(seconds: 10));
      speech.stop();
    } else {
      print("The user has denied the use of speech recognition.");
    }
    // some time later...
    speech.stop();
  }

  Future toggleRecording() => SpeechApi.toggleRecording(

    onResult: (text) => setState(() => this.text = text),
    onListening: (isListening) {
      setState(() => this._isListening = isListening);
    },
  );

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(
          onResult: (val) => setState(() {
            text = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              //_confidence = val.confidence;
            }
          }),
        );
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  //checks the text string and adds a link if needed
  void STJ() {
    Map<String, dynamic> thisisalsoamap = new Map<String, dynamic>();
    List<dynamic> averyverycreativename = [];
    thisisalsoamap["insert"] = this.text + "\n";


    averyverycreativename.insert(0, thisisalsoamap);
    // getLinks();
    // linkURL = "";
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditingPage(averyverycreativename, "Editing Page", linkURL)));
  }

  void thewordstodocmethod() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    List<dynamic> jsoned = [];
    data['insert'] = this.text + '\n';

    jsoned.insert(0, data);
    //Navigator.push(context, MaterialPageRoute(builder: (context) => ))4

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditingPage(jsoned, "Editing Page", linkURL)));
  }

  void reset() {
    setState(() => this.text = "Talk to edit");
  }

  @override
  //WHERE ALL THE MAGIC HAPPENS
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 10.0, 0.0),
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.leftToRight,
                            child: SaveFilePage(title: "Save file page")));
                  },
                ),
              ),
            ]),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  dataLoadFunction();
                  //STJ();
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  reset();
                },
              ),
              IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  auth.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
              ),
            ]),

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.

        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.mic), onPressed: toggleRecording),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
            child: Container(
                padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                child: TextHighlight(
                    text: text,
                    words: thisisamap,
                    textStyle: TextStyle(
                        fontSize: 32,
                        color: Colors.black,
                        fontWeight: FontWeight.w400)))));


  }
}