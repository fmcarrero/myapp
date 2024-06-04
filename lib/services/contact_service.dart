import 'dart:convert';
import 'package:http/http.dart' as http;

class ContactService {
  final String server = 'https://7695-186-121-91-27.ngrok-free.app/v1/contacts';

  Future<Map<String,dynamic>> fetchContacts() async {
    final response = await http.get(Uri.parse(server));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load contacts');
    }
  }
  Future<Map<String, dynamic>> addContact(String name, String email, String phoneNumber) async {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, String> body = {
      'full_name': name,
      'email': email,
      'phone_number': phoneNumber,
    };

    final response = await http.post(
      Uri.parse(server),
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      String errorMessage;
      try {
        final responseBody = json.decode(response.body);
        errorMessage = responseBody['message'] ?? 'Failed to add contact';
      } catch (e) {
        errorMessage = 'Failed to add contact';
      }
      throw Exception(errorMessage);
    }
  }

 Future<Map<String, dynamic>> editContact(int id, String name, String email, String phoneNumber) async {
    final url = Uri.parse('$server/$id');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final Map<String, String> body = {
      'full_name': name,
      'email': email,
      'phone_number': phoneNumber,
    };

    final response = await http.put(
      url,
      headers: headers,
      body: json.encode(body),
    );
 
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
     String errorMessage;
      try {
        final responseBody = json.decode(response.body);
        errorMessage = responseBody['message'] ?? 'Failed to add contact';
      } catch (e) {
        errorMessage = 'Failed to add contact';
      }
      throw Exception(errorMessage);
    }
  }

  Future<void> deleteContact(int id) async {
    final url = Uri.parse('$server/$id');

    final response = await http.delete(
      url,
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete contact');
    }
  }

}
