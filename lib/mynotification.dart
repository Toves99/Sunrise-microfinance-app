import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  final String id;
  final String username;
  final String usermessage;

  User({
    required this.id,
    required this.username,
    required this.usermessage,
  });
}

class UserNotificationListView extends StatelessWidget {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  const UserNotificationListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan notifications'),
      ),
      body: FutureBuilder<String?>(
        future: secureStorage.read(key: 'accountNumber'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('Error retrieving account number'),
            );
          }

          String accountNumber = snapshot.data!;
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('accountNumber', isEqualTo: accountNumber)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Oops! There is nothing here.'),
                );
              }

              List<User> users = snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>;
                String usermessage =
                    data['usermessage'] ?? 'No Notification yet';
                return User(
                  id: doc.id,
                  username: data['username'],
                  usermessage: usermessage,
                );
              }).toList();

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          'Dear ${user.username}',
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 7),
                            child: Text(
                              user.usermessage,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Delete loanRespondStatus
                          FirebaseFirestore.instance
                              .collection('users')
                              .doc(user.id)
                              .update({
                            'usermessage': FieldValue.delete(),
                          });
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserNotificationListView(),
  ));
}
