import 'package:myapp/services/contact_service.dart';
import 'package:myapp/models/contact.dart';

class ContactRepository {
  final ContactService _contactService = ContactService();

  Future<List<Contact>> getContacts() async {
    final response = await _contactService.fetchContacts();
    var contacts = response['data'] as  List<dynamic>;
    return contacts.map((data) => Contact.fromJson(data)).toList();
  }

  Future<Contact> editContact(int id, String  name, String email, String phoneNumber) async {
    final response = await _contactService.editContact(id, name, email, phoneNumber);
    return Contact.fromJson(response);
  }

  Future<Contact> addContact(String  name, String email, String phoneNumber) async {
    final response = await _contactService.addContact(name, email, phoneNumber);
    return Contact.fromJson(response);
  }
  Future<void> deleteContact(int id) async {
    await _contactService.deleteContact(id);
  }
}
