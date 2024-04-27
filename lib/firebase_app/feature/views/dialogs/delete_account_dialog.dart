import 'package:flutter/material.dart';
import 'package:rxdart_app/firebase_app/feature/views/dialogs/generic_dialog.dart';

Future<bool> showDeleteAccountDialog({required BuildContext context}) async {
  return showGenericDialog(
    context: context,
    title: "Delete account",
    content: "Are you sure you want to delete your account. You cannot undo this operation!",
    optionBuilder: () => {
      "Cancel": false,
      "Delete account": true,
    },
  ).then((value) => value ?? false);
}
