import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class User {
  final String id;
  final String username;
  final String loanRespondStatus;

  User({
    required this.id,
    required this.username,
    required this.loanRespondStatus,
  });
}

class LoanNotificationListView extends StatelessWidget {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  const LoanNotificationListView({Key? key}) : super(key: key);

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
            return const CircularProgressIndicator();
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
                return CircularProgressIndicator();
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('oop! there is nothing here.'),
                );
              }

              List<User> users = snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                String loanRespondStatus = data['loanRespondStatus'] ?? 'No loan response status yet';
                return User(
                  id: doc.id,
                  username: data['username'],
                  loanRespondStatus: loanRespondStatus,
                );
              }).toList();

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey[300]!, // Light grey color
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
                          style: const TextStyle(fontSize: 17, color: Colors.blue),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 7),
                            child: Text(
                              user.loanRespondStatus,
                              style: const TextStyle(fontSize: 15, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Delete loanRespondStatus
                          FirebaseFirestore.instance.collection('users').doc(user.id).update({
                            'loanRespondStatus': FieldValue.delete(),
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
