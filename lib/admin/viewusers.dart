import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;
  final String accountNumber;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.accountNumber,
  });
}

class UserListView extends StatelessWidget {
  const UserListView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1.0),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'No user was found.',
                  style: TextStyle(fontSize: 18, color: Colors.blue),
                ),
              );
            }

            List<User?> users = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              if (data['username'] != null &&
                  data['email'] != null &&
                  data['accountNumber'] != null) {
                return User(
                  id: doc.id,
                  username: data['username'],
                  email: data['email'],
                  accountNumber: data['accountNumber'],
                );
              } else {
                return null; // Filter out documents with missing data
              }
            }).where((element) => element != null).toList();

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index]!;
                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      user.username,
                      style: const TextStyle(
                          fontSize: 15,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(
                      left: 10
                    ),
                    child: Column(
                      children: [
                        Text(
                          user.email,
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 100
                          ),
                          child: Text(
                            user.accountNumber,
                            style: const TextStyle(
                                fontSize: 17,
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.blue,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditUserScreen(user: user),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.blue,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  "Confirm Delete",
                                  style: TextStyle(color: Colors.black),
                                ),
                                content: const Text(
                                  "Are you sure you want to delete this user?",
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      // Close the dialog
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("Delete"),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(user.id)
                                          .delete();
                                      Navigator.of(context).pop();
                                      // Close the dialog
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class EditUserScreen extends StatefulWidget {
  final User user;

  const EditUserScreen({Key? key, required this.user}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _accountNumberController;

  @override
  void initState() {
    super.initState();
    _usernameController =
        TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _accountNumberController =
        TextEditingController(text: widget.user.accountNumber);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _accountNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _accountNumberController,
              decoration:
              const InputDecoration(labelText: 'Account Number'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save changes
                // For simplicity, let's just update the Firestore document directly
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.user.id)
                    .update({
                  'username': _usernameController.text,
                  'email': _emailController.text,
                  'accountNumber': _accountNumberController.text,
                }).then((_) {
                  Navigator.pop(context); // Navigate back to the previous screen
                });
              },
              child: const Text('update'),
            ),
          ],
        ),
      ),
    );
  }
}
