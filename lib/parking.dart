import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingDetailsPage extends StatelessWidget {
  const ParkingDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Details'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('parking')
            .where(FieldPath.documentId, whereIn: ['mnazi', 'gerezani'])
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          var documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              var document = documents[index];
              var parkingName = document.id;
              var data = document.data() as Map<String, dynamic>;

              return ListTile(
                title: Text('Parking: $parkingName'),
                subtitle: Text('Details: ${data.toString()}'),
              );
            },
          );
        },
      ),
    );
  }
}
