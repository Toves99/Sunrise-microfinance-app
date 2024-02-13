import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String generalAnnouncement;

  User({
    required this.id,
    required this.generalAnnouncement,
  });
}

class GeneralListView extends StatefulWidget {
  const GeneralListView({Key? key}) : super(key: key);

  @override
  _GeneralListViewState createState() => _GeneralListViewState();
}

class _GeneralListViewState extends State<GeneralListView> {
  List<User> _users = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Events'),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300,width:1.0), // Adding border with light grey color
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users')
              .where('generalAnnouncement', isNotEqualTo: null)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No notifications yet.',style: TextStyle(fontSize: 18,color: Colors.blue),),
              );
            }

            _users = snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return User(
                id: doc.id,
                generalAnnouncement: data['generalAnnouncement'],
              );
            }).toList();

            return ListView.builder(
              itemCount: _users.length,
              itemBuilder: (context, index) {
                final user = _users[index];
                return ListTile(
                  title: Padding(
                    padding: const EdgeInsets.only(
                        left: 10
                    ),
                    child: Text(user.generalAnnouncement,style: const TextStyle(fontSize: 15,color: Colors.blue,fontWeight: FontWeight.bold),),
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

void main() {
  runApp(const MaterialApp(
    home: GeneralListView(),
  ));
}
