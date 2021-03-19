import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:spezy/services/auth.dart';
import 'package:spezy/services/database.dart';
import 'package:provider/provider.dart';
import 'package:spezy/screens/menu/DashboardScreen.dart';
import 'package:spezy/screens/menu/TempScreen.dart';
import 'package:spezy/screens/menu/ProfileScreen.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:spezy/screens/splitter/PresplitScreen.dart';


class Home extends StatefulWidget {
  final String name;
  final String uid;
  Home({Key key, this.name, this.uid}) : super (key : key);

  final AuthService _auth = AuthService();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home> {
  int _currentIndex = 0;

  Future<String> _scanQR() async {
    String result;
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "FormatException";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      Dashboard(name: widget.name, uid: widget.uid,),
      PlaceholderWidget(const Color(0xFF091544)),
      PlaceholderWidget(const Color(0xFF091544)),
      PlaceholderWidget(const Color(0xFF091544)),
      Profile(name: widget.name,),
    ];

    final appTitle = Container (
      color: const Color (0xFFF89C8B),
      child: Center(
          child: new Text (
              "Spezy", style: TextStyle(
            color: const Color(0xFFFFFFFF),
            fontFamily: "OneDay",
            fontSize: 36,
          ),
              textAlign: TextAlign.center
          )
      ),
    );



    return StreamProvider <QuerySnapshot>.value(
      value: DatabaseService().activities,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: _children[_currentIndex],
        bottomNavigationBar: CurvedNavigationBar(
            backgroundColor: const Color(0xFF091544),
            items: <Widget>[
              Icon(Icons.home, size: 30),
              Icon(Icons.search, size: 30),
              Icon(Icons.camera_alt, size: 30),
              Icon(Icons.menu, size: 30),
              Icon(Icons.account_circle, size: 30),
            ],
            onTap: (index){
              setState(() {
                if(index == 2){
                  _scanQR().then((value){
                    {
                      List<String> items = List<String>();
                      List<String> price = List<String>();
                      String date;
                      try {
                        Map<String, dynamic> parsedBill;
                        parsedBill = json.decode(value);
                        parsedBill.forEach((item,value){
                          if (item == "Date"){
                            date = value;
                          } else{
                            items.add(item);
                            price.add(value);
                          }
                        });

                        Navigator.of(context).push(MaterialPageRoute(builder:
                            (BuildContext context) => preSplit(
                          items: items,
                          price: price,
                          date: date,
                          uid: widget.uid,
                          name: widget.name,
                        )));
                      }
                      catch (Exception){
                        Fluttertoast.showToast(
                            msg: "Invalid QR",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIos: 1,
                            backgroundColor: Colors.white.withOpacity(0.9),
                            textColor: Colors.black,
                            fontSize: 16.0
                        );
                      }
                    }
                  });
                }
                _currentIndex = index;
              });
            }
        ),

      ),
    );
  }
}




