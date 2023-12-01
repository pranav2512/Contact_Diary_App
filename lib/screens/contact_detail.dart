import 'package:contact_diary_app/models/contacts.dart';
import 'package:contact_diary_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ContactDetail extends StatelessWidget {
  const ContactDetail({super.key});

  @override
  Widget build(BuildContext context) {
    Contact data = ModalRoute.of(context)!.settings.arguments as Contact;
    var contactprovider = Provider.of<ContactProvider>(context);
    var contactproviderfalse =
        Provider.of<ContactProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(data.name),
        actions: [
          IconButton(
            onPressed: () {
              contactprovider.nameEditingController.text = data.name;
              contactprovider.phoneEditingController.text = data.phone;
              contactprovider.emailEditingController.text = data.email;
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Update Contact"),
                    actions: [
                      OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            contactproviderfalse.updateContact(
                                data,
                                contactprovider.nameEditingController.text,
                                contactprovider.phoneEditingController.text,
                                contactprovider.emailEditingController.text);
                            Navigator.pop(context);
                          },
                          child: Text("Done")),
                    ],
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name"),
                        TextField(
                          controller: contactprovider.nameEditingController,
                        ),
                        Text("Phone"),
                        TextField(
                          controller: contactprovider.phoneEditingController,
                        ),
                        Text("Email"),
                        TextField(
                          controller: contactprovider.emailEditingController,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
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
                  (data.profileImage!=null)?CircleAvatar(
                    radius: 100,
                      backgroundImage: FileImage(data.profileImage!),
                  ):CircleAvatar(
                    radius: 100,
                child: FlutterLogo(size: 100),
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
