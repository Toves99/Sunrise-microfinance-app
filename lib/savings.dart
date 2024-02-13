import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:microfinance/save.dart';

class MySavings extends StatefulWidget {
  @override
  State<MySavings> createState() => _MySavingsState();
}

class _MySavingsState extends State<MySavings> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  late String? accountNumber='Loading...';
  String? savingAmount;


  @override
  void initState() {
    super.initState();
    fetchLedgerBalance();
  }

  Future<void> fetchLedgerBalance() async {
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
        savingAmount = snapshot.docs.first.get('savingAmount').toString();
        setState(() {}); // Update the UI with the fetched data
      }
    }
  }

  void saveNow(){
    Navigator.push(
      context,
      MaterialPageRoute(builder:
          (context)=>const Save()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Savings',
          style: TextStyle(fontSize: 18, color: Colors.white,fontWeight: FontWeight.bold),
        ),
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
                    'Account No:',
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
                    accountNumber == null ? 'Loading...' :accountNumber ?? '',
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




            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      left: 70,
                      top: 20
                  ),
                  child: Text(
                    'Ledger Balance:',
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
                    savingAmount == null ? 'Loading...' :'KSH ${savingAmount ?? ''}',
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

            Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                      left: 70,
                      top: 20
                  ),
                  child: Text(
                    'Total Balance:',
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
                    savingAmount == null ? 'Loading...' :'KSH ${savingAmount ?? ''}',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: MaterialButton(
                minWidth: double.infinity,
                onPressed: () {
                  saveNow();
                },
                child: Text('Save Now'),
                color: Color.fromARGB(255, 224, 118, 9),
                height: 40,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
