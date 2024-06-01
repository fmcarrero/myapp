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
}
