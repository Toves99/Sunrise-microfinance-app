import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String eventName;
  final String eventDate;
  final String eventVenue;
  final String eventDescription;

  User({
    required this.id,
    required this.eventName,
    required this.eventDate,
    required this.eventVenue,
    required this.eventDescription,
  });
}

class UserEventListView extends StatelessWidget {
  const UserEventListView({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Events'),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1.0),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users')
              .where('eventName', isNotEqualTo: null)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Event Found.',style: TextStyle(fontSize: 18,color: Colors.blue),),
              );
            }

            List<User> users = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return User(
                id: doc.id,
                eventName: data['eventName'],
                eventDate: data['eventDate'],
                eventVenue: data['eventVenue'],
                eventDescription: data['eventDescription'],
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
                    child: Text(user.eventName,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10
                        ),
                        child: Text(user.eventDate,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10
                        ),
                        child: Text(user.eventVenue,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10
                        ),
                        child: Text(user.eventDescription,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
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


