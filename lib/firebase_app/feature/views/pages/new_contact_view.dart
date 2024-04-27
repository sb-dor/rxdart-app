import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart_app/firebase_app/helpers/if_debugging.dart';
import 'package:rxdart_app/firebase_app/helpers/type_definition.dart';

class NewContactView extends HookWidget {
  final CreateContactCallback createContactCallback;
  final GoBackCallback goBackCallback;

  const NewContactView({
    super.key,
    required this.createContactCallback,
    required this.goBackCallback,
  });

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController(text: "Avaz".ifDebugging);

    final lastNameController = useTextEditingController(text: "Shams".ifDebugging);

    final phoneController = useTextEditingController(text: "987654321".ifDebugging);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: goBackCallback,
          icon: const Icon(
            Icons.close,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  hintText: "First name...",
                ),
                keyboardType: TextInputType.name,
                keyboardAppearance: Brightness.dark,
              ),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  hintText: "Last name...",
                ),
                keyboardType: TextInputType.name,
                keyboardAppearance: Brightness.dark,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  hintText: "Phone number...",
                ),
                keyboardType: TextInputType.name,
                keyboardAppearance: Brightness.dark,
              ),
              TextButton(
                onPressed: () {
                  final firstName = firstNameController.text;
                  final lastName = lastNameController.text;
                  final phoneNumber = phoneController.text;
                  createContactCallback(
                    firstName: firstName,
                    lastName: lastName,
                    phoneNumber: phoneNumber,
                  );
                  goBackCallback();
                },
                child: const Text("Save contact"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
