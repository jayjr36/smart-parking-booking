// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_overlay/loading_overlay.dart';

class PaymentScreen extends StatefulWidget {
  final String parking;
  const PaymentScreen({super.key, required this.parking});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  String uid = FirebaseAuth.instance.currentUser!.uid;
  bool isloading = false;

  @override
  void initState() {
    super.initState();
  }

  Future<void> _makePayment() async {
    try {
      setState(() {
        isloading = true;
      });
      
      await FirebaseFirestore.instance
          .collection('payments')
          .doc(uid)
          .collection('mypayments')
          .add({
        'parking': widget.parking,
        'amount': double.parse(_amountController.text),
        'date': Timestamp.now(),
        'userId': uid,
      });
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Successful')),
      );
    } catch (e) {
      print(e);
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Payment'),
      ),
      body: LoadingOverlay(
        isLoading: isloading,
        progressIndicator: const CircularProgressIndicator(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _cardNumberController,
                decoration: const InputDecoration(labelText: 'Card Number'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _expiryDateController,
                decoration:
                    const InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _cvvController,
                decoration: const InputDecoration(labelText: 'CVV'),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              TextField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _makePayment,
                child: const Text('Pay'),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('payments')
                      .doc(uid)
                      .collection('mypayments')
                      .where('userId',
                          isEqualTo: uid) // Replace with actual user ID
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var payments = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: payments.length,
                      itemBuilder: (context, index) {
                        var payment = payments[index];
                        var parking = payment['parking'];
                        var amount = payment['amount'];
                        var date = (payment['date'] as Timestamp).toDate();
                        var formattedDate =
                            DateFormat('dd/MM/yyyy HH:mm').format(date);

                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(parking, 
                              style: const TextStyle(
                                fontWeight: FontWeight.bold, 
                                fontSize: 18
                                ),
                                ),
                              Text('Amount: Tshs ${amount.toStringAsFixed(2)}'),
                            ],
                          ),
                          subtitle: Text('Date: $formattedDate'),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
