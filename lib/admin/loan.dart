import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:microfinance/admin/responduserloanrequest.dart';
import 'package:microfinance/admin/responduserwithdrawrequest.dart';
import 'package:microfinance/admin/viewuserloanlimit.dart';
import 'package:microfinance/admin/viewusersloan.dart';
import 'package:microfinance/payloan.dart';
import 'package:microfinance/requestloan.dart';
import 'package:microfinance/save.dart';
import 'package:microfinance/savings.dart';
import 'package:microfinance/interest.dart';
import 'package:microfinance/withdraw.dart';
import 'package:microfinance/updateaccount.dart';
import 'package:microfinance/userlogin.dart';

import '../loanbalance.dart';
import '../loanlimit.dart';
import 'adduserloanlimit.dart';
import 'addusersloans.dart';
import 'loanpaymentnotification.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const Loan(),
    );
  }
}

class Loan extends StatefulWidget {
  const Loan({Key? key}) : super(key: key);

  @override
  State<Loan> createState() => _LoanState();
}

class _LoanState extends State<Loan> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 50),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                  title: Text('Manage Users loans', style: Theme.of(context).textTheme.headline6?.copyWith(
                      color: Colors.white
                  )),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text('Select action below', style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: Colors.white54
                    )),
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      _showAccountMenu(context);
                    },
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.orange,
                      backgroundImage: AssetImage('assets/account.png'),
                    ),
                  ),
                ),
                const SizedBox(height: 30)
              ],
            ),
          ),
          Container(
            color: Colors.orange,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200)
                  )
              ),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 40,
                mainAxisSpacing: 30,
                children: [
                  itemDashboard('Add loans',CupertinoIcons.add, Colors.deepOrange, () {
                    // Navigate to another page when My Savings is clicked
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateUserLoan()));
                  }),
                  itemDashboard('View loans', CupertinoIcons.eye_fill, Colors.green,(){
                    // Navigate to another page when loan balance is clicked
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UserLoanListView()));
                  }),
                  itemDashboard('Loan limits', CupertinoIcons.add, Colors.purple,(){
                    // Navigate to another page when save is clicked
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateUserLoanLimit()));
                  }),
                  itemDashboard('View loan limits', CupertinoIcons.eye, Colors.blue,(){
                    // Navigate to another page when save is clicked
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UserLoanLimitListView()));
                  }),
                  itemDashboard('Loans requests', CupertinoIcons.forward, Colors.orange,(){
                    // Navigate to another page when save is clicked
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RespondToLoanRequest()));
                  }),
                  itemDashboard('withdraw requests', CupertinoIcons.forward, Colors.yellow,(){
                    // Navigate to another page when save is clicked
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const RespondToWithdrawRequest()));
                  }),
                  itemDashboard('payment notification', CupertinoIcons.forward, Colors.green,(){
                    // Navigate to another page when save is clicked
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const PayLoanNotificationListView()));
                  }),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget itemDashboard(String title, IconData iconData, Color background, Function() onTap) {
    return GestureDetector(
      onTap: onTap, // Execute onTap function when tapped
      child: Container(
        width: 100, // Adjust the width
        height: 100, // Adjust the height
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  offset: const Offset(0, 5),
                  color: Theme.of(context).primaryColor.withOpacity(.2),
                  spreadRadius: 2,
                  blurRadius: 5
              )
            ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: background,
                  shape: BoxShape.circle,
                ),
                child: Icon(iconData, color: Colors.white,size: 23)
            ),
            const SizedBox(height: 4),
            Text(title.toUpperCase(), style: Theme.of(context).textTheme.subtitle2)
          ],
        ),
      ),
    );
  }


  void _showAccountMenu(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Update Account'),
                onTap: () {
                  // Add functionality for updating account
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder:
                        (context)=>Update()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Add functionality for settings
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  // Add functionality for logout
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()), // Replace LoginPage with your login page widget
                        (route) => false, // Remove all routes until this point
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.notifications),
                title: const Text('Notification'),
                onTap: () {
                  // Add functionality for logout
                  Navigator.pop(context);

                },
              ),
            ],
          ),
        );
      },
    );
  }


}
