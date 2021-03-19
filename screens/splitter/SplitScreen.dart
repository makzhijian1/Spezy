import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:spezy/screens/splitter/ConfirmationScreen.dart';
import 'package:spezy/models/SelectableCircle.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:contacts_service/contacts_service.dart';
import 'dart:math' as Math;

const double _radiansPerDegree = Math.pi / 180;
final double _startAngle = -90.0 * _radiansPerDegree;

typedef double ItemAngleCalculator(int index);

class SplitScreen extends StatefulWidget {
  final List<Contact> selectedContacts;
  final List<String> items;
  final List<String> price;
  final String date;
  final String activityTitle;
  final String uid;
  final String name;
  SplitScreen({Key key, this.selectedContacts,this.items, this.price, this.date, this.activityTitle, this.uid, this.name}) : super(key: key);

  @override
  _SplitScreenState createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> with TickerProviderStateMixin {
  List<Widget> avatar = List<Widget>();
  List<String> items = List<String>();
  List<String> price = List<String>();
  List<List<bool>> selected;
  List<bool> avatarSelect = new List<bool>();
  List<List<String>> avatarPrice;
  int currentItemIndex = 0;
  bool nextButton = false;

  Color activeColour = const Color(0xff032dc4);
  Color inactiveColour = const Color(0xff032dc4).withOpacity(0.38);

  @override
  void initState() {
    items = widget.items;
    price = widget.price;

    selected = new List<List<bool>>.generate(items.length, (i) => List<bool>.generate(widget.selectedContacts.length+1, (j) => false));
    avatarSelect = new List<bool>.generate(widget.selectedContacts.length+1, (i) => false);
    avatarPrice = new List<List<String>>.generate(items.length, (i) => List<String>.generate(widget.selectedContacts.length+1, (j) => "0"));
    super.initState();
  }

  int _countSelected (List<bool> select){
    int tmpCount = 0;
    select.forEach((f){
      f ? tmpCount++ : null;
    });
    return tmpCount;
  }

  List<Widget> _builditems(){
    List<Widget> tmp = new List<Widget>();
    tmp.add(
      SelectableCircle(
        color: Colors.transparent,
        borderColor: Colors.transparent,
        isSelected: avatarSelect[0],
        selectMode: SelectMode.check,
        bottomDescription: Text("Yourself"),
        amountDescription: Text("\$" + avatarPrice[currentItemIndex][0]),
        width: 80.0,
        child: CircleAvatar(radius: 35.0, backgroundColor: const Color(0xff091544), child: Text("You", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
        onTap: () {
          setState(() {
            avatarSelect[0] = !avatarSelect[0];
            selected[currentItemIndex][0] = !selected[currentItemIndex][0];
            selected[currentItemIndex].asMap().forEach((index1,value){
              avatarPrice[currentItemIndex][index1] = value ? (double.parse(price[currentItemIndex])/_countSelected(selected[currentItemIndex])).toStringAsFixed(2) : "0";
            });
            bool flagBool = false;
            selected.forEach((list){
              list.contains(true)? null : flagBool = true;
            });
            nextButton = flagBool ? false : true;
          });
        },
      ),
    );

    widget.selectedContacts.asMap().forEach((index, value){
      tmp.add(
        SelectableCircle(
          color: Colors.transparent,
          borderColor: Colors.transparent,
          isSelected: avatarSelect[index+1],
          selectMode: SelectMode.check,
          bottomDescription: Text(widget.selectedContacts[index].displayName.length > 9 ? widget.selectedContacts[index].displayName.substring(0,6) + "..." : widget.selectedContacts[index].displayName),
          amountDescription: Text("\$" + avatarPrice[currentItemIndex][index+1]),
          width: 80.0,
          child: CircleAvatar(radius: 35.0, backgroundColor: const Color(0xff091544), child: Text(widget.selectedContacts[index].initials(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          onTap: () {
            setState(() {
              avatarSelect[index+1] = !avatarSelect[index+1];
              selected[currentItemIndex][index+1] = !selected[currentItemIndex][index+1];
              selected[currentItemIndex].asMap().forEach((index1,value){
                avatarPrice[currentItemIndex][index1] = value ? (double.parse(price[currentItemIndex])/_countSelected(selected[currentItemIndex])).toStringAsFixed(2) : "0";
              });
              bool flagBool = false;
              selected.forEach((list){
                list.contains(true)? null : flagBool = true;
              });
              nextButton = flagBool ? false : true;
            });
          },
        ),
      );
    });
    return tmp;
  }

  Widget _buildCard(int index){
    return Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: 0,
            top: 5,
            right: 0,
            bottom: 10,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text("Item " + (index+1).toString() + " of " + items.length.toString()),
              Text(items[index]),
              Text("\$" + price[index]),
            ],
          ),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    /*print(selected);
    print(avatarPrice);*/
    avatar = _builditems();
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
        title: Text("Split the bill",style: TextStyle(color: Colors.white)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 130,
              child: Swiper(
                itemBuilder: (BuildContext context,int index){
                  return _buildCard(index);
                },
                onIndexChanged: (int index) {
                  setState(() {
                    currentItemIndex = index;
                    avatarSelect.asMap().forEach((index1,value){
                      avatarSelect[index1] = selected[index][index1];
                    });
                  });
                },
                itemCount: items.length,
                viewportFraction: 1,
                pagination: new SwiperPagination(
                    builder: new DotSwiperPaginationBuilder(
                      color: Colors.grey,
                      activeColor: const Color(0xFF091544),
                      size: 5,
                      activeSize: 6,
                    )
                ),

              ),
            ),
            _buildStackView(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 0,
                    top: 16,
                    right: 0,
                    bottom: 24,
                  ),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width * 0.35,
                    height: 30,
                    child: FlatButton(
                      color: const Color(0xff367DF8),
                      onPressed: () {
                        setState(() {
                          selected[currentItemIndex].asMap().forEach((index,value){
                            if (!value){
                              avatarSelect[index] = true;
                              selected[currentItemIndex][index] = true;
                            }
                            avatarPrice[currentItemIndex][index] = (double.parse(price[currentItemIndex])/(widget.selectedContacts.length+1)).toStringAsFixed(2);
                          });

                          bool flagBool = false;
                          selected.forEach((list){
                            list.contains(true)? null : flagBool = true;
                          });
                          nextButton = flagBool ? false : true;
                        });
                      },
                      child: Text('Split Evenly', style: TextStyle(color: Colors.white)),
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(35.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                    left: 24,
                    top: 0,
                    right: 24,
                    bottom: 5,
                  ),
                  child: ButtonTheme(
                    minWidth: MediaQuery.of(context).size.width * 0.35,
                    height: 40,
                    child: FlatButton(
                      disabledColor: inactiveColour,
                      color: activeColour,
                      onPressed: nextButton ? () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ConfirmationScreen(
                          items: widget.items,
                          price: widget.price,
                          selectedprice: avatarPrice,
                          selected: selected,
                          date: widget.date,
                          selectedContacts: widget.selectedContacts,
                          activityTitle: widget.activityTitle,
                          uid: widget.uid,
                          name: widget.name,
                        )));
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
        ),
      ),
    );
  }

  Widget _buildStackView() {
    List<Widget> beverages = <Widget>[];
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double outerRadius = Math.min(width * 3 / 5, height * 1/3);
    double innerWhiteRadius = outerRadius * 4 / 5;

    for (int i = 0; i < avatar.length; i++) {
      beverages.add(_buildIcons(i));
    }

    return Flexible(
      child: Container(
        padding: const EdgeInsets.only(
          left: 0,
          top: 136,
          right: 0,
          bottom: 0,
        ),
        child: new Stack(
          alignment: AlignmentDirectional.center,
          children: <Widget>[
            new CustomMultiChildLayout(
              delegate: new _CircularLayoutDelegate(
                itemCount: avatar.length,
                radius: outerRadius / 2,
              ),
              children: beverages,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcons(int index) {
    final Widget item = avatar[index];

    return new LayoutId(
      id: 'BUTTON$index',
      child: item,
    );
  }
}

double _calculateItemAngle(int index) {
  double _itemSpacing = 360.0 / 5.0;
  return _startAngle + index * _itemSpacing * _radiansPerDegree;
}

class _CircularLayoutDelegate extends MultiChildLayoutDelegate {
  static const String actionButton = 'BUTTON';

  int itemCount;
  double radius;

  _CircularLayoutDelegate({
    @required this.itemCount,
    @required this.radius,
  });

  Offset center;

  @override
  void performLayout(Size size) {
    center = new Offset(size.width / 2, size.height / 2);
    for (int i = 0; i < itemCount; i++) {
      String actionButtonId = '$actionButton$i';

      if (hasChild(actionButtonId)) {
        Size buttonSize =
        layoutChild(actionButtonId, new BoxConstraints.loose(size));

        double itemAngle = _calculateItemAngle(i);

        positionChild(
          actionButtonId,
          new Offset(
            (center.dx - buttonSize.width / 2) + (radius) * Math.cos(itemAngle),
            (center.dy - buttonSize.height / 2) +
                (radius) * Math.sin(itemAngle),
          ),
        );
      }
    }
  }

  @override
  bool shouldRelayout(_CircularLayoutDelegate oldDelegate) =>
      itemCount != oldDelegate.itemCount ||
          radius != oldDelegate.radius ;
}
