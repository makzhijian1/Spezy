import 'package:flutter/material.dart';
import 'package:spezy/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _State createState() => _State();
}




class _State extends State<SignIn> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  final AuthService _auth = AuthService();

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String error = '';

  @override
  Widget build(BuildContext context) {

    String checkValidEmail(String value) {
      Pattern invalidpattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@'
          r'((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(invalidpattern);
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

    final titleText = Text(
      "Spezy", style: TextStyle(
      color: const Color(0xFFFFFFFF),
      fontFamily: "OneDay",
      fontSize: 72,
    ),
    );

    final emailField = TextFormField(
      style: TextStyle(
        color: Colors.white,
      ),
      obscureText: false,
      textAlign: TextAlign.center, //align hinttext to center
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Username",  hintStyle: TextStyle (color: const Color(0xFFFFFFFF), fontSize: 12.0),
        enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: const Color(0xFFFFFFFF))),
      ),
      controller: emailInputController,
      keyboardType: TextInputType.emailAddress,
      validator: checkValidEmail,

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

    final loginButton = Material(
      //elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF032DC4), //SECONDARY - LIGHT BLUE
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if(_loginFormKey.currentState.validate()){
            dynamic result = await _auth.signInWithEmailAndPassword(emailInputController.text, pwdInputController.text);
            if (result == null){
              setState(() => error = 'Invalid credentials');
            }
          }
        },
        child: Text("LOGIN",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Ubuntu-R",
            fontSize: 14,
          ),
        ),
      ),
    );

    final errorMsg = Text(
      error, style: TextStyle(
      color: Colors.red[400].withOpacity(0.67),
      fontFamily: "Roboto-Medium",
      fontSize: 12.0,
    ),
    );


    final forgotpwButton = Material(
      //elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF091544).withOpacity(0.63),
      child: MaterialButton(
        onPressed: () {},
        child: Text("Forgot Password?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white.withOpacity(0.63),
            fontFamily: "Ubuntu-R",
            fontSize: 12,
          ),
        ),
      ),
    );

    final signupText = Text(
      "Don't Have An Account?", style: TextStyle(
      color: const Color(0xFFFFFFFF).withOpacity(0.63),
      fontFamily: "Ubuntu-R",
      fontSize: 12,
    ),
    );

    final signupButton = Material(
      //elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xFF1A0651),
      child: MaterialButton(
        onPressed: () {
          widget.toggleView();
        },
        child: Text("Register Now",
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
      backgroundColor: const Color(0xFF091544), //PRIMARY - DARK BLUE
      body: Center(
        child: new SingleChildScrollView(
          child: Form (
            key: _loginFormKey,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 64.0,
                    ),
                    titleText,
                    SizedBox(
                      height: 64.0,
                    ),
                    SizedBox(height: 32.0),
                    emailField,
                    SizedBox(height: 16.0),
                    passwordField,
                    SizedBox(
                      height: 16.0,
                    ),
                    errorMsg,
                    forgotpwButton,
                    SizedBox(
                      height: 32.0,
                    ),
                    loginButton,
                    SizedBox(
                      height: 48.0,
                    ),
                    Container (
                      height: 1.5,
                      color: const Color(0xFFACA1A1).withOpacity(0.5),
                    ),
                    Row (
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        signupText,
                        signupButton,
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
