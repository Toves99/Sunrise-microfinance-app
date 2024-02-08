import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'dashboard.dart';

class RequestLoan extends StatefulWidget {
  const RequestLoan({super.key});

  @override
  _RequestLoanState createState() => _RequestLoanState();
}

class _RequestLoanState extends State<RequestLoan> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  TextEditingController amountController = TextEditingController();
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
      String enteredAmount = amountController.text;
      if (enteredAmount.isNotEmpty) {
        try {
          // Insert amount into Firestore
          await FirebaseFirestore.instance
              .collection('users') // Assuming 'users' is the collection name
              .doc(accountNumber) // Assuming accountNumber is the document ID
              .set({'requestedUserLoan': enteredAmount}, SetOptions(merge: true));
          showSnackBar('Loan requested successfully');
          Navigator.push(
            context,
            MaterialPageRoute(builder:
                (context)=>Dashboard()),
          );
        } catch (e) {
          showSnackBar('Error requesting loan: $e');
        }
      } else {
        showSnackBar('Please enter amount');
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
        title: const Text('Request Loan',style: TextStyle(fontSize: 16),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 224, 118, 9),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Image.asset('assets/logo.png', height: 90, width: 100),
            )),
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
                              controller: amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Enter Amount to request',
                                prefixIcon: Icon(Icons.attach_money),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please enter Enter amount' : null;
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
                          requestLoan();
                        },
                        color: const Color.fromARGB(255, 224, 118, 9),
                        height: 40,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Request loan',
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
    home:RequestLoan(),
  ));
}
