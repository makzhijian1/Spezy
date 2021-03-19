import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:spezy/screens/splitter/ContactsScreen.dart';

class preSplit extends StatefulWidget {
  final List<String> items;
  final List<String> price;
  final String date;
  final String uid;
  final String name;

  preSplit({Key key, this.items, this.price, this.uid, this.date,this.name}) : super(key: key);

  @override
  _preSplitState createState() => _preSplitState();
}

class _preSplitState extends State<preSplit> {

  bool nextButton = false;
  Color activeColour = const Color(0xff032dc4);
  Color inactiveColour = const Color(0xff032dc4).withOpacity(0.38);
  String totalPrice;
  final myController = TextEditingController();

  @override
  void initState(){
    double tmpPrice = 0;
    widget.price.forEach((price){
      tmpPrice += double.parse(price);
    });
    totalPrice = tmpPrice.toStringAsFixed(2);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  Future<bool> _checkContactsPermission() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      return true;
    } else {
      _handleInvalidPermissions(permissionStatus);
      return false;
    }
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.contacts);
    if (permission != PermissionStatus.granted && permission != PermissionStatus.disabled) {
      Map<PermissionGroup, PermissionStatus> permissionStatus = await PermissionHandler().requestPermissions([PermissionGroup.contacts]);
      return permissionStatus[PermissionGroup.contacts] ?? PermissionStatus.unknown;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      throw new PlatformException(
          code: "PERMISSION_DENIED",
          message: "Access to location data denied",
          details: null);
    } else if (permissionStatus == PermissionStatus.disabled) {
      throw new PlatformException(
          code: "PERMISSION_DISABLED",
          message: "Location data is not available on device",
          details: null);
    }
  }

  Widget makeCard(int index){
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 35.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        child: Text(
          widget.items[index],
          style: TextStyle(color: Colors.black,),
        ),
      ),
      title: Text(
        widget.price[index],
        style: TextStyle(color: Colors.black,), textAlign: TextAlign.right,
      ),
      // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),
    );
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
          title: Text("Activity Details",style: TextStyle(color: Colors.white)),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    textCapitalization: TextCapitalization.words,
                    keyboardType: TextInputType.text ,
                    decoration: InputDecoration(
                      labelText: "Activity Title",
                      hintText: "e.g Dinner @ Mischief",
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (text){

                      setState(() {
                        nextButton = text.isEmpty ? false : true;
                      });
                    },
                    controller: myController,
                  ),
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
                          itemCount: widget.items.length,
                          itemBuilder: (context, i) {
                            return widget.items[i] != null
                                ? makeCard(i)
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
                            onPressed: nextButton ? () {
                              _checkContactsPermission().then((permissionResult) {
                                permissionResult ? Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ContactsPage(
                                  items: widget.items,
                                  price: widget.price,
                                  date: widget.date,
                                  activityTitle: myController.text,
                                  uid: widget.uid,
                                  name: widget.name,
                                ))) : null;
                              });
                            } : null,
                            child: Text('NEXT', style: TextStyle(color: Colors.white)),
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
