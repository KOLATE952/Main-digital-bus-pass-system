import 'package:flutter/material.dart';
import 'package:digital_bus_pass_system/Bus Ticket/bus_pass_form.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  String _selectedPaymentMethod = 'Credit/Debit Card';

  void _submitPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Payment Successful 🎉'),
          content: Text('Your payment has been processed successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Close Payment Screen
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Payment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white10, Colors.white12],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Complete your payment securely',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Payment Form
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Payment Method Selection
                            DropdownButtonFormField<String>(
                              value: _selectedPaymentMethod,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedPaymentMethod = newValue!;
                                });
                              },
                              items: <String>[
                                'Credit/Debit Card',
                                'UPI',
                                'Net Banking'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                labelText: 'Payment Method',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 20),

                            // Card Details (Only for Card Payment)
                            if (_selectedPaymentMethod == 'Credit/Debit Card') ...[
                              TextFormField(
                                controller: _cardNumberController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Card Number',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.credit_card),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your card number';
                                  } else if (value.length < 16) {
                                    return 'Enter a valid 16-digit card number';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _expiryDateController,
                                      keyboardType: TextInputType.datetime,
                                      decoration: InputDecoration(
                                        labelText: 'Expiry Date (MM/YY)',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.calendar_today),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter expiry date';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 20),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _cvvController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: 'CVV',
                                        border: OutlineInputBorder(),
                                        prefixIcon: Icon(Icons.lock),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter CVV';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            SizedBox(height: 20),

                            // UPI Payment Field
                            if (_selectedPaymentMethod == 'UPI') ...[
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Enter UPI ID',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.qr_code),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter UPI ID';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                            ],

                            // Net Banking Option
                            if (_selectedPaymentMethod == 'Net Banking') ...[
                              DropdownButtonFormField<String>(
                                value: null,
                                onChanged: (String? newValue) {},
                                items: ['SBI', 'HDFC', 'ICICI', 'Axis Bank']
                                    .map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                decoration: InputDecoration(
                                  labelText: 'Select Bank',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 20),
                            ],

                            // Amount Field
                            TextFormField(
                              controller: _amountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Amount',
                                border: OutlineInputBorder(),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.all(12.0), // Adjust padding for better alignment
                                  child: Text(
                                    '₹',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter the amount';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),

                            // Submit Payment Button
                            ElevatedButton(
                              onPressed: _submitPayment,
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                backgroundColor: Colors.green,
                                elevation: 10,
                              ),
                              child: Text(
                                'Submit Payment',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
