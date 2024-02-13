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
  String? loanAmount;
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
        loanAmount = snapshot.docs.first.get('loanAmount').toString();
        requestedDate = snapshot.docs.first.get('requestedDate').toString();
        paymentDate = snapshot.docs.first.get('paymentDate').toString();
        setState(() {}); // Update the UI with the fetched data
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan balance',style: TextStyle(fontSize: 18,color:Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 224, 118, 9),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Image.asset('assets/logo.png', height: 90, width: 100),
            ),
            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      left: 70,
                      top: 40
                  ),
                  child: Text(
                    'Loan Balance:',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'Garamond',
                      color: Color.fromARGB(255, 224, 118, 9),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10,
                      top: 40
                  ),
                  child: Text(
                    loanAmount == null ? 'Loading...' :'KSH ${loanAmount ?? ''}',
                    style: const TextStyle(
                        fontSize: 17,
                        fontFamily: 'Garamond',
                        color: Colors.blue,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),

            if (loanAmount != null && (double.tryParse(loanAmount!) ?? 0) > 0)
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 70,
                        top: 20
                    ),
                    child: Text(
                      'Request Date:',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Garamond',
                        color: Color.fromARGB(255, 224, 118, 9),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10,
                        top: 20
                    ),
                    child: Text(
                      requestedDate == null ? 'Loading...' :requestedDate ?? '',
                      style: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'Garamond',
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),

            if (loanAmount != null && (double.tryParse(loanAmount!) ?? 0) > 0)
              Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 70,
                        top: 20
                    ),
                    child: Text(
                      'Payment Date:',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Garamond',
                        color: Color.fromARGB(255, 224, 118, 9),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10,
                        top: 20
                    ),
                    child: Text(
                      paymentDate == null ? 'Loading...' :paymentDate ?? '',
                      style: const TextStyle(
                          fontSize: 17,
                          fontFamily: 'Garamond',
                          color: Colors.blue,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),



            const SizedBox(height: 30),
            if (loanAmount != null && (double.tryParse(loanAmount!) ?? 0) > 0)
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
            if (loanAmount == null || (double.tryParse(loanAmount!) ?? 0) <= 0)
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
