import 'package:flutter/material.dart';
import 'package:spezy/screens/authenticate/LoginScreen.dart';
import 'package:spezy/screens/menu/home.dart';
import 'package:spezy/services/auth.dart';

class Register2 extends StatefulWidget {
  final name;
  final email;
  final password;
  Register2({Key key, this.name, this.email, this.password}) : super (key : key);


  @override
  _Register2State createState() => _Register2State();
}

class _Register2State extends State<Register2> {


  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final AuthService _auth = AuthService();
  String paypalme;
  String mobile;
  TextEditingController paypalmeInputController;
  TextEditingController mobileInputController;

  @override
  initState() {
    paypalmeInputController =  new TextEditingController();
    mobileInputController =  new TextEditingController();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final titleText = Text(
      "Spezy", style: TextStyle(
      color: const Color(0xFFFFFFFF),
      fontFamily: "OneDay",
      fontSize: 72,
    ),
    );

    final descriptionText = Text(
      "NOTICE: Spezy makes use of PayPal.Me to perform transactions. Please setup a PayPal.Me link if you haven't already done so. ", style: TextStyle(
      color: const Color(0xFFFFFFFF).withOpacity(0.67),
      fontFamily: "Roboto-Medium",
      fontSize: 12,
    ),
      textAlign: TextAlign.center,
    );


    final paypalmeField = TextFormField(
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Roboto-Medium",
      ),
      obscureText: false,
      textAlign: TextAlign.center, //align hinttext to center
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "PayPal.Me Link",  hintStyle: TextStyle (color: const Color(0xFFFFFFFF).withOpacity(0.38), fontSize: 12.0),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: const Color(0xFFFFFFFF))),
      ),
      controller: paypalmeInputController,
      keyboardType: TextInputType.emailAddress,
    );

    final mobileField = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      textAlign: TextAlign.center, //align hinttext to center
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Mobile Number",  hintStyle: TextStyle (color: const Color(0xFFFFFFFF).withOpacity(0.38),fontSize: 12.0),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: const Color(0xFFFFFFFF))),
      ),
      controller: mobileInputController,
    );

    final createButton = Material(
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF032DC4), //Secondary Color - Light Blue
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if (_registerFormKey.currentState.validate()){
            dynamic result = await _auth.registerWithEmailAndPassword(widget.email, widget.password ,widget.name,
                paypalmeInputController.text, mobileInputController.text);
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new SignIn()),
            );
          }
        },
        child: Text("CREATE ACCOUNT",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Ubuntu-R",
            fontSize: 14,
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF091544),
      body: Center(
        child: new SingleChildScrollView(
          child: Form (
            key: _registerFormKey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: 56.0,
                    ),
                    titleText,
                    Container(
                      height: 56.0,
                    ),
                    descriptionText,

                    Container(
                      height: 32.0,
                    ),
                    paypalmeField,
                    Container(
                      height: 16.0,
                    ),
                    mobileField,
                    Container(
                      height: 40.0,
                    ),
                    createButton,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
