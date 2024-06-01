import 'package:myapp/services/contact_service.dart';
import 'package:myapp/models/contact.dart';

class ContactRepository {
  final ContactService _contactService = ContactService();

  Future<List<Contact>> getContacts() async {
    final response = await _contactService.fetchContacts();
    var contacts = response['data'] as  List<dynamic>;
    return contacts.map((data) => Contact.fromJson(data)).toList();
  }
}
