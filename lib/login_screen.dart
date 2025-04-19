// import 'package:flutter/material.dart';
// import 'package:digital_bus_pass_system/multilang_screen.dart';
// import 'package:digital_bus_pass_system/register_screen.dart';
// import 'package:digital_bus_pass_system/home_screen.dart';
// import 'package:digital_bus_pass_system/localizations/localization_service.dart';
//
// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});
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
//             child: Column(
//               children: [
//                 const SizedBox(height: 50),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Image(
//                       height: 100,
//                       width: 100,
//                       image: AssetImage('assets/pmt_bus.png'),
//                     ),
//                     SizedBox(width: 8),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontFamily: 'Rubik Medium',
//                     color: Color(0xff203142),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Welcome to Digital Bus Pass App',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontFamily: 'Rubik Regular',
//                     color: Color(0xff4C5980),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: TextFormField(
//                     decoration: InputDecoration(
//                       hintText: 'Email',
//                       fillColor: const Color(0xffF8F9FA),
//                       filled: true,
//                       prefixIcon: const Icon(
//                         Icons.alternate_email,
//                         color: Color(0xff323F4B),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: TextFormField(
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintText: 'Password',
//                       fillColor: const Color(0xffF8F9FA),
//                       filled: true,
//                       prefixIcon: const Icon(
//                         Icons.lock_open,
//                         color: Color(0xff323F4B),
//                       ),
//                       suffixIcon: const Icon(Icons.visibility_off_outlined),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 16, top: 10),
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       'Forgot Password?',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontFamily: 'Rubik Regular',
//                         color: Color(0xff203142),
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 80),
//                 Container(
//                   height: 50,
//                   width: 300,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xff2E7D32), Color(0xff4CAF50)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.green.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => MultilangScreen(
//                             onLanguageSelected: (selectedLang) {
//                               print("Language selected: $selectedLang");
//                             },
//                           ),
//                         ),
//                       );
//                     },
//                     child: const Text(
//                       'Log In',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontFamily: 'Rubik Medium',
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Don't have an Account?",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontFamily: 'Rubik Regular',
//                         color: Color(0xff4C5980),
//                       ),
//                     ),
//                     const SizedBox(height: 17),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => const RegisterScreen()),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0,
//                         shadowColor: Colors.transparent,
//                       ),
//                       child: const Text(
//                         'Register Here',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontFamily: 'Rubik Medium',
//                           color: Color(0xff2E7D32),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:digital_bus_pass_system/multilang_screen.dart';
// import 'package:digital_bus_pass_system/register_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   void loginUser() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       showSnackBar("Please enter both email and password");
//       return;
//     }
//
//     try {
//       await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       showSnackBar("Login Successful");
//
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MultilangScreen(
//             onLanguageSelected: (selectedLang) {
//               print("Language selected: $selectedLang");
//             },
//           ),
//         ),
//       );
//     } catch (e) {
//       showSnackBar("Login Failed: ${e.toString().split('] ').last}");
//     }
//   }
//
//   void showSnackBar(String message) {
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
//             child: Column(
//               children: [
//                 const SizedBox(height: 50),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: const [
//                     Image(
//                       height: 100,
//                       width: 100,
//                       image: AssetImage('assets/pmt_bus.png'),
//                     ),
//                     SizedBox(width: 8),
//                   ],
//                 ),
//                 const SizedBox(height: 20),
//                 const Text(
//                   'Login',
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontFamily: 'Rubik Medium',
//                     color: Color(0xff203142),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'Welcome to Digital Bus Pass App',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontFamily: 'Rubik Regular',
//                     color: Color(0xff4C5980),
//                   ),
//                 ),
//                 const SizedBox(height: 30),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: TextFormField(
//                     controller: emailController,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: InputDecoration(
//                       hintText: 'Email',
//                       fillColor: const Color(0xffF8F9FA),
//                       filled: true,
//                       prefixIcon: const Icon(
//                         Icons.alternate_email,
//                         color: Color(0xff323F4B),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: TextFormField(
//                     controller: passwordController,
//                     obscureText: true,
//                     decoration: InputDecoration(
//                       hintText: 'Password',
//                       fillColor: const Color(0xffF8F9FA),
//                       filled: true,
//                       prefixIcon: const Icon(
//                         Icons.lock_open,
//                         color: Color(0xff323F4B),
//                       ),
//                       suffixIcon: const Icon(Icons.visibility_off_outlined),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 16, top: 10),
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: Text(
//                       'Forgot Password?',
//                       style: TextStyle(
//                         fontSize: 14,
//                         fontFamily: 'Rubik Regular',
//                         color: Color(0xff203142),
//                         decoration: TextDecoration.underline,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 80),
//                 Container(
//                   height: 50,
//                   width: 300,
//                   decoration: BoxDecoration(
//                     gradient: const LinearGradient(
//                       colors: [Color(0xff2E7D32), Color(0xff4CAF50)],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.circular(30),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.green.withOpacity(0.3),
//                         blurRadius: 8,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: TextButton(
//                     onPressed: loginUser,
//                     child: const Text(
//                       'Log In',
//                       style: TextStyle(
//                         fontSize: 20,
//                         fontFamily: 'Rubik Medium',
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Don't have an Account?",
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontFamily: 'Rubik Regular',
//                         color: Color(0xff4C5980),
//                       ),
//                     ),
//                     const SizedBox(height: 17),
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const RegisterScreen(),
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.transparent,
//                         elevation: 0,
//                         shadowColor: Colors.transparent,
//                       ),
//                       child: const Text(
//                         'Register Here',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontFamily: 'Rubik Medium',
//                           color: Color(0xff2E7D32),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//

// import 'package:flutter/material.dart';
// import 'package:digital_bus_pass_system/multilang_screen.dart';
// import 'package:digital_bus_pass_system/register_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   void loginUser() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//
//     if (email.isEmpty || password.isEmpty) {
//       showSnackBar("Please enter both email and password");
//       return;
//     }
//
//     try {
//       final userCredential = await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//
//       if (userCredential.user != null && context.mounted) {
//         showSnackBar("Login Successful");
//
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MultilangScreen(
//               onLanguageSelected: (selectedLang) {
//                 print("Language selected: $selectedLang");
//               },
//             ),
//           ),
//         );
//       }
//     } catch (e) {
//       showSnackBar("Login Failed: ${e.toString().split('] ').last}");
//     }
//   }
//
//   void showSnackBar(String message) {
//     if (context.mounted) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(message)),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 50),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: const [
//                   Image(
//                     height: 100,
//                     width: 100,
//                     image: AssetImage('assets/pmt_bus.png'),
//                   ),
//                   SizedBox(width: 8),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'Login',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontFamily: 'Rubik Medium',
//                   color: Color(0xff203142),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Welcome to Digital Bus Pass App',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontFamily: 'Rubik Regular',
//                   color: Color(0xff4C5980),
//                 ),
//               ),
//               const SizedBox(height: 30),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: TextFormField(
//                   controller: emailController,
//                   keyboardType: TextInputType.emailAddress,
//                   decoration: InputDecoration(
//                     hintText: 'Email',
//                     fillColor: const Color(0xffF8F9FA),
//                     filled: true,
//                     prefixIcon: const Icon(
//                       Icons.alternate_email,
//                       color: Color(0xff323F4B),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 child: TextFormField(
//                   controller: passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     hintText: 'Password',
//                     fillColor: const Color(0xffF8F9FA),
//                     filled: true,
//                     prefixIcon: const Icon(
//                       Icons.lock_open,
//                       color: Color(0xff323F4B),
//                     ),
//                     suffixIcon: const Icon(Icons.visibility_off_outlined),
//                     focusedBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: const BorderSide(color: Color(0xffE4E7EB)),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(right: 16, top: 10),
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: Text(
//                     'Forgot Password?',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontFamily: 'Rubik Regular',
//                       color: Color(0xff203142),
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 80),
//               Container(
//                 height: 50,
//                 width: 300,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Color(0xff2E7D32), Color(0xff4CAF50)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.green.withOpacity(0.3),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: TextButton(
//                   onPressed: loginUser,
//                   child: const Text(
//                     'Log In',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontFamily: 'Rubik Medium',
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Text(
//                     "Don't have an Account?",
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontFamily: 'Rubik Regular',
//                       color: Color(0xff4C5980),
//                     ),
//                   ),
//                   const SizedBox(height: 17),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => const RegisterScreen(),
//                         ),
//                       );
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.transparent,
//                       elevation: 0,
//                       shadowColor: Colors.transparent,
//                     ),
//                     child: const Text(
//                       'Register Here',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontFamily: 'Rubik Medium',
//                         color: Color(0xff2E7D32),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//

import 'package:flutter/material.dart';
import 'package:digital_bus_pass_system/multilang_screen.dart';
import 'package:digital_bus_pass_system/register_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  final void Function(Locale)? onLanguageChange; // 👈 Added

  const LoginScreen({super.key, this.onLanguageChange}); // 👈 Accepts the callback

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState(){
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    super.initState();

  }

  void loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showSnackBar("Please enter both email and password");
      return;
    }

    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(userCredential.toString());
      if (userCredential.user != null && context.mounted) {
        showSnackBar("Login Successful");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userid', userCredential.user!.uid.toString());


        // 👇 Pass the language change callback to MultilangScreen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MultilangScreen(
              onLanguageSelected: widget.onLanguageChange ?? (locale) {},
            ),
          ),
            (route)=>false

        );
      }
    } catch (e) {
      showSnackBar("Login Failed: ${e.toString().split('] ').last}");
    }
  }

  void showSnackBar(String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Image(
                    height: 100,
                    width: 100,
                    image: AssetImage('assets/pmt_bus.png'),
                  ),
                  SizedBox(width: 8),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 28,
                  fontFamily: 'Rubik Medium',
                  color: Color(0xff203142),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Welcome to Digital Bus Pass App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'Rubik Regular',
                  color: Color(0xff4C5980),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    fillColor: const Color(0xffF8F9FA),
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.alternate_email,
                      color: Color(0xff323F4B),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    fillColor: const Color(0xffF8F9FA),
                    filled: true,
                    prefixIcon: const Icon(
                      Icons.lock_open,
                      color: Color(0xff323F4B),
                    ),
                    suffixIcon: const Icon(Icons.visibility_off_outlined),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xffE4E7EB)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16, top: 10),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Rubik Regular',
                      color: Color(0xff203142),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xff2E7D32), Color(0xff4CAF50)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextButton(
                  onPressed: loginUser,
                  child: const Text(
                    'Log In',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Rubik Medium',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an Account?",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Rubik Regular',
                      color: Color(0xff4C5980),
                    ),
                  ),
                  const SizedBox(height: 17),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    child: const Text(
                      'Register Here',
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Rubik Medium',
                        color: Color(0xff2E7D32),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


