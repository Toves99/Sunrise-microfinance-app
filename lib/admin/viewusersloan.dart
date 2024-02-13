import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String accountNumber;
  final String loanAmount;

  User({
    required this.id,
    required this.username,
    required this.accountNumber,
    required this.loanAmount,
  });
}

class UserLoanListView extends StatelessWidget {
  const UserLoanListView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Loan'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where('loanAmount', isNotEqualTo: null)
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
              loanAmount: data['loanAmount'],
            );
          }).toList();

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey[300]!, // light grey color
                width: 1.0,
              ),
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
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top:5,
                            left: 10
                        ),
                        child: Text(user.accountNumber,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top:5,
                            left: 10
                        ),
                        child: Text('Ksh:${user.loanAmount}',style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
                      ),
                    ],
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
  late TextEditingController _loanAmountController;

  @override
  void initState() {
    super.initState();
    _loanAmountController = TextEditingController(text: widget.user.loanAmount);
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User Savings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _loanAmountController,
              decoration: const InputDecoration(labelText: 'Loan Amount'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save changes
                // For simplicity, let's just update the Firestore document directly
                FirebaseFirestore.instance.collection('users').doc(widget.user.id).update({
                  'loanAmount': _loanAmountController.text,
                }).then((_) {
                  Navigator.pop(context); // Navigate back to the previous screen
                });
              },
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }
}
