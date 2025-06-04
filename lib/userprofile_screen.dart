// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//
//   TextEditingController nameController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//
//   String? selectedLanguage;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _loadLanguage();
//   }
//
//   Future<void> _loadUserData() async {
//     User? user = _auth.currentUser;
//     if (user != null) {
//       DocumentSnapshot snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .get();
//
//       if (snapshot.exists) {
//         Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//         nameController.text = data['name'] ?? '';
//         emailController.text = data['email'] ?? '';
//         phoneController.text = data['phone'] ?? '';
//       }
//     }
//
//     setState(() {
//       isLoading = false;
//     });
//   }
//
//   Future<void> _loadLanguage() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       selectedLanguage = prefs.getString('selected_language') ?? 'Not selected';
//     });
//   }
//
//   Future<void> _saveProfile() async {
//     if (_formKey.currentState!.validate()) {
//       User? user = _auth.currentUser;
//       if (user != null) {
//         await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
//           'name': nameController.text,
//           'email': emailController.text,
//           'phone': phoneController.text,
//         });
//
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.setString('selected_language', selectedLanguage ?? 'Not selected');
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile saved successfully')),
//         );
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile Info'),
//         backgroundColor: Colors.teal,
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: 'Name'),
//                 validator: (value) =>
//                 value == null || value.isEmpty ? 'Enter your name' : null,
//               ),
//               TextFormField(
//                 controller: emailController,
//                 decoration: const InputDecoration(labelText: 'Email'),
//                 validator: (value) =>
//                 value == null || value.isEmpty ? 'Enter your email' : null,
//               ),
//               TextFormField(
//                 controller: phoneController,
//                 decoration: const InputDecoration(labelText: 'Phone'),
//                 validator: (value) =>
//                 value == null || value.isEmpty ? 'Enter your phone' : null,
//               ),
//               const SizedBox(height: 20),
//               DropdownButtonFormField<String>(
//                 value: selectedLanguage,
//                 items: ['English', 'Hindi', 'Marathi']
//                     .map((lang) => DropdownMenuItem(
//                   value: lang,
//                   child: Text(lang),
//                 ))
//                     .toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     selectedLanguage = value!;
//                   });
//                 },
//                 decoration: const InputDecoration(
//                   labelText: 'Select Language',
//                 ),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _saveProfile,
//                 style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
//                 child: const Text('Save Profile'),
//               ),
//               const SizedBox(height: 20),
//               const Divider(),
//               const Text("Saved Information:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               Text("Name: ${nameController.text}", style: const TextStyle(fontSize: 16)),
//               Text("Email: ${emailController.text}", style: const TextStyle(fontSize: 16)),
//               Text("Phone: ${phoneController.text}", style: const TextStyle(fontSize: 16)),
//               Text("Selected Language: $selectedLanguage", style: const TextStyle(fontSize: 16)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? selectedLanguage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadLanguage();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        nameController.text = data['name'] ?? '';
        emailController.text = data['email'] ?? '';
        phoneController.text = data['phone'] ?? '';
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getString('selected_language') ?? 'Not selected';
    });
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      User? user = _auth.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'name': nameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('selected_language', selectedLanguage ?? 'Not selected');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully')),
        );

        setState(() {}); // Refresh the UI to show updated info
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Info'),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter your name' : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter your email' : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) =>
                value == null || value.isEmpty ? 'Enter your phone' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedLanguage == 'Not selected' ? null : selectedLanguage,
                items: ['English', 'Hindi', 'Marathi']
                    .map((lang) => DropdownMenuItem(
                  value: lang,
                  child: Text(lang),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Select Language',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Save Profile'),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const Text("Saved Information:",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Name: ${nameController.text}", style: const TextStyle(fontSize: 16)),
              Text("Email: ${emailController.text}", style: const TextStyle(fontSize: 16)),
              Text("Phone: ${phoneController.text}", style: const TextStyle(fontSize: 16)),
              Text("Selected Language: $selectedLanguage",
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
