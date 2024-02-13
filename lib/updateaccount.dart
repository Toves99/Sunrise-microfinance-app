
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'firebase_services.dart';
class Update extends StatefulWidget {
  const Update({super.key});

  @override
  _UpdateState createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuthService  auth = FirebaseAuthService();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _updateUser() async {
    String username = usernameController.text;
    String email = emailController.text;
    try {
      // Update email and password in authentication system
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateEmail(email);
      } else {
        // User is not logged in or doesn't exist
        throw Exception("User not found");
      }

      // Update user data in Firestore
      await _firestore.collection('users').doc(user!.uid).set(
        {
          'username': username,
          'email': email,
        },
        SetOptions(merge: true), // Merge option to update instead of overwrite
      );

      // Show a success message
      showSnackBar('Account updated successfully!');
      await Future.delayed(Duration(seconds: 1));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );
    } catch (error) {
      showSnackBar('Error updating account: $error');
      usernameController.clear();
      emailController.clear();

    }
  }

  // Method to show a SnackBar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update account',style: TextStyle(fontSize: 18,color:Colors.white,fontWeight: FontWeight.bold),),
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
              padding: EdgeInsets.only(right: 180),
              child: Text(
                'Update your profile!',
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
                      height: 10,
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
                              controller: usernameController,
                              keyboardType: TextInputType.name,
                              decoration: const InputDecoration(
                                labelText: 'Enter your username',
                                prefixIcon: Icon(Icons.person),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please enter username' : null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () {
                          _updateUser();
                        },
                        color: const Color.fromARGB(255, 224, 118, 9),
                        height: 40,
                        textColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Update',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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



