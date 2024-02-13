import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UpdateUserAccountNumber extends StatefulWidget {
  const UpdateUserAccountNumber({super.key});

  @override
  _UpdateUserAccountNumberState createState() => _UpdateUserAccountNumberState();
}

class _UpdateUserAccountNumberState extends State<UpdateUserAccountNumber> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  TextEditingController emailController = TextEditingController();
  TextEditingController accountNumberController = TextEditingController();

  Future<void> updateAccountNumber(String email, String accountNumber) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final userSnapshot =
    await usersRef.where('email', isEqualTo: email).get();
    if (userSnapshot.docs.isNotEmpty) {
      final userId = userSnapshot.docs.first.id;
      await usersRef.doc(userId).update({'accountNumber': accountNumber});
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account number updated successfully')),
      );
    } else {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while updating account number')),
      );
    }
  }

  void handleUpdate() {
    final email = emailController.text;
    final accountNumber = accountNumberController.text;
    updateAccountNumber(email, accountNumber);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User accountNumbers',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.white),),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 224, 118, 9),
        iconTheme: const IconThemeData(color: Colors.white),
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
                                labelText: 'Enter users email',
                                prefixIcon: Icon(Icons.email),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please enter users email' : null;
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
                              controller: accountNumberController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Enter user accountNumber',
                                prefixIcon: Icon(Icons.attach_money),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please enter users accountNumber' : null;
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
                          handleUpdate();
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
    home:UpdateUserAccountNumber(),
  ));
}
