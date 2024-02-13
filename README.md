import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CreateEvent extends StatefulWidget {
const CreateEvent({Key? key});

@override
_CreateEventState createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
TextEditingController nameController = TextEditingController();
TextEditingController dateController = TextEditingController();
TextEditingController venueController = TextEditingController();
TextEditingController descriptionController = TextEditingController();

Future<void> postMessage(String name, String date, String venue, String description) async {
try {
// Add a new document with a generated id
await FirebaseFirestore.instance.collection('users').add({
'eventName': name,
'eventDate': date,
'eventVenue': venue,
'eventDescription': description,
});
// Show a SnackBar to indicate successful event addition
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('Event added successfully')),
);
} catch (e) {
// Show a SnackBar to indicate error
ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(content: Text('An error occurred')),
);
}
}

// Method to show a SnackBar
void showSnackBar(String message) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
backgroundColor: Colors.white,
content: Center(
// Center-align the text
child: Text(
message,
style: const TextStyle(color: Colors.orange, fontSize: 20),
textAlign: TextAlign.center,
),
),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text(
'Create Event',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Colors.white,
),
),
centerTitle: false,
backgroundColor: const Color.fromARGB(255, 224, 118, 9),
iconTheme: const IconThemeData(color: Colors.white),
),
body: SingleChildScrollView(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Center(
child: Padding(
padding: const EdgeInsets.only(top: 50),
child: Image.asset('assets/logo.png', height: 90, width: 100),
),
),
const SizedBox(height: 20),
Padding(
padding: const EdgeInsets.symmetric(vertical: 30),
child: Form(
child: Column(
children: [
Padding(
padding: const EdgeInsets.symmetric(horizontal: 20),
child: Padding(
padding: const EdgeInsets.symmetric(vertical: 5),
child: Container(
height: 50,
decoration: BoxDecoration(
color: Colors.grey[200],
border: Border.all(
color: Colors.transparent,
),
borderRadius: BorderRadius.circular(8),
),
child: Padding(
padding: const EdgeInsets.symmetric(vertical: 5),
child: TextFormField(
controller: nameController,
keyboardType: TextInputType.text,
decoration: const InputDecoration(
labelText: 'Enter event name',
prefixIcon: Icon(Icons.event),
border: InputBorder.none,
contentPadding: EdgeInsets.symmetric(horizontal: 10),
isDense: true,
),
onChanged: (String value) {},
validator: (value) {
return value!.isEmpty ? 'Please enter event name' : null;
},
),
),
),
),
),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              controller: dateController,
                              keyboardType: TextInputType.datetime,
                              decoration: const InputDecoration(
                                labelText: 'Enter event date',
                                prefixIcon: Icon(Icons.calendar_month),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please enter event date' : null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              controller: venueController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: 'Enter the venue',
                                prefixIcon: Icon(Icons.place),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please enter the venue' : null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),


                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            border: Border.all(
                              color: Colors.transparent,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: TextFormField(
                              controller: descriptionController,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: 'Please describe your event',
                                prefixIcon: Icon(Icons.description),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please enter description' : null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () {
                          final name = nameController.text;
                          final date = dateController.text;
                          final venue = venueController.text;
                          final description = descriptionController.text;
                          postMessage(name,date,venue,description);
                        },
                        color: const Color.fromARGB(255, 224, 118, 9),
                        height: 40,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Create',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
}
}

Future<void> main() async {
runApp(const MaterialApp(
home: CreateEvent(),
));
notifications users
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:microfinance/payloan.dart';
import 'package:microfinance/requestloan.dart';
import 'package:microfinance/save.dart';
import 'package:microfinance/savings.dart';
import 'package:microfinance/interest.dart';
import 'package:microfinance/withdraw.dart';
import 'package:microfinance/updateaccount.dart';
import 'package:microfinance/userlogin.dart';
import 'package:microfinance/withdrawnotifications.dart';

import 'generalnotification.dart';
import 'loanbalance.dart';
import 'loanlimit.dart';
import 'loannotifications.dart';
import 'mynotification.dart';
import 'notifications.dart';

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
userName = userEmail
.split('@')
.first;
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
title: Text('Notifications', style: Theme
.of(context)
.textTheme
.headline6
?.copyWith(
color: Colors.white
)),
subtitle: Padding(
padding: const EdgeInsets.symmetric(vertical: 5),
child: Text('Choose below', style: Theme
.of(context)
.textTheme
.subtitle1
?.copyWith(
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
itemDashboard('Loans',
CupertinoIcons.bell_circle,
Colors.deepOrange, () {
// Navigate to another page when My Savings is clicked
Navigator.push(context, MaterialPageRoute(builder: (
context) => LoanNotificationListView()));
}),
itemDashboard('WithDraw',
CupertinoIcons.bell_circle, Colors.green, () {
// Navigate to another page when loan balance is clicked
Navigator.push(context, MaterialPageRoute(builder: (
context) => WithDrawNotificationListView()));
}),
itemDashboard(
'General', CupertinoIcons.bell_circle,
Colors.brown, () {
// Navigate to another page when pay loan is clicked
Navigator.push(context, MaterialPageRoute(builder: (
context) => const GeneralListView()));
}),
itemDashboard(
'My Notifications', CupertinoIcons.bell_circle,
Colors.yellow, () {
// Navigate to another page when pay loan is clicked
Navigator.push(context, MaterialPageRoute(builder: (
context) => const UserNotificationListView()));
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

Widget itemDashboard(String title, IconData iconData, Color background,
Function() onTap) {
return GestureDetector(
onTap: onTap, // Execute onTap function when tapped
child: Container(
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(10),
boxShadow: [
BoxShadow(
offset: const Offset(0, 5),
color: Theme
.of(context)
.primaryColor
.withOpacity(.2),
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
Text(title.toUpperCase(), style: Theme
.of(context)
.textTheme
.subtitle2)
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
// Add functionality for updating account
Navigator.push(
context,
MaterialPageRoute(builder:
(context) => Update()),
);
},
),
ListTile(

                leading: const Icon(Icons.help),
                title: const Text('Help'),
                onTap: () {
                  // Add functionality for settings
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                onTap: () {
                  // Add functionality for logout
                  Navigator.pop(context);
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    // Replace LoginPage with your login page widget
                        (route) => false, // Remove all routes until this point
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
