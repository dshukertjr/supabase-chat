import 'package:flutter/material.dart';
import 'package:supabasechat/pages/chat_page.dart';
import 'package:supabasechat/supabase_provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    redirect();
    super.initState();
  }

  Future<void> redirect() async {
    /// Check Auth State
    final supabase = SupabaseProvider.instance;
    final authUser = supabase.auth.currentUser;
    if (authUser == null) {
      await supabase.auth.signUp('dshukertjr@gmail.com', 'somesome');
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ChatPage(),
      ),
    );
  }
}
