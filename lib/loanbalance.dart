import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:microfinance/payloan.dart';
import 'package:microfinance/requestloan.dart';

class LoanBalance extends StatefulWidget {
  @override
  State<LoanBalance> createState() => _LoanBalance();
}

class _LoanBalance extends State<LoanBalance> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late String? accountNumber;
  String? loanBalance;
  String? requestedDate;
  String? paymentDate;

  @override
  void initState() {
    super.initState();
    fetchLoanBalance();
  }

  Future<void> fetchLoanBalance() async {
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
        loanBalance = snapshot.docs.first.get('loanBalance').toString();
        requestedDate = snapshot.docs.first.get('requestloandate').toString();
        paymentDate = snapshot.docs.first.get('loanpaymentdate').toString();
        setState(() {}); // Update the UI with the fetched data
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan balance',style: TextStyle(fontSize: 16,color:Colors.white),),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 224, 118, 9),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image.asset('assets/logo.png', height: 90, width: 100),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  right: 30,
                  top:20
              ),
              child: Text(
                'Loan Balance.',
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
                loanBalance ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Garamond',
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),


            const Padding(
              padding: EdgeInsets.only(
                  right: 30,
                  top:20
              ),
              child: Text(
                'Requested date.',
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
                requestedDate ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Garamond',
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(
                  right: 40,
                  top:20
              ),
              child: Text(
                'Payment date.',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Garamond',
                    color: Color.fromARGB(255, 224, 118, 9),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  right: 40,
                  top:5
              ),
              child: Text(
                paymentDate ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Garamond',
                    color: Colors.black,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),


            const SizedBox(height: 30),
            if (loanBalance != null && (double.tryParse(loanBalance!) ?? 0) > 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:
                          (context)=>const PayLoan()),
                    );
                  },
                  color: const Color.fromARGB(255, 224, 118, 9),
                  height: 40,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Pay Now',
                  ),
                ),
              ),
            if (loanBalance == null || (double.tryParse(loanBalance!) ?? 0) <= 0)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: MaterialButton(
                  minWidth: double.infinity,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:
                          (context)=>const RequestLoan()),
                    );
                  },
                  color: const Color.fromARGB(255, 224, 118, 9),
                  height: 40,
                  textColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Request Loan',
                  ),
                ),
              ),


          ],
        ),
      ),
    );
  }
}
