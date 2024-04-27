import 'package:flutter/material.dart';
import 'package:rxdart_app/firebase_app/feature/views/dialogs/generic_dialog.dart';

Future<bool> showDeleteContactDialog({required BuildContext context}) async {
  return showGenericDialog(
    context: context,
    title: "Delete contact",
    content: "Are you sure you want to delete your contact. You cannot undo this operation!",
    optionBuilder: () => {
      "Cancel": false,
      "Delete contact": true,
    },
  ).then((value) => value ?? false);
}
