import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spezy/wrapper.dart';
import 'package:spezy/services/auth.dart';
import 'package:spezy/models/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
// Application Root, contains the run function
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
