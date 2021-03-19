import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:spezy/screens/menu/home.dart';

class ConfirmationScreen extends StatefulWidget {
  final List<Contact> selectedContacts;
  final List<String> items;
  final List<String> price;
  final List<List<String>> selectedprice;
  final List<List<bool>> selected;
  final String date;
  final String activityTitle;
  final String uid;
  final String name;
  ConfirmationScreen({Key key, this.selectedContacts,this.items, this.price,this.selectedprice,this.selected, this.date, this.activityTitle, this.uid, this.name}) : super(key: key);

  @override
  _ConfirmationScreenState createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool confirmButton = false;
  Color activeColour = const Color(0xff032dc4);
  Color inactiveColour = const Color(0xff032dc4).withOpacity(0.38);
  String totalPrice;

  @override
  void initState(){
    double tmpPrice = 0;
    widget.price.forEach((price){
      tmpPrice += double.parse(price);
    });
    totalPrice = tmpPrice.toStringAsFixed(2);
    super.initState();
  }

  Widget makeSubtitle(int index){
    return Column(
      children: <Widget>[
        for ( int i = 0; i < widget.items.length; i++ ) if (widget.selectedprice[i][index] != "0") Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.items[i],style: TextStyle(color: Colors.black,)),
            Text("\$" + widget.selectedprice[i][index] ,style: TextStyle(color: Colors.black,)),
          ],
        ),
      ],
    );
  }

  Widget calculateIndividualTotal(int index){
    double tmpPrice = 0;
    for ( int i = 0; i < widget.items.length; i++ ){
      if (widget.selectedprice[i][index] != "0"){
        tmpPrice += double.parse(widget.selectedprice[i][index]);
      }
    }
    return Text("\$" + tmpPrice.toStringAsFixed(2),style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17));
  }

  String calculateIndividualTotalForConfirmation(int index){
    double tmpPrice = 0;
    for ( int i = 0; i < widget.items.length; i++ ){
      if (widget.selectedprice[i][index] != "0"){
        tmpPrice += double.parse(widget.selectedprice[i][index]);
      }
    }
    return tmpPrice.toStringAsFixed(2);
  }

  Future<List<Map<String,Map<String,String>>>> loadPayors () async{
    List<Map<String,Map<String,String>>> tmpPayors = new List<Map<String,Map<String,String>>>();
    int counter = 0;

    for (Contact contact in widget.selectedContacts){
      String name;
      await Firestore.instance.collection('users').getDocuments().then((v){
        for (DocumentSnapshot doc in v.documents){
          if(doc.data['mobile'] == contact.phones.first.value)
            name = doc.data['name'];
        }
      }).then((value){
        tmpPayors.add({name:{"status":'pending','price': calculateIndividualTotalForConfirmation(counter+1).toString()}});
      });
      counter++;
    }

    return tmpPayors;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: const Color(0xFF091544),
          elevation: 0.0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text("Confirm Activity Details",style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding( 
              padding: const EdgeInsets.all(20.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(widget.activityTitle, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  Container(
                    height: 16,
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text("Total Amount", style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                              Container(
                                height: 10,
                              ),
                              Text("\$" + totalPrice, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text("Date", style: TextStyle(color: Colors.black.withOpacity(0.6)),),
                              Container(
                                height: 10,
                              ),
                              Text(widget.date,style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),)
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: 16,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),color: const Color(0xFF367DF8).withOpacity(0.08)),
                      child: Scrollbar(
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.black45,
                            indent: 30.0,
                            endIndent: 30.0,
                          ),
                          itemCount: widget.selectedContacts.length+1,
                          itemBuilder: (context, i) {
                            return widget.items[i] != null
                                ? i==0 ? ListTile(
                              title: Text("You",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: makeSubtitle(i),
                              trailing: calculateIndividualTotal(i),
                              leading: CircleAvatar(radius: 25.0, backgroundColor: const Color(0xff091544), child: Text("Y", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              isThreeLine: true,
                            )
                                : ListTile(
                              title: Text(widget.selectedContacts[i-1].displayName,style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              subtitle: makeSubtitle(i),
                              trailing: calculateIndividualTotal(i),
                              leading: CircleAvatar(radius: 25.0, backgroundColor: const Color(0xff091544), child: Text(widget.selectedContacts[i-1].initials(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              isThreeLine: true,
                            )
                                : Container(
                              height: 0,
                              width: 0,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          top: 0,
                          right: 20,
                          bottom: 5,
                        ),
                        child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width * 0.35,
                          height: 60,
                          child: FlatButton(
                            disabledColor: inactiveColour,
                            color: activeColour,
                            onPressed: () async{
                              Future.wait([
                                loadPayors(),
                              ]).then((value){
                                Firestore.instance.collection('activities').document(widget.uid+'_'+widget.activityTitle+'_'+ widget.date.trim().replaceAll(new RegExp(r"\s+\b|\b\s"), "-")).setData({
                                  'owner' : widget.name,
                                  'ownerUID' : widget.uid,
                                  'payors' : value[0],
                                  'title' :  this.widget.activityTitle.replaceAll(new RegExp(r"\s+\b|\b\s"), ""),
                                });
                              }).then((result){
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => Home(
                                  uid: widget.uid,
                                  name: widget.name,
                                )));
                              });
                            } ,
                            child: Text('CONFIRM', style: TextStyle(color: Colors.white)),
                            shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(35.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
          ),
        )
    );
  }
}
