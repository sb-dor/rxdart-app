import 'package:flutter/material.dart';
import 'package:rxdart_app/firebase_app/feature/views/blocs/auth_bloc/auth_error.dart';
import 'package:rxdart_app/firebase_app/feature/views/dialogs/generic_dialog.dart';

Future<void> showAuthError({
  required AuthError authError,
  required BuildContext context,
}) async {
  return showGenericDialog(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionBuilder: () => {
      "OK": true,
    },
  );
}
