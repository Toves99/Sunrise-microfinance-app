import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Generalannouncement extends StatefulWidget {
  const Generalannouncement({Key? key});

  @override
  _GeneralannouncementState createState() => _GeneralannouncementState();
}

class _GeneralannouncementState extends State<Generalannouncement> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  TextEditingController messageController = TextEditingController();

  Future<void> postMessage(String message) async {
    try {
      // Add a new document with a generated id
      await FirebaseFirestore.instance.collection('users').add({
        'generalAnnouncement': message,
      });
      showSnackBar('Announcement  sent successfully');
    } catch (e) {
      showSnackBar('Error occurred while sending announcement: $e');
    }
  }

  // Method to show a SnackBar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Center(
          // Center-align the text
          child: Text(
            message,
            style: const TextStyle(color: Colors.orange, fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'General announcement',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 224, 118, 9),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset('assets/logo.png', height: 90, width: 100),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Form(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 100, // Increased height to accommodate more text
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              controller: messageController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null, // Allow multiline input
                              decoration: const InputDecoration(
                                labelText: 'Type announcement here',
                                prefixIcon: Icon(Icons.message),
                                border: InputBorder.none,
                                contentPadding:
                                EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please type announcement here' : null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () {
                          final message = messageController.text;
                          postMessage(message);
                        },
                        color: const Color.fromARGB(255, 224, 118, 9),
                        height: 40,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Post',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> main() async {
  runApp(const MaterialApp(
    home: Generalannouncement(),
  ));
}
