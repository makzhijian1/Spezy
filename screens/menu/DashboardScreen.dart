import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:spezy/services/paypalwebview.dart';

class Dashboard extends StatefulWidget {
  final String name;
  final String uid;
  Dashboard({Key key, this.name, this.uid}) : super (key : key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  List<String> activityTitle = new List<String>();

  Map <String,List<Map<String,List<String>>>> outgoingActivityDetails = new Map<String,List<Map<String,List<String>>>>();
  Map <String, Map<String, List <String>>> incomingActivityDetails = new  Map<String, Map<String, List<String>>>();

  final appTitle = Container(
    child: Center(
        child: new Text (
            "Spezy", style: TextStyle(
          color: Colors.white,
          fontFamily: "OneDay",
          fontSize: 36,
        ),
            textAlign: TextAlign.center
        )
    ),
  );


  final subtitle1 = Container(
    child: Center(
        child: new Text (
            "ACTIVITIES YOU HAVE PAID FOR ", style: TextStyle(
          color: const Color(0xFFFFFFFF),
          fontFamily: "ROBOTO-MEDIUM",
          fontSize: 18,
        ),
            textAlign: TextAlign.center
        )
    ),
  );

  final subtitle2 = Container(
    child: Center(
        child: new Text (
            "PAYMENT REQUEST FROM OTHERS", style: TextStyle(
          color: const Color(0xFFFFFFFF),
          fontFamily: "ROBOTO-MEDIUM",
          fontSize: 18,
        ),
            textAlign: TextAlign.center
        )
    ),
  );



  _createOutgoingCard(int index) {
    String title;
    List<String> users = new List<String>();
    List<String> status = new List<String>();
    List<String> price = new List<String>();
    int counter = 0;

    outgoingActivityDetails.forEach((k,v){
      if (counter == index){
        title = k;
        v.forEach((userList){
          userList.forEach((user,value){
            users.add(user);
            status.add(value[0]);
            price.add(value[1]);
          });
        });
      }
      counter++;
    });
    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Center(
                  child: new Text (
                      title , style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Roboto-Medium",
                    fontSize: 14,
                  ),
                      textAlign: TextAlign.center
                  )
              ),
            ),
            Row (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    for(var user in users ) Text(user, style: TextStyle(
                      height: 1.5,
                      color: Colors.black,
                      fontFamily: "Roboto-Medium",
                      fontSize: 12,
                    ))
                  ],
                ),
                Column(
                  children:<Widget>[
                    for(var userStatus in status ) Text(userStatus, style: TextStyle(
                      height: 1.5,
                      color: Colors.black,
                      fontFamily: "Roboto-Medium",
                      fontSize: 12,
                    ))
                  ],
                )
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 250.0,
                    child: RaisedButton(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: const Color(0xFF032DC4))
                      ),
                      onPressed: () {
                        setState(() {

                        });
                      },
                      child: Text(
                        "Send Reminder",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFF032DC4),
                          fontFamily: "Roboto-Medium",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _createIncomingCard (int index) {
    String title;
    String status;
    String price;
    String owner;
    String ownerUID;
    String activityID;
    int counter = 0;
    incomingActivityDetails.forEach((key ,value){ //KEY = TITLE, VALUE = MAP {PAYOR, LIST [VALUES]}
      if (counter == index){
        title = key;
        value.forEach((key , value){ //KEY = PAYOR NAME, VALUE = ACTIVITY FIELDS SUCH AS STATUS, PRICE, OWNER, OWNER UID
          status = value[0];
          price = value[1];
          owner = value [2];
          ownerUID = value [3];
          activityID = value [4];
        });
      }
      counter++;
    });

    return Card(
      shape: RoundedRectangleBorder(
        side: new BorderSide(color: Colors.white, width: 2.0),
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Center(
                  child: new Text (
                      title , style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Roboto-Medium",
                    fontSize: 14,
                  ),
                      textAlign: TextAlign.center
                  )
              ),
            ),
            Row (
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Column(
                  children:<Widget>[
                    Text('$owner Requested $price From You', style: TextStyle(
                      height: 1.0,
                      color: Colors.black,
                      fontFamily: "Roboto-Medium",
                      fontSize: 12,
                    ))
                  ],
                )
              ],
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 250.0,
                    child: RaisedButton(
                      color: const Color(0xFF032DC4),
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: const Color(0xFF032DC4))
                      ),
                      onPressed: () {
                        String uri;
                        Firestore.instance.collection('users').document(ownerUID).get().then((result){
                          uri = result['paypalme']+'/'+ price;
                        }).then((result){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => PayPalWebview(
                                paypalme: uri,
                                uid: widget.uid,
                                activityID: activityID,
                                name: widget.name,
                                price: price,
                                status: status,
                              )));
                        });
                      },
                      child: Text(
                        "Send Payment",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Roboto-Medium",
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activities = Provider.of<QuerySnapshot>(context);
    outgoingActivityDetails.clear();
    if (activities == null){
      return CircularProgressIndicator();
    }
    else {
      for (DocumentSnapshot doc in activities.documents) {
        if (doc.data['owner'] == widget.name) {
          List<Map<String, List<String>>> tmpOutList = new List<Map<String, List<String>>>();
          int counter = 0;
          for (Map <dynamic, dynamic> s in doc.data['payors']) {
            Map<String, List<String>> tmpOutMap = new Map<String, List<String>>();
            s.keys.forEach((payors) {
              tmpOutMap[payors] = [s[payors]['status'], s[payors]['price']];
              tmpOutList.add(tmpOutMap);
              if (s[payors]['status'] == 'pending'){counter++;}
            });
            if(counter > 0)
              outgoingActivityDetails[doc.data['title']] = tmpOutList;
          }
        }
        if (doc.data['owner'] != widget.name){
          for (Map <dynamic, dynamic> s in doc.data['payors']) { //s = Map [PayorName : List of Fields]
            Map<String, List<String>> tmpInMap = new Map<String, List<String>>();
            s.keys.forEach((payors) {
              if (payors == widget.name) {
                if (s[payors]['status'] == 'pending'){
                  tmpInMap[payors] = [s[payors]['status'], s[payors]['price'],
                    doc.data['owner'], doc.data['ownerUID'], doc.documentID];
                  incomingActivityDetails[doc.data['title']] = tmpInMap;
                }
              }
            });
          }
        }
      }

      return Scaffold(
        backgroundColor: const Color(0xFF091544),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 32.0,
              ),
              appTitle,
              Container(
                height: 16.0,
              ),
              subtitle1,
              Container(
                height: 8.0,
              ),
              Container(
                height: 232.0,
                child: new Swiper(
                  itemBuilder: (BuildContext context, int index) {
                 /*   if (outgoingActivityDetails == null) {
                      return Text(
                        "loading", style: TextStyle(color: Colors.white),);
                    }
                    else {
                      return _createOutgoingCard(index);
                    }*/ //Old Code
                    return _createOutgoingCard(index);
                  },
                  itemCount: outgoingActivityDetails.length,
                  viewportFraction: 0.8,
                  scale: 0.2,
                  pagination: new SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: new DotSwiperPaginationBuilder(
                        color: Colors.grey,
                        size: 5.0,
                        activeSize: 7.0,
                        activeColor: const Color(0xFF091544)),
                  ),
                ),
              ),
              Container(
                height: 32.0,
              ),
              subtitle2,
              Container(
                height: 8.0,
              ),
              Container(
                height: 160.0,
                child: new Swiper(
                  itemBuilder: (BuildContext context, int index) {
                   /* if (incomingActivityDetails == null) {
                      return Text(
                        "loading", style: TextStyle(color: Colors.white),);
                    }
                    else {
                      return _createIncomingCard(index) ;
                    }*/
                    return _createIncomingCard(index) ;
                  },
                  itemCount: incomingActivityDetails.length,
                  viewportFraction: 0.8,
                  scale: 0.2,
                  pagination: new SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: new DotSwiperPaginationBuilder(
                        color: Colors.grey,
                        size: 5.0,
                        activeSize: 7.0,
                        activeColor: const Color(0xFF091544)),
                  ),
                ),
              ),

            ],
          ),
        ),
      );
    }
  }
}
