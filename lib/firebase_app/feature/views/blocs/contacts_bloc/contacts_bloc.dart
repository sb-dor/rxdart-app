import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart_app/firebase_app/feature/models/contact.dart';
import 'dart:async';

typedef _Snapshots = QuerySnapshot<Map<String, dynamic>>;
typedef _Document = DocumentReference<Map<String, dynamic>>;

extension Unwrap<T> on Stream<T> {
  Stream<T> unwrap() => switchMap(
        (value) async* {
          if (value != null) yield value;
        },
      );
}

@immutable
class ContactsBloc {
  final Sink<String?> userId;
  final Sink<Contact> createContact;
  final Sink<Contact> deleteContact;
  final Stream<Iterable<Contact>> contacts;
  final Sink<void> deleteAllContacts;
  final StreamSubscription<void> _createContactSubscription;
  final StreamSubscription<void> _deleteContactSubscription;
  final StreamSubscription<void> _deleteAllContactSubscription;

  void dispose() {
    userId.close();
    createContact.close();
    deleteContact.close();
    deleteAllContacts.close();
    _deleteAllContactSubscription.cancel();
    _createContactSubscription.cancel();
    _deleteContactSubscription.cancel();
  }

  const ContactsBloc._({
    required this.userId,
    required this.createContact,
    required this.deleteContact,
    required this.contacts,
    required this.deleteAllContacts,
    required StreamSubscription<void> createContactSubscription,
    required StreamSubscription<void> deleteContactSubscription,
    required StreamSubscription<void> deleteAllContactsSubscription,
  })  : _createContactSubscription = createContactSubscription,
        _deleteContactSubscription = deleteContactSubscription,
        _deleteAllContactSubscription = deleteAllContactsSubscription;

  factory ContactsBloc() {
    final backend = FirebaseFirestore.instance;

    final userId = BehaviorSubject<String?>();

    // upon changes to user id, retrieve our contacts.

    final Stream<Iterable<Contact>> contacts = userId.switchMap<_Snapshots>((userId) {
      if (userId == null) {
        return const Stream<_Snapshots>.empty();
      } else {
        return backend.collection(userId).snapshots();
      }
    }).map<Iterable<Contact>>((event) sync* {
      for (final doc in event.docs) {
        yield Contact.fromJson(doc.data(), id: doc.id);
      }
    });

    // create contact

    final createContact = BehaviorSubject<Contact>();

    final StreamSubscription<void> createContactSubscription = createContact.switchMap((contact) {
      return userId
          .take(1)
          .unwrap()
          .asyncMap((userIdForColl) => backend.collection(userIdForColl ?? '').add(contact.data));
    }).listen((event) {});

    // delete contact

    final deleteContact = BehaviorSubject<Contact>();

    final StreamSubscription<void> deleteContactSubscription = deleteContact.switchMap((contact) {
      return userId.take(1).unwrap().asyncMap(
          (userIdForColl) => backend.collection(userIdForColl ?? '').doc(contact.id).delete());
    }).listen((event) {});

    final deleteAllContacts = BehaviorSubject<void>();

    final StreamSubscription<void> deleteAllContactsSubs = deleteAllContacts
        .switchMap((_) => userId.take(1).unwrap())
        .asyncMap((userId) => backend.collection(userId ?? '').get())
        .switchMap((collection) {
      return Stream.fromFutures(collection.docs.map((e) => e.reference.delete()));
    }).listen(
      (_) {},
    );

    // create contacts bloc
    return ContactsBloc._(
      userId: userId.sink,
      createContact: createContact.sink,
      deleteContact: deleteContact.sink,
      contacts: contacts,
      deleteAllContacts: deleteAllContacts.sink,
      createContactSubscription: createContactSubscription,
      deleteContactSubscription: deleteContactSubscription,
      deleteAllContactsSubscription: deleteAllContactsSubs,
    );
  }
}
