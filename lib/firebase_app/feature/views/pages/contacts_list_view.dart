import 'package:flutter/material.dart';
import 'package:rxdart_app/firebase_app/feature/models/contact.dart';
import 'package:rxdart_app/firebase_app/feature/views/dialogs/delete_contact_dialog.dart';
import 'package:rxdart_app/firebase_app/feature/views/popup/popup_menu_button.dart';
import 'package:rxdart_app/firebase_app/helpers/type_definition.dart';

class ContactsListView extends StatelessWidget {
  final LogoutCallback logoutCallback;
  final DeleteAccountCallback deleteAccountCallback;
  final DeleteContactCallback deleteContact;
  final VoidCallback createNewContact;
  final Stream<Iterable<Contact>> contacts;

  const ContactsListView({
    super.key,
    required this.logoutCallback,
    required this.deleteAccountCallback,
    required this.deleteContact,
    required this.createNewContact,
    required this.contacts,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts list"),
        actions: [
          MainPopupMenuButton(
            logoutCallback: logoutCallback,
            deleteAccountCallback: deleteAccountCallback,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewContact,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<Iterable<Contact>>(
        stream: contacts,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const CircularProgressIndicator();
            case ConnectionState.active:
            case ConnectionState.done:
              final contacts = snapshot.requireData;
              return ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  final contact = contacts.elementAt(index);
                  return ContactsListTile(
                    contact: contact,
                    deleteContactCallback: deleteContact,
                  );
                },
              );
            // TODO: Handle this case.
          }
        },
      ),
    );
  }
}

class ContactsListTile extends StatelessWidget {
  final Contact contact;
  final DeleteContactCallback deleteContactCallback;

  const ContactsListTile({super.key, required this.contact, required this.deleteContactCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(contact.fullName),
      trailing: IconButton(
        onPressed: () async {
          final shouldDelete = await showDeleteContactDialog(context: context);
          if (shouldDelete) {
            deleteContactCallback(contact);
          }
        },
        icon: const Icon(Icons.delete),
      ),
    );
  }
}
