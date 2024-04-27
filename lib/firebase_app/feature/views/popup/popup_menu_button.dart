import 'package:flutter/material.dart';
import 'package:rxdart_app/firebase_app/feature/views/dialogs/delete_account_dialog.dart';
import 'package:rxdart_app/firebase_app/feature/views/dialogs/logout_dialog.dart';
import 'package:rxdart_app/firebase_app/helpers/type_definition.dart';

enum MainAction { logout, deleteAccount }

class MainPopupMenuButton extends StatelessWidget {
  final LogoutCallback logoutCallback;
  final DeleteAccountCallback deleteAccountCallback;

  const MainPopupMenuButton({
    super.key,
    required this.logoutCallback,
    required this.deleteAccountCallback,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MainAction>(
      itemBuilder: (context) => [
        const PopupMenuItem<MainAction>(
          value: MainAction.logout,
          child: Text("Log out"),
        ),
        const PopupMenuItem(
          value: MainAction.deleteAccount,
          child: Text("Delete account"),
        ),
      ],
      onSelected: (value) async {
        switch (value) {
          case MainAction.logout:
            final shouldLogOut = await showLogoutDialog(context: context);
            if (shouldLogOut) {
              logoutCallback();
            }
            break;
          case MainAction.deleteAccount:
            final shouldDelete = await showDeleteAccountDialog(context: context);
            if (shouldDelete) {
              deleteAccountCallback();
            }
            break;
        }
      },
    );
  }
}
