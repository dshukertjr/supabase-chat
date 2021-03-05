import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabasechat/pages/splash_page.dart';

import '../constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailConntroller;
  TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          children: [
            const SizedBox(height: 72),
            TextFormField(
              controller: _emailConntroller,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _emailConntroller = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailConntroller.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    await _executeAuthAction(true);
  }

  Future<void> _register() async {
    _executeAuthAction(false);
  }

  Future<void> _executeAuthAction(bool isLogin) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    final email = _emailConntroller.text;
    final password = _passwordController.text;
    final prefs = await SharedPreferences.getInstance();
    if (isLogin) {
      final res = await supabase.auth.signIn(
        email: email,
        password: password,
      );
      prefs.setString(PERSIST_SESSION_KEY, res.data.persistSessionString);
    } else {
      final res = await supabase.auth.signUp(email, password);
      prefs.setString(PERSIST_SESSION_KEY, res.data.persistSessionString);
    }
    Navigator.of(context).pushReplacement(SplashPage.route());
  }
}
