import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'authentication.dart';
import 'login.dart';


class SettingsPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StatefulWidget>{

  AuthenticationHelper auth = AuthenticationHelper();

  @override
  Widget build(BuildContext context) {

    //              IconButton(
    //                 icon: Icon(Icons.logout),
    //                 onPressed: () {
    //                   auth.signOut();
    //                   Navigator.push(
    //                     context,
    //                     MaterialPageRoute(builder: (context) => Login()),
    //                   );
    //                 },
    //               ),

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: signout, child: const Text('Log Out')),
            ElevatedButton(
                onPressed: deleteAlert,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                child: const Text('Delete Account'),
            )
          ]
        ),
      ),
    );

  }

  void deleteAlert() async{
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text("Deleting Account"),
          content: SingleChildScrollView(
            child: ListBody(
              children: const [
                Text("Are you sure you want to delete your account. This action can not be undone.")
              ],
            ),
          ),
          actions: [
            ElevatedButton(onPressed: (){ Navigator.pop(context); }, child: const Text('Cancel')),
            ElevatedButton(
              onPressed: deleteAccount,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Delete'),
            )
          ],
        );
      }
    );
  }

  void deleteAccount() async {
    await auth.delete();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  void signout(){
    auth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

}