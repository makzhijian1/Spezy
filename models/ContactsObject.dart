import 'dart:typed_data';

class ContactsObject {
  String phoneNumber;
  bool checked;
  Uint8List avatar;
  String initials;

  ContactsObject(String phoneNumber, bool checked, Uint8List avatar, String initials) {
    this.phoneNumber = phoneNumber;
    this.checked = checked;
    this.avatar = avatar;
    this.initials = initials;
  }
}