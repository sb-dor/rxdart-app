import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:rxdart_app/counter_app/view/pages/counter_page.dart';
import 'package:rxdart_app/firebase_app/feature/views/blocs/app_bloc.dart';
import 'package:rxdart_app/firebase_app/feature/views/blocs/auth_bloc/auth_error.dart';
import 'package:rxdart_app/firebase_app/feature/views/blocs/view_bloc/current_view.dart';
import 'package:rxdart_app/firebase_app/feature/views/dialogs/auth_error_dialog.dart';
import 'package:rxdart_app/firebase_app/feature/views/loading/loading_screen.dart';
import 'package:rxdart_app/firebase_app/feature/views/pages/contacts_list_view.dart';
import 'package:rxdart_app/firebase_app/feature/views/pages/login_view.dart';
import 'package:rxdart_app/firebase_app/feature/views/pages/new_contact_view.dart';
import 'package:rxdart_app/firebase_app/feature/views/pages/register_view.dart';
import 'package:rxdart_app/firebase_options.dart';
import 'package:rxdart_app/getit/getit_inj.dart';

import 'pusher/page/pusher_page.dart';
import 'wish_list_app/view/pages/wish_list_page.dart';

int testAlg(String value) {
  int maxLength = 0;
  Set<String> map = {};

  for (int i = 0; i < value.length; i++) {
    map.add(value[i]);
    for (int j = i + 1; j < value.length; j++) {
      if (map.contains(value[j])) {
        maxLength = maxLength >= map.length ? maxLength : map.length;
        map.clear();
        break;
      } else {
        map.add(value[j]);
      }
    }
  }
  return maxLength;
}

void main() async {
  // testCombined();
  // testConcat();
  // testMerge();
  // testZip();
  // debugPrint("${testAlg("abcbada")}");
  // debugPrint("${testAlg("axbxcxd")}");
  // debugPrint("${testAlg("aaaaaaa")}");
  // debugPrint("${testAlg("abcdefg")}");

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetItInj.inj();

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PusherPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// firebase main page
class FirebaseAppPage extends StatefulWidget {
  const FirebaseAppPage({super.key});

  @override
  State<FirebaseAppPage> createState() => _FirebaseAppPageState();
}

class _FirebaseAppPageState extends State<FirebaseAppPage> {
  late final AppBloc _appBloc;
  StreamSubscription<AuthError?>? _streamErrorSub;
  StreamSubscription<bool>? _isLoadingSub;

  @override
  void initState() {
    super.initState();

    _appBloc = AppBloc();
  }

  @override
  void dispose() {
    _appBloc.dispose();
    super.dispose();
  }

  void handleAuthErrors(BuildContext context) async {
    await _streamErrorSub?.cancel();
    _streamErrorSub = _appBloc.authError.listen((event) {
      final AuthError? authError = event;
      if (authError == null) return;
      showAuthError(authError: authError, context: context);
    });
  }

  void loadingScreen(BuildContext context) async {
    await _isLoadingSub?.cancel();
    _isLoadingSub = _appBloc.isLoading.listen((event) {
      if (event) {
        LoadingScreen.instance.show(context: context, text: "Loading...");
      } else {
        LoadingScreen.instance.hide();
      }
    });
  }

  Widget getHomePage() {
    return StreamBuilder<CurrentView>(
      stream: _appBloc.currentView,
      builder: (context, snap) {
        switch (snap.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            final currentView = snap.requireData;
            switch (currentView) {
              case CurrentView.login:
                return LoginView(
                  login: _appBloc.loginCommand,
                  goToRegisterView: _appBloc.goToCreateRegisterView,
                );
              case CurrentView.register:
                return RegisterView(
                  register: _appBloc.registerCommand,
                  goToLoginView: _appBloc.goToLoginView,
                );
              case CurrentView.contactList:
                return ContactsListView(
                  logoutCallback: _appBloc.logOut,
                  deleteAccountCallback: _appBloc.deleteAccount,
                  deleteContact: _appBloc.deleteContact,
                  createNewContact: _appBloc.goToCreateContactView,
                  contacts: _appBloc.contacts,
                );
              case CurrentView.createContact:
                return NewContactView(
                  createContactCallback: _appBloc.createContact,
                  goBackCallback: _appBloc.goToContactListView,
                );
            }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    handleAuthErrors(context);
    loadingScreen(context);
    return getHomePage();
  }
}
