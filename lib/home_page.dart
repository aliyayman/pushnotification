// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:pushnotification/firebase_api.dart';
import 'package:pushnotification/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseApi _firebaseApi = FirebaseApi();
  String? token = '';
  String? username;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setToken();
  }

  void setToken() async {
    token = await FirebaseService.instance.getFcmToken();
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : _body(usernameController, context),
    );
  }

  Padding _body(TextEditingController _usernameController, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (_isLoading) return;
              username = _usernameController.text;
              setState(() {
                _isLoading = true;
              });
              var response = await _firebaseApi.addUser(username ?? 'username', token ?? 'token null');
              _usernameController.clear();
              if (response) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('$username added successfully'),
                  ),
                );
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to add user'),
                  ),
                );
                if (mounted) {
                  setState(() {
                    _isLoading = false;
                  });
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
