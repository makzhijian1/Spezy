import 'package:flutter/material.dart';
import 'package:spezy/services/database.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';


class PayPalWebview extends StatelessWidget {
  final String paypalme;
  final String uid;
  final String activityID;
  final String name;
  final String price;
  final String status;
  Timer timer;

  PayPalWebview({Key key, this.paypalme, this.uid, this.name, this.activityID, this.price, this.status}) : super (key : key);


  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  WebViewController tmpController;
  /*PayPalWebview({
    @required this.paypalme,
  });
*/
  void checkForURL() async{
    String tmpString = await tmpController.currentUrl();
    /*bool result = await checkSuccess(tmpString);
    print(result);
    if (result == true){
      print("Success detected");

    }*/
    print(tmpString);
    if(tmpString.contains("https://www.paypal.com/myaccount/transfer/homepage/buy/success")){
      DatabaseService(uid: uid).updateStatus(activityID, name, price, "paid");
      timer.cancel();
      Navigator.pop(_globalKey.currentContext);

    }
  }

  Future <bool> checkSuccess(String result) async {
    print('checkign for success');
    String tmp = "https://www.paypal.com/myaccount/transfer/homepage/buy/success";
    if (tmp == result)
      return true;
    else
      return false;
  }

  Future<void> _handleAccessCode(String value) async {
    String tmpString = await tmpController.currentUrl();
    if (tmpString.contains("https://www.paypal.com/myaccount/transfer/homepage/buy/")){
      timer = Timer.periodic(Duration(seconds: 3), (Timer t) => checkForURL());
    }
    print(tmpString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _globalKey,
        appBar: AppBar(
          title: Text('Send Payment'),
          backgroundColor: const Color(0xFF091544),
        ),
        body: WebView(
          initialUrl: paypalme,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            tmpController = webViewController;
            _controller.complete(webViewController);
          },
          onPageFinished: _handleAccessCode,
        ));
  }

}


