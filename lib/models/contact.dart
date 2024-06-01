class Contact {

   int id;
   String name;
   String email;
   String phone;
  Contact({required this.id, required this.name, required this.email, required this.phone});

   factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      name: json['full_name'],
      email: json['email'],
      phone: json['phone_number'],
    );
  }
}