
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dashboard.dart';

class Subscribe extends StatefulWidget {
  const Subscribe({super.key});

  @override
  _SubscribeState createState() => _SubscribeState();
}

class _SubscribeState extends State<Subscribe> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  TextEditingController mpesaMessageController = TextEditingController();
  String? accountNumber;

  @override
  void initState() {
    super.initState();
    // Retrieve account number from secure storage
    retrieveAccountNumber();
  }

  void retrieveAccountNumber() async {
    String? storedAccountNumber = await secureStorage.read(key: 'accountNumber');
    setState(() {
      accountNumber = storedAccountNumber;
    });
  }


  void requestLoan() async {
    if (accountNumber != null) {
      String message = mpesaMessageController.text;
      if (message.isNotEmpty) {
        try {
          // Insert amount into Firestore
          await FirebaseFirestore.instance
              .collection('users') // Assuming 'users' is the collection name
              .doc(accountNumber) // Assuming accountNumber is the document ID
              .set({'mpesaMessage': message}, SetOptions(merge: true));
          showSnackBar('Message sent successfully');
          Navigator.push(
            context,
            MaterialPageRoute(builder:
                (context)=>Dashboard()),
          );
        } catch (e) {
          showSnackBar('Error occurred: $e');
        }
      } else {
        showSnackBar('Error occurred');
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

        content: Center( // Center-align the text
          child: Text(
            message,style: const TextStyle(color:Colors.orange,fontSize: 20),
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
        title: const Text('Pay subscription fee',style: TextStyle(fontSize: 16,color:Colors.white),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 224, 118, 9),
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
            const Text('Follow the below steps to pay subscription fee!',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color:Colors.orange),),
            const SizedBox(height: 10),
            const Text('1.Open your Mpesa App on your phone.\n2.Select Lipa na Mpesa.\n3.Select Buy Goods and Services\n4.Enter this Till Number:9988947\n5.Enter amount\n6.Enter your pin\n7.Copy Mpesa message from safaricom\n8.Paste in below textbox then press sent button',style: TextStyle(fontSize: 17,color:Colors.blue),),
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
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Paste here Mpesa message',
                                prefixIcon: Icon(Icons.credit_card),
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
                          //checkAccountNumber();
                        },
                        color: const Color.fromARGB(255, 224, 118, 9),
                        height: 40,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Sent',
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
    home:Subscribe(),
  ));
}