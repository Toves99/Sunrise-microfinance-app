import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore

import 'package:microfinance/updateaccount.dart';
import 'package:microfinance/userlogin.dart';
import 'package:microfinance/withdrawnotifications.dart';

import 'generalnotification.dart';
import 'loannotifications.dart';
import 'mynotification.dart';


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
      home: const Notifications(),
    );
  }
}

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String? userName;
  int loansCount = 0; // Initialize loans count
  int withdrawCount=0;
  int generalAnnouncement=0;
  int myNotification=0;

  @override
  void initState() {
    super.initState();
    retrieveUserName();
    fetchLoansCount(); // Call function to fetch loans count
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

  Future<void> fetchLoansCount() async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    String? accountNumber = await secureStorage.read(key: 'accountNumber');
    if (accountNumber != null) {
      // Query Firestore to get the count of loanRespondStatus
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('accountNumber', isEqualTo: accountNumber)
          .get();
      int count = 0;
      for (QueryDocumentSnapshot<Map<String, dynamic>> document in querySnapshot.docs) {
        String loanRespondStatus = document['loanRespondStatus'];
        // Increment count if loanRespondStatus is not empty
        if (loanRespondStatus.isNotEmpty) {
          count++;
        }
      }
      setState(() {
        loansCount = count;
      });
    }
  }


  Future<void> fetchWithdrawCount() async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    String? accountNumber = await secureStorage.read(key: 'accountNumber');
    if (accountNumber != null) {
      // Query Firestore to get the count of loanRespondStatus
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('accountNumber', isEqualTo: accountNumber)
          .get();
      int count = 0;
      for (QueryDocumentSnapshot<Map<String, dynamic>> document in querySnapshot.docs) {
        String withdrawStatus = document['withdrawStatus'];
        // Increment count if loanRespondStatus is not empty
        if (withdrawStatus.isNotEmpty) {
          count++;
        }
      }
      setState(() {
        withdrawCount = count;
      });
    }
  }

  Future<void> fetchGeneralCount() async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    String? accountNumber = await secureStorage.read(key: 'accountNumber');
    if (accountNumber != null) {
      // Query Firestore to get the count of loanRespondStatus
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('accountNumber', isEqualTo: accountNumber)
          .get();
      int count = 0;
      for (QueryDocumentSnapshot<Map<String, dynamic>> document in querySnapshot.docs) {
        String generalAnnouncement = document['generalAnnouncement'];
        // Increment count if loanRespondStatus is not empty
        if (generalAnnouncement.isNotEmpty) {
          count++;
        }
      }
      setState(() {
        generalAnnouncement = count;
      });
    }
  }

  Future<void> fetchMyNotification() async {
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    String? accountNumber = await secureStorage.read(key: 'accountNumber');
    if (accountNumber != null) {
      // Query Firestore to get the count of loanRespondStatus
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('accountNumber', isEqualTo: accountNumber)
          .get();
      int count = 0;
      for (QueryDocumentSnapshot<Map<String, dynamic>> document in querySnapshot.docs) {
        String usermessage = document['usermessage'];
        // Increment count if loanRespondStatus is not empty
        if (usermessage.isNotEmpty) {
          count++;
        }
      }
      setState(() {
        myNotification = count;
      });
    }
  }

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
                  title: Text('Notifications', style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white)),
                  subtitle: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Text('Choose below', style: Theme.of(context).textTheme.subtitle1?.copyWith(color: Colors.white54)),
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
                  itemDashboard('Loans', CupertinoIcons.bell_circle, Colors.deepOrange, loansCount.toString(), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoanNotificationListView()));
                  }),
                  itemDashboard('WithDraw', CupertinoIcons.bell_circle, Colors.green,withdrawCount.toString(),( ) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => WithDrawNotificationListView()));
                  }),
                  itemDashboard('General', CupertinoIcons.bell_circle, Colors.brown,generalAnnouncement.toString(), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const GeneralListView()));
                  }),
                  itemDashboard('My Notifications', CupertinoIcons.bell_circle, Colors.yellow,myNotification.toString(), () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const UserNotificationListView()));
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

  Widget itemDashboard(String title, IconData iconData, Color background, String? count, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
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
            Text(title.toUpperCase(), style: Theme.of(context).textTheme.subtitle2),
            Text(count ?? '', style:const TextStyle(color: Colors.red,)), // Display count
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
                title: const Text('Update Account'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Update()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.help),
                title: const Text('Help'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
