import 'package:contact_diary_app/providers/contact_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HiddenContacts extends StatelessWidget {
  const HiddenContacts({super.key});

  @override
  Widget build(BuildContext context) {
    var contactprovider = Provider.of<ContactProvider>(context);
    var contactproviderfalse =
    Provider.of<ContactProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hidden Contacts"),
        centerTitle: true,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(12),
        child: (contactprovider.hiddenContacts.isEmpty)?Center(
          child: Text(
            "No hidden contacts",
            style: TextStyle(fontSize: 25),
          ),):ListView(
          children: contactprovider.hiddenContacts.map((e) {
            return Card(
              elevation: 5,
              child: ListTile(
                dense: true,
                leading: (e.profileImage!=null)?CircleAvatar(
                    backgroundImage: FileImage(e.profileImage!),
                ):CircleAvatar(
                  child: FlutterLogo(),
                ),
                title: Text(e.name),
                subtitle: Text(e.phone),
                trailing: IconButton(
                  onPressed: () {
                    contactproviderfalse.unHideContact(e);
                  },
                  icon: Icon(Icons.lock_open,color: Colors.green,),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
