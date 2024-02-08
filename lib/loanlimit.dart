import 'package:flutter/material.dart';

class LoanLimit extends StatefulWidget {
  @override
  State<LoanLimit> createState() => _LoanLimit();
}

class _LoanLimit extends State<LoanLimit> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Limit',style: TextStyle(fontSize: 16),),
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
                'Loan Limit Balance.',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Garamond',
                  color: Color.fromARGB(255, 224, 118, 9),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.only(
                  right: 30,
                  top:5
              ),
              child: Text(
                'Ksh 15000.000',
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Garamond',
                    color: Colors.black,
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
                  //save
                },
                child: Text(
                  'Request Now',
                ),
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
