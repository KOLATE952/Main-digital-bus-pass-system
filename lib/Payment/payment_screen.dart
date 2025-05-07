import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentScreen extends StatefulWidget {
  final String amount;
  final String from;
  final String to;
  final String passType;
  final int ticketCount;
  final String? validTill; // <-- Added the validTill parameter

  const PaymentScreen({
    super.key,
    required this.amount,
    required this.from,
    required this.to,
    required this.passType,
    required this.ticketCount,
    this.validTill, // <-- Added this to the constructor
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  late int amountInPaise;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

    double parsedAmount = double.tryParse(widget.amount) ?? 0.0;
    amountInPaise = (parsedAmount * 100).toInt();

    // Only initiate checkout if amount is greater than 0
    if (amountInPaise > 0) {
      Future.delayed(Duration.zero, openCheckout);
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout() {
    final user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? 'test@gmail.com'; // Use user's email if available
    String userContact = '0000000000'; // Replace with actual user's contact if available

    var options = {
      'key': 'rzp_test_u398WOok1QQ6cG', // Your Razorpay key
      'amount': amountInPaise,
      'name': 'Digital Bus Pass App',
      'description': 'Bus Pass Payment',
      'prefill': {
        'contact': userContact,
        'email': userEmail,
      },
      'external': {
        'wallets': ['paytm'], // Add other wallets if needed
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    await storePassData(
      from: widget.from,
      to: widget.to,
      passType: widget.passType,
      ticketCount: widget.ticketCount,
      paymentAmount: double.tryParse(widget.amount) ?? 0.0,
      paymentId: response.paymentId ?? 'unknown',
      validTill: widget.validTill, // <-- Pass the validTill parameter here
    );

    Fluttertoast.showToast(
      msg: "\u2705 Payment Successful: ${response.paymentId}",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    Navigator.pop(context);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "\u274C Payment Failed: ${response.message ?? 'Unknown error'}",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "\ud83d\udd17 External Wallet: ${response.walletName}",
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Payment Gateway'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome to Razorpay Payment Gateway',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                'Amount to be paid: ₹${widget.amount}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: amountInPaise > 0 ? openCheckout : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                child: const Text(
                  'Make Payment',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> storePassData({
  required String from,
  required String to,
  required String passType,
  required int ticketCount,
  required double paymentAmount,
  required String paymentId,
  String? validTill, // <-- Added validTill here as a parameter
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final purchaseDateTime = DateTime.now();
  final validityDateTime = validTill != null
      ? DateTime.parse(validTill) // Use the provided validTill if available
      : passType == 'Monthly'
      ? purchaseDateTime.add(Duration(days: 30))
      : purchaseDateTime.add(Duration(days: 1));

  await FirebaseFirestore.instance
      .collection('passHistory')
      .doc(user.uid)
      .collection('passes')
      .add({
    'from': from,
    'to': to,
    'passType': passType,
    'ticketCount': ticketCount,
    'paymentAmount': paymentAmount,
    'purchaseDateTime': purchaseDateTime.toIso8601String(),
    'validityDateTime': validityDateTime.toIso8601String(),
    'paymentId': paymentId,
  });
}

