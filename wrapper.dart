import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spezy/screens/authenticate/authenticate.dart';
import 'package:spezy/screens/menu/home.dart';
import 'package:spezy/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if(user == null){
      return Authenticate();
    }
    else {

      return Home(name : user.name, uid: user.uid);
    }
  }
}
