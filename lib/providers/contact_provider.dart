import 'dart:async';

import 'package:flutter/material.dart';
import 'package:myapp/repositories/contact_repository.dart';
import 'package:myapp/models/contact.dart';

class ContactProvider with ChangeNotifier {
  List<Contact> _contacts = [];
  bool _isLoading = false;

  List<Contact> get contacts => _contacts;
  bool get isLoading => _isLoading;

  Future<void> fetchContacts() async {
    _isLoading = true;
    notifyListeners();

    _contacts = await ContactRepository().getContacts();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> editContact(int id, String name, String email, String phoneNumber) async {

    Contact updatedContact = await ContactRepository().editContact(id, name, email, phoneNumber);
    int index = _contacts.indexWhere((c) => c.id == id);
    _contacts[index] = updatedContact;
    notifyListeners();
  }
  Future<void> addContact(String name, String email, String phoneNumber) async {
    Contact newContact = await ContactRepository().addContact(name, email, phoneNumber);
    _contacts.add(newContact);
    notifyListeners();
  }
}
