import 'package:flutter/material.dart';
import 'package:supabasechat/models/user.dart';
import 'package:supabasechat/pages/chat_page.dart';
import 'package:supabasechat/pages/edit_profile_page.dart';
import 'package:supabasechat/pages/login_page.dart';
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
      _redirectToLoginPage();
      return;
    }
    final snap =
        await supabase.from('users').select().eq('uuid', authUser.id).execute();
    final map = snap.toJson()['data'];
    final user = User.fromMap(map);
    if (user == null) {
      _redirectToEditProfilePage();
      return;
    }

    _redirectToChatPage();
  }

  void _redirectToLoginPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => LoginPage(),
      ),
    );
  }

  void _redirectToEditProfilePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => EditProfilePage(),
      ),
    );
  }

  void _redirectToChatPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ChatPage(),
      ),
    );
  }
}
