import 'package:contact_diary_app/models/contacts.dart';
import 'package:flutter/material.dart';

class ContactDetail extends StatelessWidget {
  const ContactDetail({super.key});

  @override
  Widget build(BuildContext context) {

    Contact data=ModalRoute.of(context)!.settings.arguments as Contact;

    return Scaffold(
      appBar: AppBar(
        title: Text(data.name),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Align(
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 100,
                    child: data.flutterLogo,
                  ),
                  FloatingActionButton(
                      mini: true, onPressed: () {}, child: Icon(Icons.add))
                ],
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(12),
                height: 230,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_circle, size: 40),
                        SizedBox(width: 10),
                        Text(
                          data.name,
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.call, size: 40),
                        SizedBox(width: 10),
                        Text(
                          data.phone,
                          style: TextStyle(fontSize: 28),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.email, size: 40),
                        SizedBox(width: 10),
                        Text(
                          data.email,
                          style: TextStyle(fontSize: 22),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
