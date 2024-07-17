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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  bool _validateCardDetails() {
    final cardNumber = _cardNumberController.text;
    final expiryDate = _expiryDateController.text;
    final cvv = _cvvController.text;

    // Validate card number (must be 16 digits)
    if (cardNumber.length != 16 || !RegExp(r'^[0-9]{16}$').hasMatch(cardNumber)) {
      return false;
    }

    // Validate expiry date (format MM/YY)
    if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(expiryDate)) {
      return false;
    }

    // Validate CVV (must be 3 digits)
    if (cvv.length != 3 || !RegExp(r'^[0-9]{3}$').hasMatch(cvv)) {
      return false;
    }

    return true;
  }

  Future<void> _makePayment() async {
    if (_amountController.text != '5000') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment amount must be exactly 5000 Tshs')),
      );
      return;
    }

    if (!_validateCardDetails()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid card details')),
      );
      return;
    }

    try {
      setState(() {
        isLoading = true;
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
        'status': 'paid',
      });

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment Successful')),
      );
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
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
        isLoading: isLoading,
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
                      .where('userId', isEqualTo: uid)
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
                        var status = payment['status'];
                        var formattedDate =
                            DateFormat('dd/MM/yyyy HH:mm').format(date);

                        return ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(parking,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18)),
                              Text('Amount: Tshs ${amount.toStringAsFixed(2)}'),
                            ],
                          ),
                          subtitle: Text('Date: $formattedDate'),
                          trailing: Text(
                            status,
                            style: TextStyle(
                              color: status == 'paid'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
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
