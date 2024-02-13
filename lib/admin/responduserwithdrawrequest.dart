import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String accountNumber;
  final String userWithdrawRequest;
  final String withdrawflag;

  User({
    required this.id,
    required this.username,
    required this.accountNumber,
    required this.userWithdrawRequest,
    required this.withdrawflag,
  });
}

class RespondToWithdrawRequest extends StatelessWidget {
  const RespondToWithdrawRequest({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Withdraw'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where('withdrawflag', isNotEqualTo: null)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No Withdraw request was made.',style:TextStyle(fontSize: 18,color:Colors.blue),),
            );
          }

          List<User> users = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return User(
              id: doc.id,
              username: data['username'],
              accountNumber: data['accountNumber'],
              userWithdrawRequest: data['userWithdrawRequest'],
              withdrawflag: data['withdrawflag'],
            );
          }).toList();

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(
                    left: 10
                  ),
                  child: Text(user.withdrawflag,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                    left: 10
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 170
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 150,
                            child: Text(user.username,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),)),
                        SizedBox(
                          width: 150,
                            child: Text('Ksh: ${user.userWithdrawRequest}',style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),)),
                      ],
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
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
  late TextEditingController _statusController;
  String _selectedStatus = 'Your withdrawal request was approved';
  final List<String> _statusOptions = ['Your withdrawal request was approved', 'Your withdrawal request was declined'];

  @override
  void initState() {
    super.initState();
    _statusController = TextEditingController(text: _selectedStatus);
  }

  @override
  void dispose() {
    _statusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User Status'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              items: _statusOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                String message;
                // Save changes
                // For simplicity, let's just update the Firestore document directly
                if (_selectedStatus == 'approve loan') {
                  message = 'Your saving withdraw request was approved.';
                } else {
                  message = 'Your saving withdraw request was declined';
                }
                FirebaseFirestore.instance.collection('users').doc(widget.user.id).update({
                  'withdrawStatus': _selectedStatus,
                }).then((_) {
                  Navigator.pop(context); // Navigate back to the previous screen
                });
              },
              child: const Text('Sent'),
            ),
          ],
        ),
      ),
    );
  }
}
