import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String accountNumber;
  final String loanLimit;

  User({
    required this.id,
    required this.username,
    required this.accountNumber,
    required this.loanLimit,
  });
}

class UserLoanLimitListView extends StatelessWidget {
  const UserLoanLimitListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Loan limit'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where('loanLimit', isNotEqualTo: null)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No user loan was found.',style:TextStyle(fontSize: 18,color:Colors.blue),),
            );
          }

          List<User> users = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return User(
              id: doc.id,
              username: data['username'],
              accountNumber: data['accountNumber'],
              loanLimit: data['loanLimit'],
            );
          }).toList();

          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!), // Light grey color with width 1.0
            ),
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(
                      left: 10
                    ),
                    child: Text(user.username,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(
                      left: 10
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 155),
                          child: Text(user.accountNumber,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 150),
                          child: Text('Ksh:${user.loanLimit}',style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
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
                          // Navigate to edit screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditUserScreen(user: user),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
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
  late TextEditingController _loanLimitController;

  @override
  void initState() {
    super.initState();
    _loanLimitController = TextEditingController(text: widget.user.loanLimit);
  }

  @override
  void dispose() {
    _loanLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User loanLimit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _loanLimitController,
              decoration: const InputDecoration(labelText: 'Loan Limit'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save changes
                // For simplicity, let's just update the Firestore document directly
                FirebaseFirestore.instance.collection('users').doc(widget.user.id).update({
                  'loanLimit': _loanLimitController.text,
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
