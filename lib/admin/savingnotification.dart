import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String accountNumber;
  final String saveFlag;
  final String saveMessage;

  User({
    required this.id,
    required this.username,
    required this.accountNumber,
    required this.saveFlag,
    required this.saveMessage,
  });
}

class SavingNotificationListView extends StatelessWidget {
  const SavingNotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users')
            .where('saveFlag', isNotEqualTo: null)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No saving Notification  was found.',style:TextStyle(fontSize: 18,color:Colors.blue),),
            );
          }

          List<User> users = snapshot.data!.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return User(
              id: doc.id,
              username: data['username'],
              saveFlag: data['saveFlag'],
              accountNumber: data['accountNumber'],
              saveMessage: data['saveMessage'],
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right:150),
                        child: Text(user.saveFlag,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
                      ),
                      Text(user.saveMessage,style: const TextStyle(fontSize: 15,color: Colors.blue,),),
                    ],
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Confirm Delete"),
                              content: const Text("Are you sure you want to delete this this message?"),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // Close the dialog
                                  },
                                ),
                                TextButton(
                                  child: const Text("Delete"),
                                  onPressed: () {
                                    FirebaseFirestore.instance.collection('users').doc(user.id).delete();
                                    Navigator.of(context).pop(); // Close the dialog
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
    );
  }
}

