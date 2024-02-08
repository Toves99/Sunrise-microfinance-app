import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MySavings extends StatefulWidget {
  @override
  State<MySavings> createState() => _MySavingsState();
}

class _MySavingsState extends State<MySavings> {
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  String _accountNumber = '';
  int _ledgerBalance = 0;

  @override
  void initState() {
    super.initState();
    _getAccountNumber();
  }

  void _getAccountNumber() async {
    String? accountNumber = await _storage.read(key: 'accountNumber');
    setState(() {
      _accountNumber = accountNumber ?? '';
    });
    _fetchLedgerBalance();
  }

  void _fetchLedgerBalance() async {
    if (_accountNumber.isNotEmpty) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(_accountNumber)
          .get();
      setState(() {
        _ledgerBalance = snapshot['ledgerBalance'] ?? 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Savings',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
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
              padding: EdgeInsets.only(right: 30, top: 20),
              child: Text(
                'Account Number.',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Garamond',
                  color: Color.fromARGB(255, 224, 118, 9),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, top: 5),
              child: Text(
                _accountNumber,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Garamond',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 30, top: 20),
              child: Text(
                'Ledger Balance.',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Garamond',
                  color: Color.fromARGB(255, 224, 118, 9),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30, top: 5),
              child: Text(
                '$_ledgerBalance',
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Garamond',
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: MaterialButton(
                minWidth: double.infinity,
                onPressed: () {
                  // Save Now Button Clicked
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
