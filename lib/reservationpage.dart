import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttermaps/payment.dart';

class ReservationsPage extends StatelessWidget {
  final String userId;

  const ReservationsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reservations'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('reservations')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var reservations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: reservations.length,
            itemBuilder: (context, index) {
              var reservation = reservations[index];
              var status = reservation['status'];
              var parkingName = reservation['parkingName'];

              return ListTile(
                title: Text('Parking: $parkingName'),
                subtitle: Text('Status: $status'),
                trailing: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) =>
                                PaymentScreen(parking: parkingName))));
                  },
                  child: const Text(
                    'PAY',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
