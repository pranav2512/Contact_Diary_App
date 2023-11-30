import 'package:contact_diary_app/models/contacts.dart';
import 'package:flutter/material.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> contacts = [
    Contact(
        name: "Pranav",
        phone: "8866161894",
        email: "pranav@gmail.com",
        flutterLogo: FlutterLogo()),
    Contact(
        name: "Manav",
        phone: "9988774455",
        email: "manav@gmail.com",
        flutterLogo: FlutterLogo()),
  ];

  List<Contact> hiddenContacts=[];

  int current_step = 0;
  TextEditingController nameController = TextEditingController(text: "");
  TextEditingController phoneController = TextEditingController(text: "");
  TextEditingController emailController = TextEditingController(text: "");
  FlutterLogo flutterLogo = FlutterLogo();

  checkContinueState() {
    if (current_step < 3) {
      current_step++;
    }
    notifyListeners();
  }

  checkCancelState() {
    if (current_step > 0) {
      current_step--;
    }
    notifyListeners();
  }

  void addContact(
      String name, String phone, String email, FlutterLogo flutterLogo) {
    contacts.add(Contact(
        name: name, phone: phone, email: email, flutterLogo: flutterLogo));
    notifyListeners();
  }

  void checkFilledData() {
    if (nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty) {
      addContact(nameController.text, phoneController.text, emailController.text, flutterLogo);
      nameController.clear();
      emailController.clear();
      phoneController.clear();
    }
  notifyListeners();}

  void deleteContact(Contact data){
    contacts.remove(data);
    notifyListeners();
  }

  void hideContact(Contact data)
  {
    hiddenContacts.add(data);
    contacts.remove(data);
    notifyListeners();
  }

  void unHideContact(Contact data)
  {
    contacts.add(data);
    hiddenContacts.remove(data);
    notifyListeners();
  }
}
