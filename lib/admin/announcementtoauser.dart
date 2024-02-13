import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });
}

class UserMessage extends StatelessWidget {
  const UserMessage({Key? key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Announcement'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where('email', isNotEqualTo: null)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No user was found.',style:TextStyle(fontSize: 18,color:Colors.blue),),
            );
          }

          List<User> users = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return User(
              id: doc.id,
              username: data['username'],
              email: data['email'],
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
                  child: Text(user.username,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                    left: 10
                  ),
                  child: Text(user.email,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostMessageScreen(email: user.email),
                          ),
                        );
                      },
                      child: const Text('Post a Message'),
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

class PostMessageScreen extends StatelessWidget {
  final String email;
  final TextEditingController _messageController = TextEditingController();

  PostMessageScreen({required this.email});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post a Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Type your message here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Save the message to Firestore
                FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).get().then((querySnapshot) {
                  querySnapshot.docs.forEach((doc) {
                    doc.reference.update({'usermessage': _messageController.text});
                  });
                }).then((_) {
                  Navigator.pop(context); // Navigate back to the previous screen
                  // Show a SnackBar to indicate successful message sending
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message sent successfully')),
                  );
                }).catchError((error) {
                  // If an error occurs during the process, show an error SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Error occurred')),
                  );
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
