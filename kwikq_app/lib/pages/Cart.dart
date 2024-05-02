import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kwikq_app/pages/Order_confirm_page.dart';
import 'package:kwikq_app/services/database.dart';
import 'package:kwikq_app/services/firebase_const.dart';
import 'package:kwikq_app/services/firestore_service.dart';
import 'package:kwikq_app/services/shared_pref.dart';
import 'package:kwikq_app/widgets/app_constants.dart';
import 'package:random_string/random_string.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final _razorpay = Razorpay();
  // ignore: non_constant_identifier_names
  String? id,O_id;
  int total = 0, amount2 = 0;
  

  void startTimer() {
    Timer(Duration(seconds: 1), () {
      amount2 = total;
      setState(() {});
    });
  }

  getthesharedpref() async {
    id = await SharedPreferenceHelper().getUserId();
    O_id = await SharedPreferenceHelper().getOrder();
    setState(() {});
  }

  ontheload() async {
    await getthesharedpref();
    foodStream = await DatabaseMethods().getFoodCart(id!);
    setState(() {});
  }

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    ontheload();
    startTimer();
    super.initState();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print(
        'Payment Success : ${response.paymentId}  ${response.orderId}  ${response.signature}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(
            'Payment Id : ${response.paymentId}  ${response.orderId}  ${response.signature}'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'))
        ],
      ),
    );
    try {
      // Get the cart items
      Stream<QuerySnapshot> cartItemsSnapshotStream =
          await DatabaseMethods().getFoodCart(id!);
      QuerySnapshot cartItemsSnapshot = await cartItemsSnapshotStream.first;

      // Extract the items data and save it to Firestore
      var itemsData = cartItemsSnapshot.docs.map((doc) => doc.data()).toList();
      await FireStoreService.saveOrder({
        'userId': id,
        'items': itemsData,
        'total': total,
        'paymentId': response.paymentId,
        'orderId': randomAlphaNumeric(10),
        'date': Timestamp.now(),
      });

      // Clear the cart after successful order
      await DatabaseMethods().clearCart(id!);

      // Navigate to order confirmation page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              OrderConfirmationPage(orderId: ordersCollection),
        ),
      );
    } catch (error) {
      print("Failed to add order: $error");
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment Success : ${response.code}  ${response.message}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content:
            Text('Code : ${response.code} -Message : ${response.message} '),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'))
        ],
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('Payment Success : ${response.walletName}');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("External Wallet"),
        content: Text('Wallet Name : ${response.walletName} '),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'))
        ],
      ),
    );
  }

  Stream? foodStream;

  Widget foodCart() {
    return StreamBuilder(
        stream: foodStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: snapshot.data.docs.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    total = total + int.parse(ds["Total"]);
                    return Container(
                      margin: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 10.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Container(
                                height: 90,
                                width: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(child: Text(ds["Quantity"])),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              ClipRRect(
                                  borderRadius: BorderRadius.circular(60),
                                  child: Image.network(
                                    ds["Image"],
                                    height: 55,
                                    width: 55,
                                    fit: BoxFit.cover,
                                  )),
                              SizedBox(
                                width: 10.0,
                              ),
                              Column(
                                children: [
                                  Text(
                                    ds["Name"],
                                    style: GoogleFonts.poppins(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0200,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "\₹" + ds["Total"],
                                    style: GoogleFonts.poppins(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.0300,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await DatabaseMethods()
                                      .deleteFoodCart(ds["Id"]);
                                },
                                child: Icon(Icons.delete),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : CircularProgressIndicator();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
                elevation: 2.0,
                child: Container(
                    padding: EdgeInsets.only(bottom: 10.0),
                    child: Center(
                        child: Text(
                      "Food Cart",
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    )))),
            SizedBox(
              height: 20.0,
            ),
            Container(
                height: MediaQuery.of(context).size.height / 2,
                child: foodCart()),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Price",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\₹" + total.toString(),
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            GestureDetector(
              onTap: () {
                var options = {
                  'key': 'rzp_test_TUV5Kd9YTRyDBt',
                  'amount': amount2 * 100,
                  'name': 'Kwikq',
                  'description': 'Fine T-Shirt',
                  'prefill': {
                    'contact': '9207339522',
                    'email': 'kwikq4444@gmaail.com'
                  }
                };
                try {
                  print(total);
                  _razorpay.open(options);
                } catch (e) {
                  debugPrint("Failed to open Razorpay: ${e.toString()}");
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Center(
                    child: Text(
                  "CheckOut",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
