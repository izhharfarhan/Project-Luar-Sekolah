import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isButtonEnabled = false;

  // Data dummy pengguna lengkap
  final List<Map<String, String>> _dummyUsers = [
    {
      'email': 'izhharfarhan@gmail.com',
      'password': '123456',
      'name': 'zar',
      'job': 'Mobile Developer',
      'phone': '081234567890',
    },
    {
      'email': 'ahmad@gmail.com',
      'password': 'qwerty123',
      'name': 'ahmad',
      'job': 'UI/UX Designer',
      'phone': '082345678901',
    },
    {
      'email': 'oliver@gmail.com',
      'password': 'asdasd123',
      'name': 'oliver',
      'job': 'Data Scientist',
      'phone': '083456789012',
    },
  ];

  void _validateForm() {
    setState(() {
      _isButtonEnabled = _formKey.currentState?.validate() ?? false;
    });
  }

  // Simpan semua data user ke SharedPreferences
  Future<void> _saveLoginData(Map<String, String> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', user['email']!);
    await prefs.setString('name', user['name']!);
    await prefs.setString('job', user['job']!);
    await prefs.setString('phone', user['phone']!);
  }

  // Cek kecocokan login dengan data dummy
  Future<void> _attemptLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    final user = _dummyUsers.firstWhere(
      (user) => user['email'] == email && user['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      await _saveLoginData(user);
      Navigator.pushReplacementNamed(context, '/main');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email atau Password salah')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          onChanged: _validateForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Masukkan Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Masukkan Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isButtonEnabled ? _attemptLogin : null,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
