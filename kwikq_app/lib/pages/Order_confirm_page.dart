import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String orderId;

  OrderConfirmationPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
      ),
      body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance.collection('orders').doc(orderId).get(),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            return Center(
              child: Text('No order found.'),
            );
          } else {
            var orderData = snapshot.data!.data()!;
            List<Map<String, dynamic>> items = List<Map<String, dynamic>>.from(orderData['items']);
            return Card(
              margin: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Ordered Items',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      var item = items[index];
                      if (item != null) {
                        return ListTile(
                          title: Text(item['name'] ?? ''),
                          subtitle: Text('Quantity: ${item['quantity'] ?? 'Quantity not available'}'),
                          trailing: Text('Price: \$${item['price'] ?? 'Price not available'}'),
                        );
                      } else {
                        return SizedBox.shrink(); // Return an empty widget if item is null
                      }
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
