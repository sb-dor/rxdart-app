import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart_app/firebase_app/feature/models/contact.dart';
import 'package:rxdart_app/firebase_app/feature/views/blocs/auth_bloc/auth_bloc.dart';
import 'package:rxdart_app/firebase_app/feature/views/blocs/auth_bloc/auth_error.dart';
import 'package:rxdart_app/firebase_app/feature/views/blocs/contacts_bloc/contacts_bloc.dart';
import 'package:rxdart_app/firebase_app/feature/views/blocs/view_bloc/current_view.dart';
import 'package:rxdart_app/firebase_app/feature/views/blocs/view_bloc/view_bloc.dart';

@immutable
class AppBloc {
  final AuthBloc _authBloc;
  final ViewBloc _viewBloc;
  final ContactsBloc _contactsBloc;

  final Stream<CurrentView> currentView;
  final Stream<bool> isLoading;
  final Stream<AuthError?> authError;
  final StreamSubscription<String?> _userIdChanges;

  const AppBloc._({
    required AuthBloc authBloc,
    required ViewBloc viewBloc,
    required ContactsBloc contactsBloc,
    required this.currentView,
    required this.isLoading,
    required this.authError,
    required StreamSubscription<String?> userIdChanges,
  })  : _authBloc = authBloc,
        _viewBloc = viewBloc,
        _contactsBloc = contactsBloc,
        _userIdChanges = userIdChanges;

  factory AppBloc() {
    final authBloc = AuthBloc();
    final viewsBloc = ViewBloc();
    final contactsBloc = ContactsBloc();

    // pass user if from authbloc into contact bloc

    final userIdChanges = authBloc.userId.listen((String? useId) {
      contactsBloc.userId.add(useId);
    });

    // calculate the current view

    final Stream<CurrentView> currentViewBasedOnAuthStatus =
        authBloc.authStatus.map<CurrentView>((authStatus) {
      if (authStatus is AuthStatusLoggedIn) {
        return CurrentView.contactList;
      } else {
        return CurrentView.login;
      }
    });

    // currentView

    final Stream<CurrentView> currentView = Rx.merge(
      [
        currentViewBasedOnAuthStatus,
        viewsBloc.currentView,
      ],
    );

    final Stream<bool> isLoading = Rx.merge(
      [
        authBloc.isLoading,
      ],
    );

    return AppBloc._(
      authBloc: authBloc,
      viewBloc: viewsBloc,
      contactsBloc: contactsBloc,
      currentView: currentView,
      // when we do like asBroadcastStream we can use the very same stream in several widgets, otherwise it throws an error saying that the stream has been already listened
      isLoading: isLoading.asBroadcastStream(),
      // when we do like asBroadcastStream we can use the very same stream in several widgets, otherwise it throws an error saying that the stream has been already listened
      authError: authBloc.authError.asBroadcastStream(),
      userIdChanges: userIdChanges,
    );
  }

  void dispose() {
    _authBloc.dispose();
    _viewBloc.dispose();
    _contactsBloc.dispose();
    _userIdChanges.cancel();
  }

  void deleteContact(Contact contact) {
    _contactsBloc.deleteContact.add(contact);
  }

  void createContact({
    required String firstName,
    required String lastName,
    required String phoneNumber,
  }) {
    final contact = Contact.withoutId(
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phoneNumber,
    );
    _contactsBloc.createContact.add(contact);
  }

  void logOut() {
    _authBloc.logOut.add(null);
  }

  Stream<Iterable<Contact>> get contacts => _contactsBloc.contacts;

  void registerCommand({required String email, required String password}) {
    final register = RegisterCommand(email: email, password: password);
    _authBloc.register.add(register);
  }

  void loginCommand({required String email, required String password}) {
    final login = LoginCommand(email: email, password: password);
    _authBloc.login.add(login);
  }

  void deleteAccount(){
    // TODO:
    _contactsBloc.deleteAllContacts.add(null);
    _authBloc.deleteAccount.add(null);
  }

  void goToLoginView() => _viewBloc.goToView.add(CurrentView.login);

  void goToContactListView() => _viewBloc.goToView.add(CurrentView.contactList);

  void goToCreateContactView() => _viewBloc.goToView.add(CurrentView.createContact);

  void goToCreateRegisterView() => _viewBloc.goToView.add(CurrentView.register);
}
