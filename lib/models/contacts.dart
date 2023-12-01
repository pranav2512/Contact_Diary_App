import 'dart:io';

import 'package:flutter/material.dart';

class Contact {
  String name;
  String phone;
  String email;
  File? profileImage;

  Contact(
      {required this.name,
      required this.phone,
      required this.email,
        this.profileImage});
}
