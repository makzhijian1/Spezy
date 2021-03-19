import 'package:flutter/material.dart';
import 'package:spezy/screens/authenticate/RegisterScreen2.dart';
import 'package:spezy/services/auth.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController nameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmpwdInputController;


  @override
  initState() {
    nameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmpwdInputController = new TextEditingController();
    super.initState();
  }

  String checkValidEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}'
        r'\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    String emailValidator(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (!regex.hasMatch(value)) {
        return 'Email format is invalid';
      } else {
        return null;
      }
    }

    String pwdValidator(String value) {
      if (value.length < 8) {
        return 'Password must be longer than 8 characters';
      } else {
        return null;
      }
    }

    String cfmPwdValidator(String value) {
      if (value.length < 8) {
        return 'Password must be longer than 8 characters';
      }
      if (pwdInputController.text != confirmpwdInputController.text) {
        return 'Passwords do not match';
      } else {
        return null;
      }
    }

    final titleText = Text(
      "Spezy", style: TextStyle(
      color: const Color(0xFFFFFFFF),
      fontFamily: "OneDay",
      fontSize: 72,
    ),
    );

    final nameField = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      obscureText: false,
      textAlign: TextAlign.center, //align hinttext to center
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Name",  hintStyle: TextStyle (color: const Color(0xFFFFFFFF),fontSize: 12.0),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: const Color(0xFFFFFFFF))),
      ),
      controller: nameInputController,
    );

    final emailField = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      obscureText: false,
      textAlign: TextAlign.center, //align hinttext to center
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Email Address",  hintStyle: TextStyle (color: const Color(0xFFFFFFFF),fontSize: 12.0),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: const Color(0xFFFFFFFF))),
      ),
      controller: emailInputController,
      keyboardType: TextInputType.emailAddress,
      validator: emailValidator,
    );

    final passwordField = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      obscureText: true,
      textAlign: TextAlign.center, //align hinttext to center
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",  hintStyle: TextStyle (color: const Color(0xFFFFFFFF),fontSize: 12.0),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: const Color(0xFFFFFFFF))),
      ),
      controller: pwdInputController,
      validator: pwdValidator,
    );

    final confirmpasswordField = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      obscureText: true,
      textAlign: TextAlign.center, //align hinttext to center
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Confirm Password",  hintStyle: TextStyle (color: const Color(0xFFFFFFFF),fontSize: 12.0),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: const Color(0xFFFFFFFF))),
      ),
      controller: confirmpwdInputController,
      validator: cfmPwdValidator,
    );

    final createButton = Material(
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF032DC4), //Secondary Color - Light Blue
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {

          if (_registerFormKey.currentState.validate()) {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new Register2(email: emailInputController.text, password: pwdInputController.text, name: nameInputController.text,)),
            );
          }
        },
        child: Text("NEXT",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Roboto-Medium",
            fontSize: 14,
          ),
        ),
      ),
    );


    final alrhaveaccountText = Text(
      "Already have an account?", style: TextStyle(
      color: const Color(0xFFACA1A1),
      fontFamily: "Ubuntu-R",
      fontSize: 12,
    ),
    );

    final loginButton = Material(
      //elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF091544),
      child: MaterialButton(
        onPressed: () {
          widget.toggleView();
        },
        child: Text("Login",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Ubuntu-R",
            fontSize: 12,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 56.0,
                    ),
                    titleText,
                    SizedBox(
                      height: 32.0,
                    ),
                    SizedBox(height: 16.0),
                    nameField,
                    SizedBox(height: 16.0),
                    emailField,
                    SizedBox(height: 16.0),
                    passwordField,
                    SizedBox(height: 16.0),
                    confirmpasswordField,
                    SizedBox(
                      height: 48.0,
                    ),
                    createButton,
                    SizedBox(
                      height: 32.0,
                    ),
                    Container (
                      height: 1.5,
                      color: const Color(0xFFACA1A1).withOpacity(0.5),
                    ),
                    Row (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        alrhaveaccountText,
                        loginButton,
                      ],
                    )
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
