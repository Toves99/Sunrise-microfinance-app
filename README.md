import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:microfinance/usersignin.dart';


import 'account.dart';
import 'dashboard.dart';
import 'firebase_services.dart';

class LoginPage extends StatefulWidget {
const LoginPage({super.key});

@override
_LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
final FirebaseAuthService  auth = FirebaseAuthService();
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
bool isPasswordVisible = false;

Future<void> validateUser() async {
String email=emailController.text;
String password=passwordController.text;
try {
User? user = await auth.signInWithEmailAndPassword(email, password);
if(user!=null){
await secureStorage.write(key: 'userEmail', value: email);
// Show a success message        showSnackBar('Please wait....!');

        await Future.delayed(Duration(seconds: 2));

        Navigator.push(
          context,
          MaterialPageRoute(builder:
              (context)=>Accountno()),
        );
      }
      else{
        showSnackBar('Invalid details try again!');
        emailController.clear();
        passwordController.clear();
      }
    }catch(error){
      showSnackBar('Error occurred: $error');
      emailController.clear();
      passwordController.clear();
    }


}

// Method to show a SnackBar
void showSnackBar(String message) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
backgroundColor: Colors.white,

        content: Center( // Center-align the text
          child: Text(
            message,style: const TextStyle(color:Colors.orange,fontSize: 20),
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
title: const Text('Get started',style: TextStyle(fontSize: 16),),
centerTitle: true,
backgroundColor: const Color.fromARGB(255, 224, 118, 9),
),
body: SingleChildScrollView(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Center(child: Image.asset('assets/save1.png', height: 150, width: 450)),
const SizedBox(height: 20),
const Padding(
padding: EdgeInsets.only(right: 110),
child: Text(
'Welcome back to Sunrise!',
style: TextStyle(
color: Colors.black,
fontWeight: FontWeight.bold,
fontSize: 18,
),
),
),
const SizedBox(
height: 10,
),
const Padding(
padding: EdgeInsets.only(right: 190),
child: Text('Sign in to Continue'),
),
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
controller: emailController,
keyboardType: TextInputType.emailAddress,
decoration: const InputDecoration(
labelText: 'Enter your email',
prefixIcon: Icon(Icons.email),
border: InputBorder.none,
contentPadding: EdgeInsets.symmetric(horizontal: 10),
isDense: true,
),
onChanged: (String value) {},
validator: (value) {
return value!.isEmpty ? 'Please enter email' : null;
},
),
),
),
),
),
const SizedBox(
height: 30,
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
controller: passwordController,
obscureText: !isPasswordVisible,
decoration: InputDecoration(
labelText: 'Enter Password',
prefixIcon: const Icon(Icons.password),
suffixIcon: IconButton(
icon: Icon(
isPasswordVisible ? Icons.visibility : Icons.visibility_off,
color: Colors.grey,
),
onPressed: () {
setState(() {
isPasswordVisible = !isPasswordVisible;
});
},
),
border: InputBorder.none,
contentPadding: const EdgeInsets.symmetric(horizontal: 10),
isDense: true,
),
onChanged: (String value) {},
validator: (value) {
return value!.isEmpty ? 'Please enter password' : null;
},
),
),
),
),
),
const SizedBox(
height: 20,
),
const Padding(
padding: EdgeInsets.only(left: 170),
child: Text(
'Forget Password?',
style: TextStyle(
color: Color.fromARGB(255, 224, 118, 9),
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
validateUser();
},
color: const Color.fromARGB(255, 224, 118, 9),
height: 40,
textColor: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
),
child: const Text(
'Login',
),
),
),
const SizedBox(
height: 10,
),
const Row(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Text(
"Don't have an account yet?",
style: TextStyle(color: Color.fromARGB(255, 224, 118, 9)),
),
],
),
const SizedBox(
height: 10,
),
Padding(
padding: const EdgeInsets.symmetric(horizontal: 35),
child: MaterialButton(
minWidth: double.infinity,
onPressed: () {
Navigator.push(
context,
MaterialPageRoute(builder:
(context)=>const SignPage()),
);
},
color: Colors.white,
height: 40,
textColor: const Color.fromARGB(255, 224, 118, 9),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(10),
side: const BorderSide(color: Color.fromARGB(255, 224, 118, 9)),
),
child: const Text(
'Create Account',
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
home: LoginPage(),
));
}




//account code
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import 'dashboard.dart';




class Accountno extends StatefulWidget {
const Accountno({super.key});

@override
_AccountnoState createState() => _AccountnoState();
}

