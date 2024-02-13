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

class EventListView extends StatelessWidget {
  const EventListView({Key? key});

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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        color: Colors.blue,
                        onPressed: () {
                          // Navigate to EditEventPage when edit button is clicked
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => EditEventPage(
                                eventId: user.id,
                                eventName: user.eventName,
                                eventDate: user.eventDate,
                                eventVenue: user.eventVenue,
                                eventDescription: user.eventDescription,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.blue,
                        onPressed: () {
                          // Show a confirmation dialog before deleting
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Delete Event"),
                                content: Text("Are you sure you want to delete this event?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Delete the event and pop the dialog
                                      FirebaseFirestore.instance.collection('users').doc(user.id).delete();
                                      Navigator.pop(context);
                                    },
                                    child: Text("Delete"),
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

class EditEventPage extends StatefulWidget {
  final String eventId;
  final String eventName;
  final String eventDate;
  final String eventVenue;
  final String eventDescription;

  EditEventPage({
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventVenue,
    required this.eventDescription,
  });

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late TextEditingController nameController;
  late TextEditingController dateController;
  late TextEditingController venueController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.eventName);
    dateController = TextEditingController(text: widget.eventDate);
    venueController = TextEditingController(text: widget.eventVenue);
    descriptionController = TextEditingController(text: widget.eventDescription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            TextField(
              controller: dateController,
              decoration: InputDecoration(labelText: 'Event Date'),
            ),
            TextField(
              controller: venueController,
              decoration: InputDecoration(labelText: 'Event Venue'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Event Description'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Update the event details
                FirebaseFirestore.instance.collection('users').doc(widget.eventId).update({
                  'eventName': nameController.text,
                  'eventDate': dateController.text,
                  'eventVenue': venueController.text,
                  'eventDescription': descriptionController.text,
                }).then((value) {
                  // Show a message or navigate back
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Event updated')));
                  Navigator.pop(context);
                }).catchError((error) {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update event')));
                });
              },
              child: Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    dateController.dispose();
    venueController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: EventListView(),
  ));
}
