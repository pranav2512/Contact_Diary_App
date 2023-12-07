import 'dart:io';

import 'package:contact_diary_app/models/contacts.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactProvider extends ChangeNotifier {
  List<Contact> contacts = [
    Contact(
      name: "Pranav",
      phone: "8866161894",
      email: "pranav@gmail.com",
    ),
    Contact(
      name: "Manav",
      phone: "9988774455",
      email: "manav@gmail.com",
    ),
  ];

  File? profileImageVar;
  File? profileImageUpdate;

  void ImagePickerCamera() async {
    ImagePicker picker = ImagePicker();

    XFile? xFile = await picker.pickImage(source: ImageSource.camera);
    String? path = xFile!.path;
    profileImageVar = File(path);
    notifyListeners();
  }

  void ImagePickerGalary() async {
    ImagePicker picker = ImagePicker();

    XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    String? path = xFile!.path;
    profileImageVar = File(path);
    notifyListeners();
  }

  List<Contact> hiddenContacts = [];

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

  void addContact(String name, String phone, String email) {
    contacts.add(Contact(name: name, phone: phone, email: email));
    notifyListeners();
  }

  void addContactWithImage(
      String name, String phone, String email, File profileImgae) {
    contacts.add(Contact(
        name: name, phone: phone, email: email, profileImage: profileImgae));
    notifyListeners();
  }

  void checkFilledData() {
    if (nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        profileImageVar != null) {
      addContactWithImage(nameController.text, phoneController.text,
          emailController.text, profileImageVar!);
    } else if (nameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        profileImageVar == null) {
      addContact(
          nameController.text, phoneController.text, emailController.text);
    }
    nameController.clear();
    emailController.clear();
    phoneController.clear();
    profileImageVar = null;
    notifyListeners();
  }

  void deleteContact(Contact data) {
    contacts.remove(data);
    notifyListeners();
  }

  void hideContact(Contact data) {
    hiddenContacts.add(data);
    contacts.remove(data);
    notifyListeners();
  }

  void unHideContact(Contact data) {
    contacts.add(data);
    hiddenContacts.remove(data);
    notifyListeners();
  }

  TextEditingController nameEditingController = TextEditingController(text: "");
  TextEditingController phoneEditingController =
      TextEditingController(text: "");
  TextEditingController emailEditingController =
      TextEditingController(text: "");

  void updateContact(Contact data, String name, String phone, String email) {
    if (contacts.contains(data)) {
      contacts.forEach((element) {
        if (element == data) {
          element.name = name;
          element.phone = phone;
          element.email = email;
        }
      });
    }
    nameEditingController.clear();
    phoneEditingController.clear();
    emailEditingController.clear();
    notifyListeners();
  }

  Future<void> ImageUpdateCamera(Contact data) async {
    ImagePicker picker = ImagePicker();

    XFile? xFile = await picker.pickImage(source: ImageSource.camera);
    String? path = xFile!.path;
    profileImageUpdate = File(path);
    contacts.forEach((element) {
      if (element == data) {
        element.profileImage = profileImageUpdate;
      }
    });
    notifyListeners();
  }

  Future<void> ImageUpdateGalary(Contact data) async {
    ImagePicker picker = ImagePicker();

    XFile? xFile = await picker.pickImage(source: ImageSource.gallery);
    String? path = xFile!.path;
    profileImageUpdate = File(path);
    contacts.forEach((element) {
      if (element == data) {
        element.profileImage = profileImageUpdate;
      }
    });
    notifyListeners();
  }
}
