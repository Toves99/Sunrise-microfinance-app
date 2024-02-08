import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:microfinance/subscribenow.dart';

class SubBalance extends StatefulWidget {
  @override
  State<SubBalance> createState() => _SubBalance();
}

class _SubBalance extends State<SubBalance> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late String? accountNumber;
  String? subscriptionBalance;

  @override
  void initState() {
    super.initState();
    fetchsubscriptionBalance();
  }
  Future<void> fetchsubscriptionBalance() async {
    // Retrieve account number from secure storage
    accountNumber = await secureStorage.read(key: 'accountNumber');

    if (accountNumber != null) {
      // Query Firestore to get the ledger balance based on the account number
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('accountNumber', isEqualTo: accountNumber)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Retrieve ledger balance from the document
        subscriptionBalance = snapshot.docs.first.get('subscriptionBalance').toString();
        setState(() {}); // Update the UI with the fetched data
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription Balance',style: TextStyle(fontSize: 16,color:Colors.white),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 224, 118, 9),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: Image.asset('assets/logo.png', height: 90, width: 100),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  right: 30,
                  top:50
              ),
              child: Text(
                'Subscription Balance.',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Garamond',
                  color: Color.fromARGB(255, 224, 118, 9),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(
                  right: 30,
                  top:5
              ),
              child: Text(
                subscriptionBalance ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Garamond',
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            const SizedBox(height: 30),
            if (subscriptionBalance == null || (double.tryParse(subscriptionBalance!) ?? 0) <= 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:
                          (context)=>const Subscribe()),
                    );
                  },
                  color: const Color.fromARGB(255, 224, 118, 9),
                  height: 40,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Subscribe Now',
                  ),
                ),
              ),





          ],
        ),
      ),
    );
  }
}
