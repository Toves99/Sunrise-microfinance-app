import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:microfinance/admin/savingnotification.dart';
import 'package:microfinance/admin/userinterest.dart';
import 'package:microfinance/admin/viewusersavings.dart';
import 'package:microfinance/updateaccount.dart';
import 'package:microfinance/userlogin.dart';
import 'addusersavings.dart';


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
      home: const Savings(),
    );
  }
}

class Savings extends StatefulWidget {
  const Savings({Key? key}) : super(key: key);

  @override
  State<Savings> createState() => _SavingsState();
}

class _SavingsState extends State<Savings> {

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
                  title: Text('Manage Users savings', style: Theme.of(context).textTheme.headline6?.copyWith(
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
                  itemDashboard('Add savings',CupertinoIcons.add, Colors.deepOrange, () {
                    // Navigate to another page when My Savings is clicked
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateUserSaving()));
                  }),
                  itemDashboard('View savings', CupertinoIcons.eye, Colors.purple,(){
                    // Navigate to another page when save is clicked
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UserSavingListView()));
                  }),
                  itemDashboard('Notifications', CupertinoIcons.bell_circle, Colors.purple,(){
                    // Navigate to another page when save is clicked
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SavingNotificationListView()));
                  }),
                  itemDashboard('User interest', CupertinoIcons.money_dollar, Colors.purple,(){
                    // Navigate to another page when save is clicked
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UpdateUserInterest()));
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


}
