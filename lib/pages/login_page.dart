import 'package:flutter/material.dart';
import 'package:supabasechat/supabase_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailConntroller;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: ListView(
        children: [
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
          ElevatedButton(
            onPressed: _login,
            child: const Text('ログイン'),
          ),
          ElevatedButton(
            onPressed: _register,
            child: const Text('登録'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _emailConntroller = TextEditingController();
    _passwordController = TextEditingController();
    _formKey = GlobalKey<FormState>();
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
    final supabase = SupabaseProvider.instance;
    final email = _emailConntroller.text;
    final password = _passwordController.text;
    if (isLogin) {
      await supabase.auth.signIn(
        email: 'dshukertjr@gmail.com',
        password: 'somesome',
      );
    } else {
      await supabase.auth.signUp('dshukertjr@gmail.com', 'somesome');
    }
  }
}
