// import 'package:flutter/material.dart';
// import 'package:digital_bus_pass_system/login_screen.dart';
//
// class RegisterScreen extends StatelessWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       'Register',
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff203142),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   _buildTextField(label: "Email", hintText: "abc@gmail.com", obscureText: false),
//                   SizedBox(height: 20),
//                   _buildTextField(label: "Create Password", hintText: "Enter Password", obscureText: true),
//                   SizedBox(height: 20),
//                   _buildTextField(label: "Confirm Password", hintText: "Re-enter Password", obscureText: true),
//                   SizedBox(height: 20),
//                   _buildTextField(label: "Mobile Number", hintText: "Enter mobile number", obscureText: false),
//                   SizedBox(height: 20),
//                   _buildTextField(label: "Age", hintText: "Enter Age", obscureText: false),
//                   SizedBox(height: 40),
//                   Center(
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(builder: (context) => LoginScreen()),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xff2E7D32), // Corrected from primary to backgroundColor
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text(
//                           'Register',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           'Already have an Account?',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => LoginScreen()),
//                             );
//                           },
//                           child: Text(
//                             'Sign in',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Color(0xff2E7D32),
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({required String label, required String hintText, required bool obscureText}) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         SizedBox(height: 8),
//         TextFormField(
//           obscureText: obscureText,
//           decoration: InputDecoration(
//             hintText: hintText,
//             filled: true,
//             fillColor: Color(0xffF8F9FA),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Color(0xff2E7D32)),
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:digital_bus_pass_system/login_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});
//
//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }
//
// class _RegisterScreenState extends State<RegisterScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController confirmPasswordController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController ageController = TextEditingController();
//
//   void registerUser() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//     final confirmPassword = confirmPasswordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
//       showMessage("Please fill all required fields");
//       return;
//     }
//
//     if (password != confirmPassword) {
//       showMessage("Passwords do not match");
//       return;
//     }
//
//     try {
//       await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       showMessage("Registration Successful");
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => const LoginScreen()),
//       );
//     } catch (e) {
//       showMessage("Registration Failed: ${e.toString()}");
//     }
//   }
//
//   void showMessage(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         resizeToAvoidBottomInset: false,
//         backgroundColor: Colors.white,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Text(
//                       'Register',
//                       style: TextStyle(
//                         fontSize: 32,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff203142),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 30),
//                   _buildTextField(
//                     controller: emailController,
//                     label: "Email",
//                     hintText: "abc@gmail.com",
//                     obscureText: false,
//                   ),
//                   SizedBox(height: 20),
//                   _buildTextField(
//                     controller: passwordController,
//                     label: "Create Password",
//                     hintText: "Enter Password",
//                     obscureText: true,
//                   ),
//                   SizedBox(height: 20),
//                   _buildTextField(
//                     controller: confirmPasswordController,
//                     label: "Confirm Password",
//                     hintText: "Re-enter Password",
//                     obscureText: true,
//                   ),
//                   SizedBox(height: 20),
//                   _buildTextField(
//                     controller: mobileController,
//                     label: "Mobile Number",
//                     hintText: "Enter mobile number",
//                     obscureText: false,
//                   ),
//                   SizedBox(height: 20),
//                   _buildTextField(
//                     controller: ageController,
//                     label: "Age",
//                     hintText: "Enter Age",
//                     obscureText: false,
//                   ),
//                   SizedBox(height: 40),
//                   Center(
//                     child: SizedBox(
//                       width: double.infinity,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: registerUser,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Color(0xff2E7D32),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text(
//                           'Register',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   Center(
//                     child: Column(
//                       children: [
//                         Text(
//                           'Already have an Account?',
//                           style: TextStyle(
//                             fontSize: 16,
//                             color: Colors.black54,
//                           ),
//                         ),
//                         SizedBox(height: 10),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(builder: (context) => LoginScreen()),
//                             );
//                           },
//                           child: Text(
//                             'Sign in',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Color(0xff2E7D32),
//                               fontWeight: FontWeight.bold,
//                               decoration: TextDecoration.underline,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String label,
//     required String hintText,
//     required bool obscureText,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.w500,
//             color: Colors.black87,
//           ),
//         ),
//         SizedBox(height: 8),
//         TextFormField(
//           controller: controller,
//           obscureText: obscureText,
//           decoration: InputDecoration(
//             hintText: hintText,
//             filled: true,
//             fillColor: Color(0xffF8F9FA),
//             enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Colors.grey.shade300),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(color: Color(0xff2E7D32)),
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:digital_bus_pass_system/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  void registerUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      showSnackBar("Please fill all required fields");
      return;
    }

    if (password != confirmPassword) {
      showSnackBar("Passwords do not match");
      return;
    }

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Show success popup dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Success"),
          content: Text("You have registered successfully."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: Text("OK"),
            ),
          ],
        ),
      );
    } catch (e) {
      showSnackBar("Registration Failed: ${e.toString()}");
    }
  }

  void showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff203142),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildTextField(
                    controller: emailController,
                    label: "Email",
                    hintText: "abc@gmail.com",
                    obscureText: false,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: passwordController,
                    label: "Create Password",
                    hintText: "Enter Password",
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: confirmPasswordController,
                    label: "Confirm Password",
                    hintText: "Re-enter Password",
                    obscureText: true,
                  ),
                  SizedBox(height: 20),
                  _buildTextField(
                    controller: mobileController,
                    label: "Mobile Number",
                    hintText: "Enter mobile number",
                    obscureText: false,
                  ),
                  SizedBox(height: 20),
                  // _buildTextField(
                  //   controller: ageController,
                  //   label: "Age",
                  //   hintText: "Enter Age",
                  //   obscureText: false,
                  // ),
                  SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff2E7D32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Register',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Already have an Account?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LoginScreen()),
                            );
                          },
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff2E7D32),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hintText,
    required bool obscureText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Color(0xffF8F9FA),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xff2E7D32)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}



