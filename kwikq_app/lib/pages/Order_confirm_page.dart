import 'package:flutter/material.dart';
import 'package:kwikq_app/services/firestore_service.dart';

class OrderConfirmationPage extends StatelessWidget {
  final String orderId;

  OrderConfirmationPage({required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Confirmation'),
      ),
      body: FutureBuilder(
        future: FireStoreService.getOrderById(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // Assuming data is in a Map format
              var orderData = snapshot.data as Map;
              return ListView.builder(
                itemCount: orderData['items'].length,
                itemBuilder: (context, index) {
                  var item = orderData['items'][index];
                  return ListTile(
                    title: Text(item['name']),
                    subtitle: Text('Quantity: ${item['quantity']}'),
                    trailing: Text('Price: \$${item['price']}'),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }
}
