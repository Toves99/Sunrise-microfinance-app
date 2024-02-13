import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'dashboard.dart';




class Accountno extends StatefulWidget {
  const Accountno({super.key});

  @override
  _AccountnoState createState() => _AccountnoState();
}

class _AccountnoState extends State<Accountno> {

  TextEditingController accountController = TextEditingController();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<void> checkAccountNumber() async {
    String enteredAccountNumber = accountController.text.trim();

    // Retrieve the stored email from the session
    String? storedEmail = await secureStorage.read(key: 'userEmail');
    if (storedEmail == null) {
      // If email is not found in the session, show an error message
      showSnackBar('Session expired or email not found. Please login again.');
      return;
    }

    // Query Firestore to check if the entered account number exists
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: storedEmail)
        .where('accountNumber', isEqualTo: enteredAccountNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await secureStorage.write(key: 'accountNumber', value: enteredAccountNumber);
      // Account number exists for the stored email, navigate to dashboard
      showSnackBar('Verification Success....!');
      await Future.delayed(Duration(seconds: 1));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      // Account number doesn't exist for the stored email, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Account Number does not exist'),
          content: const Text('Please try again or contact Admin.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
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
        title: const Text('Verify your account',style: TextStyle(fontSize: 18,color:Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 224, 118, 9),
        iconTheme: const IconThemeData(color: Colors.white),
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
            const Text('Verify your account number!',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color:Colors.orange),),
            const SizedBox(height: 10),
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
                              controller: accountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Enter Account Number',
                                prefixIcon: Icon(Icons.credit_card),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please enter account No.' : null;
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
                          checkAccountNumber();
                        },
                        color: const Color.fromARGB(255, 224, 118, 9),
                        height: 40,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Verify',
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
      debugShowCheckedModeBanner: false,
    home:Accountno(),
  ));
}