import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:microfinance/requestloan.dart';

class LoanLimit extends StatefulWidget {
  @override
  State<LoanLimit> createState() => _LoanLimit();
}

class _LoanLimit extends State<LoanLimit> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late String? accountNumber;
  String? loanLimit;


  @override
  void initState() {
    super.initState();
    fetchLoanLimit();
  }

  Future<void> fetchLoanLimit() async {
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
        loanLimit = snapshot.docs.first.get('loanLimit').toString();
        setState(() {}); // Update the UI with the fetched data
      }
    }
  }

  void requestLoan(){
    Navigator.push(
      context,
      MaterialPageRoute(builder:
          (context)=>const RequestLoan()),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Limit',style: TextStyle(fontSize: 18,color: Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 224, 118, 9),
        iconTheme: const IconThemeData(color: Colors.white),
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
                'Loan Limit Balance.',
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
                loanLimit == null ? 'Loading...' :'KSH ${loanLimit ?? ''}',
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Garamond',
                    color: Colors.blue,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
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
                  'Request Now',
                ),
              ),
            ),




          ],
        ),
      ),
    );
  }
}
