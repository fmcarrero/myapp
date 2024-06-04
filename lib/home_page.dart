import 'package:flutter/material.dart';
import 'package:myapp/providers/contact_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<ContactProvider>(context, listen: false).fetchContacts());
  }

  @override
  Widget build(BuildContext context) {
    final contactProvider = Provider.of<ContactProvider>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contacts List'),
      ),
      body: contactProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        hintText: 'Contact Name',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ))),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: contactController,
                    keyboardType: TextInputType.text,
                    maxLength: 14,
                    decoration: const InputDecoration(
                        hintText: 'Contact Number',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ))),
                  ),
                  //const SizedBox(height: 10),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ))),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          String name = nameController.text.trim();
                          String phoneNumber = contactController.text.trim();
                          String email = emailController.text.trim();
                          if (name.isNotEmpty &&
                              phoneNumber.isNotEmpty &&
                              email.isNotEmpty) {
                            try {
                              await contactProvider
                                  .addContact(name, email, phoneNumber)
                                  .then((_) {
                                nameController.clear();
                                contactController.clear();
                                emailController.clear();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Contact Added'),
                                  ),
                                );
                              });
                            } catch (exception) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('$exception')));
                            } finally {
                              FocusScope.of(context).unfocus();
                            }
                          }else {
                            FocusScope.of(context).unfocus();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                ));
                          }
                        },
                        child: const Text('Save'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          String name = nameController.text.trim();
                          String phoneNumber = contactController.text.trim();
                          String email = emailController.text.trim();
                          if (name.isNotEmpty &&
                              phoneNumber.isNotEmpty &&
                              email.isNotEmpty &&
                              selectedIndex != -1) {
                                try {
                            await contactProvider
                                .editContact(
                                    contactProvider.contacts[selectedIndex].id,
                                    name,
                                    email,
                                    phoneNumber)
                                .then((_) {
                              nameController.clear();
                              contactController.clear();
                              emailController.clear();
                              FocusScope.of(context).unfocus();
                              setState(() {
                                selectedIndex = -1;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Contact edited'),
                                ),
                              );
                            });
                            }catch(exception){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('$exception')));
                            }
                          }else {
                            FocusScope.of(context).unfocus();
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill all fields'),
                                ));
                          }
                        },
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  contactProvider.contacts.isEmpty
                      ? const Text(
                          'No Contact yet..',
                          style: TextStyle(fontSize: 22),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: contactProvider.contacts.length,
                            itemBuilder: (context, index) =>
                                getRow(index, contactProvider),
                          ),
                        ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => contactProvider.fetchContacts(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  Widget getRow(int index, ContactProvider contactProvider) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            contactProvider.contacts[index].name[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contactProvider.contacts[index].name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(contactProvider.contacts[index].phone),
            Text(contactProvider.contacts[index].email),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                onTap: () {
                  nameController.text = contactProvider.contacts[index].name;
                  contactController.text =
                      contactProvider.contacts[index].phone;
                  emailController.text = contactProvider.contacts[index].email;
                  setState(() {
                    selectedIndex = index;
                  });
                },
                child: const Icon(Icons.edit),
              ),
              InkWell(
                onTap: () {
                  contactProvider
                      .deleteContact(contactProvider.contacts[index].id)
                      .then((_) {
                    setState(() {});
                  });
                },
                child: const Icon(Icons.delete),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
