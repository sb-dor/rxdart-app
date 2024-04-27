import 'package:flutter/material.dart';
import 'package:rxdart_app/firebase_app/feature/models/contact.dart';

typedef LogoutCallback = VoidCallback;
typedef GoBackCallback = VoidCallback;
typedef DeleteAccountCallback = VoidCallback;

typedef LoginFunction = void Function({required String email, required String password});
typedef RegisterFunction = void Function({required String email, required String password});

typedef CreateContactCallback = void Function({
  required String firstName,
  required String lastName,
  required String phoneNumber,
});

typedef DeleteContactCallback = void Function(Contact contact);
