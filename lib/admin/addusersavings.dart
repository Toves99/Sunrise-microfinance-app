import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UpdateUserSaving extends StatefulWidget {
  const UpdateUserSaving({super.key});

  @override
  _UpdateUserSavingState createState() => _UpdateUserSavingState();
}

class _UpdateUserSavingState extends State<UpdateUserSaving> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  TextEditingController accountNumberController = TextEditingController();
  TextEditingController amountController = TextEditingController();


  Future<void> updateAccountNumber(String savingAmount, String accountNumber) async {
    final usersRef = FirebaseFirestore.instance.collection('users');
    final userSnapshot =
    await usersRef.where('accountNumber', isEqualTo: accountNumber).get();
    if (userSnapshot.docs.isNotEmpty) {
      final userId = userSnapshot.docs.first.id;
      await usersRef.doc(userId).update({'savingAmount': savingAmount});
      // Show success snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Savings updated successfully')),
      );
    } else {
      // Show error snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error occurred while updating Savings')),
      );
    }
  }

  void handleUpdate() {
    final accountNumber = accountNumberController.text;
    final savingAmount = amountController.text;
    updateAccountNumber(savingAmount, accountNumber);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add User Savings',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color:Colors.white),),
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
                              controller: accountNumberController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Enter users account Number',
                                prefixIcon: Icon(Icons.credit_card),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please enter users account Number' : null;
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
                              controller:amountController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Enter Amount',
                                prefixIcon: Icon(Icons.attach_money),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                isDense: true,
                              ),
                              onChanged: (String value) {},
                              validator: (value) {
                                return value!.isEmpty ? 'Please enter Amount' : null;
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
    home:UpdateUserSaving(),
  ));
}
