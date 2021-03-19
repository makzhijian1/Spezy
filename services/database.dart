import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future updateUserData (String email, String name, String uid, String paypalme, String mobile) async {
    return await userCollection.document(uid).setData({
      'email' : email,
      'name' : name,
      'uid' : uid,
      'paypalme' : paypalme,
      'mobile' : mobile,
    });
  }

  Future updateStatus (String aID, String name, String price, String status) async {
    return await  Firestore.instance.collection('activities').document(aID).updateData({

    });
  }


  Future getUserFromNum(String num) async {
    Firestore.instance.collection('users').getDocuments().then((v){
      print(v.documents);
    });
  }
  Stream <QuerySnapshot> get users {
    final CollectionReference dataCollection = Firestore.instance.collection('users');
    return dataCollection.snapshots();
  }



  Stream <QuerySnapshot> get activities {
    final CollectionReference dataCollection = Firestore.instance.collection('activities');
    return dataCollection.snapshots();
  }


}