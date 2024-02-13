
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dashboard.dart';

class Save extends StatefulWidget {
  const Save({super.key});

  @override
  _SaveState createState() => _SaveState();
}

class _SaveState extends State<Save> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  TextEditingController mpesaMessageController = TextEditingController();


  @override
  void initState() {
    super.initState();
  }

  void sentMessage() async {
    String? accountNumber = await secureStorage.read(key: 'accountNumber');

    if (accountNumber != null) {
      String enteredMessage = mpesaMessageController.text;
      String saveFlag='Save message';
      if (enteredMessage.isNotEmpty) {
        try {
          // Query Firestore to find the document where accountNumber matches
          QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
              .collection('users')
              .where('accountNumber', isEqualTo: accountNumber)
              .get();

          // Check if any document found
          if (querySnapshot.docs.isNotEmpty) {
            // Update the first document found (assuming accountNumber is unique)
            await querySnapshot.docs.first.reference.update({'saveMessage': enteredMessage});
            await querySnapshot.docs.first.reference.update({'saveFlag': saveFlag});

            showSnackBar('Message sent successfully');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dashboard(),
              ),
            );
          } else {
            showSnackBar('User not found');
          }
        } catch (e) {
          showSnackBar('Error senting message: $e');
        }
      } else {
        showSnackBar('Please paste message');
      }
    } else {
      showSnackBar('Account number not available');
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
        title: const Text('Save',style: TextStyle(fontSize: 18,color:Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 224, 118, 9),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Image.asset('assets/logo.png', height: 90, width: 100),
            )),
            const SizedBox(height: 20),
            const Text('Follow the below steps to save!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color:Colors.orange),),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 10,
              ),
              child: Text('1.Open your Mpesa App on your phone.\n2.Select Lipa na Mpesa.\n3.Select Buy Goods and Services\n4.Enter this Till Number:9988947\n5.Enter amount\n6.Enter your pin\n7.Copy Mpesa message from safaricom\n8.Paste in below textbox then press sent button',style: TextStyle(fontSize: 17,color:Colors.blue),),
            ),
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
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              controller: mpesaMessageController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: 'Paste here Mpesa message',
                                prefixIcon: Icon(Icons.content_paste),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please paste here Mpesa message' : null;
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
                          sentMessage();
                        },
                        color: const Color.fromARGB(255, 224, 118, 9),
                        height: 40,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Send',
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
    home:Save(),
  ));
}