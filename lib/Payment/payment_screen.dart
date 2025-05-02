// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({super.key});
//
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   late Razorpay _razorpay;
//   TextEditingController amtController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   void openCheckout(int amount) {
//     var options = {
//       'key': 'rzp_test_u398WOok1QQ6cG',
//       'amount': amount * 100, // in paise
//       'name': 'Digital Bus Pass App',
//       'prefill': {
//         'contact': '0000000000',
//         'email': 'test@gmail.com',
//       },
//       'external': {
//         'wallets': ['paytm']
//       }
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: $e');
//     }
//   }
//
//   void handlePaymentSuccess(PaymentSuccessResponse response) {
//     Fluttertoast.showToast(
//       msg: "Payment Successful: ${response.paymentId ?? ''}",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }
//
//   void handlePaymentError(PaymentFailureResponse response) {
//     Fluttertoast.showToast(
//       msg: "Payment Failed: ${response.message ?? 'Unknown error'}",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }
//
//   void handleExternalWallet(ExternalWalletResponse response) {
//     Fluttertoast.showToast(
//       msg: "External Wallet selected: ${response.walletName ?? ''}",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[800],
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const SizedBox(height: 100),
//             const Text(
//               'Welcome to Razorpay Gateway Integration',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             TextFormField(
//               cursorColor: Colors.white,
//               style: const TextStyle(color: Colors.white),
//               controller: amtController,
//               decoration: const InputDecoration(
//                 labelText: 'Enter amount to be paid',
//                 labelStyle: TextStyle(fontSize: 15.0, color: Colors.white),
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white, width: 1.0),
//                 ),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: BorderSide(color: Colors.white, width: 1.0),
//                 ),
//                 errorStyle: TextStyle(
//                   color: Colors.redAccent,
//                   fontSize: 15,
//                 ),
//               ),
//               keyboardType: TextInputType.number,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter amount to be paid';
//                 }
//                 return null;
//               },
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 if (amtController.text.toString().isNotEmpty) {
//                   int amount = int.parse(amtController.text.toString());
//                   openCheckout(amount);
//                 }
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text('Make Payment'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class PaymentScreen extends StatefulWidget {
//   final double amount; // receive amount from previous screen
//
//   const PaymentScreen({super.key, required this.amount});
//
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   late Razorpay _razorpay;
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   void openCheckout() {
//     var options = {
//       'key': 'rzp_test_u398WOok1QQ6cG',
//       'amount': (widget.amount * 100).toInt(), // converting to paise
//       'name': 'Digital Bus Pass App',
//       'prefill': {
//         'contact': '0000000000',
//         'email': 'test@gmail.com',
//       },
//       'external': {
//         'wallets': ['paytm']
//       }
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: $e');
//     }
//   }
//
//   void handlePaymentSuccess(PaymentSuccessResponse response) {
//     Fluttertoast.showToast(
//       msg: "Payment Successful: ${response.paymentId ?? ''}",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }
//
//   void handlePaymentError(PaymentFailureResponse response) {
//     Fluttertoast.showToast(
//       msg: "Payment Failed: ${response.message ?? 'Unknown error'}",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }
//
//   void handleExternalWallet(ExternalWalletResponse response) {
//     Fluttertoast.showToast(
//       msg: "External Wallet selected: ${response.walletName ?? ''}",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[800],
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const SizedBox(height: 100),
//             const Text(
//               'Proceed to Payment',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//
//             // Show Amount
//             Text(
//               "Amount to Pay: ₹${widget.amount.toStringAsFixed(2)}",
//               style: const TextStyle(color: Colors.greenAccent, fontSize: 22, fontWeight: FontWeight.bold),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//
//             ElevatedButton(
//               onPressed: openCheckout,
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text('Make Payment'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class PaymentScreen extends StatefulWidget {
//   final String amount; // Accepting 'amount' as String
//
//   const PaymentScreen({super.key, required this.amount}); // Constructor to accept 'amount'
//
//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }
//
// class _PaymentScreenState extends State<PaymentScreen> {
//   late Razorpay _razorpay;
//
//   @override
//   void initState() {
//     super.initState();
//     _razorpay = Razorpay();
//     _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
//     _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
//     _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
//   }
//
//   @override
//   void dispose() {
//     _razorpay.clear();
//     super.dispose();
//   }
//
//   void openCheckout(int amount) {
//     var options = {
//       'key': 'rzp_test_u398WOok1QQ6cG',
//       'amount': amount * 100, // Razorpay takes the amount in paise (1 INR = 100 paise)
//       'name': 'Digital Bus Pass App',
//       'prefill': {
//         'contact': '0000000000',
//         'email': 'test@gmail.com',
//       },
//       'external': {
//         'wallets': ['paytm'],
//       },
//     };
//
//     try {
//       _razorpay.open(options);
//     } catch (e) {
//       debugPrint('Error: $e');
//     }
//   }
//
//   void handlePaymentSuccess(PaymentSuccessResponse response) {
//     Fluttertoast.showToast(
//       msg: "Payment Successful: ${response.paymentId ?? ''}",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }
//
//   void handlePaymentError(PaymentFailureResponse response) {
//     Fluttertoast.showToast(
//       msg: "Payment Failed: ${response.message ?? 'Unknown error'}",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }
//
//   void handleExternalWallet(ExternalWalletResponse response) {
//     Fluttertoast.showToast(
//       msg: "External Wallet selected: ${response.walletName ?? ''}",
//       toastLength: Toast.LENGTH_SHORT,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Convert the passed amount string to an integer to handle payment
//     int amount = int.parse(widget.amount);
//
//     return Scaffold(
//       backgroundColor: Colors.grey[800],
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const SizedBox(height: 100),
//             const Text(
//               'Welcome to Razorpay Gateway Integration',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             Text(
//               'Amount to be paid: ₹${widget.amount}',
//               style: const TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//               ),
//             ),
//             const SizedBox(height: 30),
//             ElevatedButton(
//               onPressed: () {
//                 // Make payment with the provided amount
//                 openCheckout(amount);
//               },
//               style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text('Make Payment'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String amount; // Accepting 'amount' as String

  const PaymentScreen({super.key, required this.amount}); // Constructor to accept 'amount'

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late Razorpay _razorpay;
  late int amount;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

    // Safely parse amount
    amount = int.tryParse(widget.amount) ?? 0;
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void openCheckout() {
    var options = {
      'key': 'rzp_test_u398WOok1QQ6cG',
      'amount': amount * 100, // Razorpay requires amount in paise
      'name': 'Digital Bus Pass App',
      'prefill': {
        'contact': '0000000000',
        'email': 'test@gmail.com',
      },
      'external': {
        'wallets': ['paytm'],
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Successful: ${response.paymentId ?? ''}",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  void handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
      msg: "Payment Failed: ${response.message ?? 'Unknown error'}",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
      msg: "External Wallet selected: ${response.walletName ?? ''}",
      toastLength: Toast.LENGTH_SHORT,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
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
              onPressed: amount > 0 ? openCheckout : null,
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
    );
  }
}
