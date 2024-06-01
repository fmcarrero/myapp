import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactService {
  Future<List<dynamic>> fetchContacts() async {
    final response = await http.get(Uri.parse('https://api.example.com/contacts'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load contacts');
    }
  }
}
