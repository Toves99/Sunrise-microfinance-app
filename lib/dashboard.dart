import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:microfinance/payloan.dart';
import 'package:microfinance/requestloan.dart';
import 'package:microfinance/save.dart';
import 'package:microfinance/savings.dart';
import 'package:microfinance/subscribenow.dart';
import 'package:microfinance/subscription.dart';
import 'package:microfinance/updateaccount.dart';
import 'package:microfinance/userlogin.dart';

import 'loanbalance.dart';
import 'loanlimit.dart';

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
      home: const Dashboard(),
    );
  }
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String? userName;

  @override
  void initState() {
    super.initState();
    retrieveUserName();
  }

  Future<void> retrieveUserName() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    String? userEmail = await secureStorage.read(key: 'userEmail');
    if (userEmail != null) {
      setState(() {
        userName = userEmail.split('@').first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
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
                    title: Text('Hello,$userName!', style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: Colors.white
                    )),
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Text('Welcome to sunrise', style: Theme.of(context).textTheme.subtitle1?.copyWith(
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
                    itemDashboard('My Savings',CupertinoIcons.money_dollar_circle, Colors.deepOrange, () {
                      // Navigate to another page when My Savings is clicked
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MySavings()));
                    }),
                    itemDashboard('Loan Bal', CupertinoIcons.checkmark_circle_fill, Colors.green,(){
                      // Navigate to another page when loan balance is clicked
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoanBalance()));
                    }),
                    itemDashboard('Save Now', CupertinoIcons.briefcase_fill, Colors.purple,(){
                      // Navigate to another page when save is clicked
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Save()));
                    }),
                    itemDashboard('Pay Loan', CupertinoIcons.creditcard_fill, Colors.brown,(){
                      // Navigate to another page when pay loan is clicked
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const PayLoan()));
                    }),
                    itemDashboard('Loan limit', CupertinoIcons.arrowshape_turn_up_left_fill, Colors.indigo,(){
                      // Navigate to another page when loan limit is clicked
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoanLimit()));
                    }),
                    itemDashboard('Request loan', CupertinoIcons.square_on_square, Colors.teal,(){
                      // Navigate to another page when request loan limit is clicked
                      Navigator.push(context, MaterialPageRoute(builder: (context) => RequestLoan()));
                    }),
                    itemDashboard('Subscrip Bal', CupertinoIcons.question_circle, Colors.blue,(){
                      // Navigate to another page when loan limit is clicked
                      Navigator.push(context, MaterialPageRoute(builder: (context) => SubBalance()));
                    }),
                    itemDashboard('Subscribe Now', CupertinoIcons.square_arrow_down, Colors.pinkAccent,(){
                      // Navigate to another page when subscribe now is clicked
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Subscribe()));
                    }),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20)
          ],
        ),
      ),
    );
  }

  Widget itemDashboard(String title, IconData iconData, Color background, Function() onTap) {
    return GestureDetector(
      onTap: onTap, // Execute onTap function when tapped
      child: Container(
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
                child: Icon(iconData, color: Colors.white)
            ),
            const SizedBox(height: 8),
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

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'),
        content: Text('Are you sure you want to exit?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // No, return to app
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              // Add logout functionality here
              Navigator.of(context).pop(true); // Yes, exit app
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()), // Replace LoginPage with your login page widget
                    (route) => false, // Remove all routes until this point
              );
            },
            child: Text('Yes'),
          ),
        ],
      ),
    ).then((value) => value ?? false);
  }
}
