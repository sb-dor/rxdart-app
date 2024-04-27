import 'package:flutter/material.dart';
import 'package:rxdart_app/firebase_app/feature/views/dialogs/generic_dialog.dart';

Future<bool> showLogoutDialog({required BuildContext context}) async {
  return showGenericDialog(
    context: context,
    title: "Log out",
    content: "Are you sure you want log out",
    optionBuilder: () => {
      "Cancel": false,
      "Logout": true,
    },
  ).then((value) => value ?? false);
}