class _AccountnoState extends State<Accountno> {

TextEditingController accountController = TextEditingController();
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

Future<void> checkAccountNumber() async {
String enteredAccountNumber = accountController.text.trim();

    // Query Firestore to check if the entered account number exists
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore.instance
        .collection('users') // Replace 'your_collection_name' with your actual collection name
        .where('accountNumber', isEqualTo: enteredAccountNumber)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      await secureStorage.write(key: 'accountNumber', value: enteredAccountNumber);
      // Account number exists, navigate to dashboard
      // Show a success message
      showSnackBar('Verification Success....!');
      await Future.delayed(Duration(seconds: 2));
      Navigator.push(context, MaterialPageRoute(builder: (context) => Dashboard()));
    } else {
      // Account number doesn't exist, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Account Number does not exist'),
          content: const Text('Please try again or contact Admin.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
}


// Method to show a SnackBar
void showSnackBar(String message) {
ScaffoldMessenger.of(context).showSnackBar(
SnackBar(
backgroundColor: Colors.white,

        content: Center( // Center-align the text
          child: Text(
            message,style: const TextStyle(color:Colors.orange,fontSize: 20),
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
title: const Text('Request Loan',style: TextStyle(fontSize: 16),),
centerTitle: true,
backgroundColor: const Color.fromARGB(255, 224, 118, 9),
),
body: SingleChildScrollView(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
Center(child: Padding(
padding: const EdgeInsets.only(top: 50),
child: Image.asset('assets/logo.png', height: 90, width: 100),
)),
const SizedBox(height: 20),
const Text('Verify your account number!',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold,color:Colors.orange),),
const SizedBox(height: 10),
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
controller: accountController,
keyboardType: TextInputType.number,
decoration: const InputDecoration(
labelText: 'Enter Account Number',
prefixIcon: Icon(Icons.credit_card),
border: InputBorder.none,
contentPadding: EdgeInsets.symmetric(horizontal: 10),
isDense: true,
),
onChanged: (String value) {},
validator: (value) {
return value!.isEmpty ? 'Please enter account No.' : null;
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
                          checkAccountNumber();
                        },
                        color: const Color.fromARGB(255, 224, 118, 9),
                        height: 40,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Verify',
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
home:Accountno(),
));
}

//loanbalance code
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoanBalance extends StatefulWidget {
@override
State<LoanBalance> createState() => _LoanBalance();
}

class _LoanBalance extends State<LoanBalance> {
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
late String? accountNumber;
String? loanBalance;

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

            const Padding(
              padding: EdgeInsets.only(
                  right: 30,
                  top:5
              ),
              child: Text(
                '02/02/2024',
                style: TextStyle(
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
            const Padding(
              padding: EdgeInsets.only(
                  right: 40,
                  top:5
              ),
              child: Text(
                '04/02/2024',
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
                  'Pay Now',
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
//saving code
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MySavings extends StatefulWidget {
@override
State<MySavings> createState() => _MySavings();
}
class _MySavings extends State<MySavings> {

@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text('My Savings',style: TextStyle(fontSize: 16,color:Colors.white),),
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
'Account Number.',
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
                '4555555',
                style: TextStyle(
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
                'Ledger Balance.',
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
                '4000000',
                style: TextStyle(
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
                'Total Balance.',
                style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Garamond',
                    color: Color.fromARGB(255, 224, 118, 9),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  right: 40,
                  top:5
              ),
              child: Text(
                '4000000',
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
                  'Save Now',
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
// firebase_services code
import 'package:firebase_auth/firebase_auth.dart';
class FirebaseAuthService{
FirebaseAuth  auth = FirebaseAuth.instance;


Future<User?>signUpWithEmailAndPassword(String email,String password) async{
try{
UserCredential credential =await auth.createUserWithEmailAndPassword(email: email, password: password);
return credential.user;
}catch(e){
print("Some error occurred");
}
return null;
}

Future<User?>signInWithEmailAndPassword(String email,String password) async{
try{
UserCredential credential =await auth.signInWithEmailAndPassword(email: email, password: password);
return credential.user;
}catch(e){
print("Some error occurred");
}
return null;
}
Future<void> updateUserEmail(String? userEmail, String? newEmail) async {
try {
if (_auth.currentUser != null && userEmail != null) {
await _auth.currentUser!.updateEmail(newEmail!);
}
} catch (error) {
print('Error updating email: $error');
throw error;
}
}

Future<void> updateUserDetails(String? newEmail, String username) async {
try {
if (_auth.currentUser != null && newEmail != null) {
await _firestore.collection('users').doc(newEmail).update({
'username': username,
// Add more fields to update as needed
});
}
} catch (error) {
print('Error updating user details: $error');
throw error;
}
}
}




}
//dashboard code
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

import 'loanbalance.dart';
import 'loanlimit.dart';

void main() {
SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
statusBarColor: Colors.transparent
));
runApp(const MyApp());
}

class MyApp extends StatelessWidget {
const MyApp({super.key});

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
const Dashboard({super.key});

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
return Scaffold(
body: ListView(
padding: EdgeInsets.zero,
children: [
Container(
decoration: const BoxDecoration(
color:Colors.orange,
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
},
),
],
),
);
},
);
}

}


