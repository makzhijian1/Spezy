import 'package:spezy/screens/splitter/SplitScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:spezy/models/ContactsObject.dart';

class ContactsPage extends StatefulWidget {
  final List<String> items;
  final List<String> price;
  final String date;
  final String activityTitle;
  final String uid;
  final String name;
  ContactsPage({Key key, this.items, this.price, this.date, this.activityTitle, this.uid, this.name}) : super(key: key);

  @override
  _ContactsPageState createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  Iterable<Contact> _contacts;
  Map<String, ContactsObject> _contactsMap = {};
  Map<String, ContactsObject> duplicateContacts = {};
  List<Contact> _selectedContacts = List<Contact>();

  TextEditingController editingController = TextEditingController();

  var selectedWidgets = List<Widget>();
  int selectCounter = 0;

  _getContacts() async {
    var contacts = await ContactsService.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  void filterSearchResults(String query) {
    Map<String, ContactsObject> dummySearchList = {};
    dummySearchList.addAll(duplicateContacts);
    if(query.isNotEmpty) {
      Map<String, ContactsObject> dummyListData = {};

      dummySearchList.forEach((key,item) {
        if(key.contains(query) || item.phoneNumber.contains(query)) {
          dummyListData[key] = item;
        }
      });

      setState(() {
        _contactsMap.clear();
        _contactsMap.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _contactsMap.clear();
        _contactsMap.addAll(duplicateContacts);
      });
    }
  }

  Widget _buildSelect(Contact contact){
    UniqueKey key = UniqueKey();
    return Padding(
      key: key,
      padding: const EdgeInsets.only(
        left: 0,
        top: 0,
        right: 12,
        bottom: 0,
      ),
      child: Column(
        children: <Widget>[
          Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                (contact.avatar != null && contact.avatar.length > 0)
                    ? CircleAvatar(radius: 25.0, backgroundColor: const Color(0xff091544), backgroundImage: MemoryImage(contact.avatar))
                    : CircleAvatar(radius: 25.0, backgroundColor: const Color(0xff091544), child: Text(contact.initials(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                Positioned(
                  left: 20,
                  bottom: 15,
                  child: RawMaterialButton(
                    constraints: BoxConstraints(minWidth: 20.0, maxWidth: 20.0, minHeight: 20.0, maxHeight: 20.0),
                    onPressed: () {
                      setState(() {
                        _contactsMap[contact.displayName].checked = false;
                        selectedWidgets.removeWhere((item) => item.key == key);
                      });
                      selectCounter--;
                    },
                    child: new Icon(
                      Icons.clear,
                      color: Colors.white,
                      size: 12.0,
                    ),
                    shape: new CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.red,
                  ),
                ),
              ]
          ),
          Text( contact.displayName.length > 9 ? contact.displayName.substring(0,6) + "..." : contact.displayName, style: TextStyle(color: const Color(0xff091544), fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }

  @override
  void initState() {
    _getContacts().then((value){
      for (var contact in _contacts) {
        if (contact.phones.isNotEmpty){
          ContactsService.getAvatar(contact).then((avatar) {
            if (avatar == null) return; // Don't redraw if no change.
            setState(() => contact.avatar = avatar);
          });
          _contactsMap[contact.displayName] = new ContactsObject(contact.phones.isNotEmpty ? contact.phones.first.value : "",false, contact.avatar, contact.initials());
        }
      }
      duplicateContacts.addAll(_contactsMap);
    });
    super.initState();
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
        title: Text("Request from who?",style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 0,
              right: 20,
              bottom: 5,
            ),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: editingController,
              decoration: InputDecoration(
                hintText: "Name or mobile no.",
                hintStyle: TextStyle(color: Colors.grey),
                suffixIcon: Icon(Icons.search),
                border: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white,
                        style: BorderStyle.solid)
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: const Color(0xff091544)),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              top: 0,
              right: 20,
              bottom: 5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:
              selectedWidgets,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 0,
                right: 0,
                bottom: 0,
              ),
              child: Text("Contacts", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 5,
              top: 0,
              right: 5,
              bottom: 0,
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.50,
              child: _contacts == null ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitFadingCube(
                    color: const Color(0xff091544),
                    size: 50.0,
                  ),
                  Text("Loading...", style: TextStyle(height: 5),)
                ],
              ) : new ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                children: _contactsMap.keys.map((String key) {
                  return new CheckboxListTile(
                    title: new Text(key),
                    value: _contactsMap[key].checked,
                    onChanged: (bool value) {
                      setState(() {
                        if (value == true && selectCounter < 5){
                          _contactsMap[key].checked = value;
                          for (Contact contact in _contacts) {
                            if (contact.displayName == key){
                              selectedWidgets.add(_buildSelect(contact));
                            }
                          }
                          selectCounter++;
                        }
                        else if (value == false && selectCounter != 0){
                          _contactsMap[key].checked = value;
                          selectCounter--;
                        }
                      });
                    },
                    secondary: (_contactsMap[key].avatar != null && _contactsMap[key].avatar.length > 0)
                        ? CircleAvatar(radius: 25.0, backgroundColor: const Color(0xff091544), backgroundImage: MemoryImage(_contactsMap[key].avatar))
                        : CircleAvatar(radius: 25.0, backgroundColor: const Color(0xff091544), child: Text(_contactsMap[key].initials, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    subtitle: new Text(_contactsMap[key].phoneNumber),
                  );
                }).toList(),
              ),
            ),
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
                    color: const Color(0xff032dc4),
                    onPressed: () {
                      _selectedContacts.clear();
                      _contactsMap.forEach((k,v){
                        if(v.checked){
                          for (Contact contact in _contacts) {
                            if (contact.displayName == k) {
                              _selectedContacts.add(contact);
                            }
                          }
                        }
                      });
                      /*_selectedContacts.forEach((contact){
                        print(contact.displayName);
                      });*/
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => SplitScreen(
                        items: widget.items,
                        price: widget.price,
                        date: widget.date,
                        selectedContacts: _selectedContacts,
                        activityTitle: widget.activityTitle,
                        uid: widget.uid,
                        name: widget.name,
                      )));
                    },
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
      ),
    );
  }
}
