import 'package:flutter/material.dart';
import 'package:supabasechat/supabase_provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailConntroller = TextEditingController();
  final _passwordController = TextEditingController();

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
            decoration: InputDecoration(
              labelText: 'メールアドレス',
            ),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'パスワード',
            ),
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

  Future<void> _login() async {
    final supabase = SupabaseProvider.instance;
    await supabase.auth.signUp('dshukertjr@gmail.com', 'somesome');
  }

  Future<void> _register() async {
    final supabase = SupabaseProvider.instance;
    await supabase.auth.signUp('dshukertjr@gmail.com', 'somesome');
  }

  @override
  void dispose() {
    _emailConntroller.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
