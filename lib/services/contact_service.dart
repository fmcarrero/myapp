import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactService {
  Future<Map<String,dynamic>> fetchContacts() async {
    final response = await http.get(Uri.parse('https://7695-186-121-91-27.ngrok-free.app/v1/contacts'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load contacts');
    }
  }
}
