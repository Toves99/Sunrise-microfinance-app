import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:microfinance/usersignin.dart';


import 'account.dart';
import 'admin/admindashboard.dart';
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
  String? email;
  String? password;
  bool isAdmin = false; // Track whether the user is logging in as admin or user
  bool isUser = false; //

  Future<void> validateUser() async {
    String email = emailController.text;
    String password = passwordController.text;
    try {
      User? user = await auth.signInWithEmailAndPassword(email, password);
      if (user != null) {
        // Retrieve user data from Firestore
        DocumentSnapshot<Map<String, dynamic>> userData =
        await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        if (userData.exists) {
          bool isAdminUser = userData.get('isAdmin') ?? false;
          setState(() {
            isAdmin = isAdminUser;
            isUser = !isAdminUser;
          });
          // Navigate the user according to their role
          if (isAdmin) {
            await secureStorage.write(key: 'userEmail', value: email);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AdminDashboard()),
            );
          } else {
            await secureStorage.write(key: 'userEmail', value: email);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Accountno()),
            );
          }
        } else {
          showSnackBar('User data not found');
        }
      } else {
        showSnackBar('Invalid details try again!');
        emailController.clear();
        passwordController.clear();
      }
    } catch (error) {
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
        title: const Text('Get started',style: TextStyle(fontSize: 18,color:Colors.white,fontWeight: FontWeight.bold),),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 224, 118, 9),
        iconTheme: const IconThemeData(color: Colors.white),
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
                    Row(
                      children: [
                        SizedBox(
                          width:40,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20
                            ),
                            child: Checkbox(
                              value: isAdmin,
                              onChanged: (value) {
                                setState(() {
                                  isAdmin = value!;
                                  isUser = !isAdmin; // Ensure only one of isAdmin or isUser can be true
                                });
                              },

                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 3
                          ),
                          child: Text('Admin',style: TextStyle(fontSize: 16,color: Colors.orange),),
                        ),
                        SizedBox(
                          width: 40,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 20
                            ),
                            child: Checkbox(
                              value: isUser,
                              onChanged: (value) {
                                setState(() {
                                  isUser = value!;
                                  isAdmin = !isUser; // Ensure only one of isAdmin or isUser can be true
                                });

                              },
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 3
                          ),
                          child: Text('User',style: TextStyle(fontSize: 16,color: Colors.orange),),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(
                            left: 30
                          ),
                          child: Text(
                            'Forget Password?',
                            style: TextStyle(
                              color: Color.fromARGB(255, 224, 118, 9),
                            ),
                          ),
                        ),
                      ],
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
      debugShowCheckedModeBanner: false,
    home: LoginPage(),
  ));
}
