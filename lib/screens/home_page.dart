import 'dart:io';

import 'package:contact_diary_app/providers/contact_provider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var contactprovider = Provider.of<ContactProvider>(context);
    var contactproviderfalse =
        Provider.of<ContactProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                LocalAuthentication localAuth = LocalAuthentication();
                if (await localAuth.canCheckBiometrics &&
                    await localAuth.isDeviceSupported()) {
                  localAuth
                      .authenticate(localizedReason: "Unlock Hidden Contacts")
                      .then((value) {
                    Navigator.pushNamed(context, "hidden_contacts");
                  });
                }
              },
              icon: const Icon(Icons.lock)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertBox();
              },
            );
          },
          child: const Icon(Icons.add)),
      body: Container(
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.all(12),
        child: (contactprovider.contacts.isEmpty)
            ? Center(
                child: Text(
                "No contacts,Press + to add new",
                style: TextStyle(fontSize: 25),
              ))
            : ListView(
                children: contactprovider.contacts.map((e) {
                  return Card(
                    elevation: 5,
                    child: ListTile(
                      dense: true,
                      onTap: () {
                        Navigator.pushNamed(context, "contact_detail",
                            arguments: e);
                      },
                      leading: (e.profileImage!=null)?CircleAvatar(
                        backgroundImage: FileImage(e.profileImage!),
                      ):CircleAvatar(
                        child: FlutterLogo(),
                      ),
                      title: Text(e.name),
                      subtitle: Text(e.phone),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              contactproviderfalse.hideContact(e);
                            },
                            icon: const Icon(Icons.lock),
                          ),
                          IconButton(
                            onPressed: () {
                              contactproviderfalse.deleteContact(e);
                            },
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                          ),
                          IconButton(
                            onPressed: () {
                              final Uri _url = Uri.parse("tel:${e.phone}");
                              launchUrl(_url);
                            },
                            icon: const Icon(
                              Icons.call,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      ),
    );
  }
}

class AlertBox extends StatefulWidget {
  const AlertBox({super.key});

  @override
  State<AlertBox> createState() => _AlertBoxState();
}

class _AlertBoxState extends State<AlertBox> {
  @override
  Widget build(BuildContext context) {
    var contactprovider = Provider.of<ContactProvider>(context);
    var contactproviderfalse =
        Provider.of<ContactProvider>(context, listen: false);

    return AlertDialog(
      title: Text("Add Contact"),
      content: SizedBox(
        height: 450,
        width: 450,
        child: Stepper(
          currentStep: contactprovider.current_step,
          controlsBuilder: (context, details) {
            if (contactprovider.current_step == 0) {
              return Row(
                children: [
                  FilledButton(
                    onPressed: () {
                      contactproviderfalse.checkContinueState();
                    },
                    child: const Text('Continue'),
                  ),
                ],
              );
            } else if (contactprovider.current_step == 3) {
              return Row(
                children: [
                  FilledButton(
                    onPressed: () {
                      contactproviderfalse.checkFilledData();
                      contactprovider.current_step = 0;
                      Navigator.pop(context);
                    },
                    child: const Text('Finish'),
                  ),
                  TextButton(
                    onPressed: () {
                      contactproviderfalse.checkCancelState();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  FilledButton(
                    onPressed: () {
                      contactproviderfalse.checkContinueState();
                    },
                    child: const Text('Continue'),
                  ),
                  TextButton(
                    onPressed: () {
                      contactproviderfalse.checkCancelState();
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              );
            }
          },
          steps: [
            Step(
              state: (contactprovider.current_step == 0)
                  ? StepState.editing
                  : StepState.complete,
              title: Text("Contact Image"),
              content: Column(
                children: [
                  (contactprovider.profileImageVar != null)
                      ? CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              FileImage(contactprovider.profileImageVar!),
                        )
                      : CircleAvatar(
                          radius: 40,
                          child: FlutterLogo(),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          contactproviderfalse.ImagePickerCamera();
                        },
                        child: Icon(Icons.camera),
                      ),
                      FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          contactproviderfalse.ImagePickerGalary();
                        },
                        child: Icon(Icons.photo),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Step(
              state: (contactprovider.current_step < 1)
                  ? StepState.indexed
                  : (contactprovider.current_step == 1)
                      ? StepState.editing
                      : (contactprovider.nameController.text.isEmpty)
                          ? StepState.error
                          : StepState.complete,
              title: Text("Name"),
              content: TextField(
                  controller: contactprovider.nameController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your Name')),
            ),
            Step(
              state: (contactprovider.current_step < 2)
                  ? StepState.indexed
                  : (contactprovider.current_step == 2)
                      ? StepState.editing
                      : (contactprovider.phoneController.text.isEmpty)
                          ? StepState.error
                          : StepState.complete,
              title: Text("Phone Number"),
              content: TextField(
                  controller: contactprovider.phoneController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your Phone Number')),
            ),
            Step(
              state: (contactprovider.current_step < 3)
                  ? StepState.indexed
                  : (contactprovider.current_step == 3)
                      ? StepState.editing
                      : (contactprovider.emailController.text.isEmpty)
                          ? StepState.error
                          : StepState.complete,
              title: Text("Email"),
              content: TextField(
                  controller: contactprovider.emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter your Email')),
            ),
          ],
        ),
      ),
    );
  }
}
