
import 'package:flutter/material.dart';
import 'package:spezy/services/auth.dart';



class Profile extends StatelessWidget {
  String name;

  Profile({Key key, this.name}) : super (key : key);
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF091544),
      /*   FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text('SIGN OUT'),
            onPressed: () async{
              await _auth.signOut();
            },
          ),*/
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 128.0,
            ),
            Container(
              child: Center(
                  child: new Text (
                      "Spezy", style: TextStyle(
                    color: Colors.white,
                    fontFamily: "OneDay",
                    fontSize: 72,
                  ),
                      textAlign: TextAlign.center
                  )
              ),
            ),
            Container(
              height: 64.0,
            ),
            Container(
              child: Center(
                  child: new Text (
                      name, style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Roboto-Medium",
                    fontSize: 24,
                  ),
                      textAlign: TextAlign.center
                  )
              ),
            ),
            Container(
              height: 8.0,
            ),
            Icon(
              Icons.account_circle,
              color: Colors.white,
              size: 100.0,
            ),
            FlatButton(
              color: Colors.white,
              shape: ContinuousRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white)
              ),
              onPressed: () async{
                await _auth.signOut();
              },
              child: Text(
                "SIGN OUT",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF091544),
                  fontFamily: "Roboto-Medium",
                  fontSize: 16,
                ),
              ),
            ),
            /*  FlatButton(
              color: Colors.white,
              shape: ContinuousRectangleBorder(
                  borderRadius: new BorderRadius.circular(18.0),
                  side: BorderSide(color: Colors.white)
              ),
              onPressed: () async{
                String num = '97959795';
                Firestore.instance.collection('users').getDocuments().then((v){
                  for (DocumentSnapshot doc in v.documents){
                    if(doc.data['mobile'] == num)
                      print(doc.data['name'] + doc.data['uid']);
                  }
                });
              },
              child: Text(
                "CHECK ACTIVITY NUMBER",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF091544),
                  fontFamily: "Roboto-Medium",
                  fontSize: 16,
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}