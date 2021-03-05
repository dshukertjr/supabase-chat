import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabasechat/models/user.dart';
import 'package:supabasechat/pages/chat_page.dart';
import 'package:supabasechat/pages/edit_profile_page.dart';
import 'package:supabasechat/pages/login_page.dart';

import '../constants.dart';

class SplashPage extends StatefulWidget {
  static Route<void> route() {
    return MaterialPageRoute(builder: (_) => SplashPage());
  }

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

  Future<void> _restoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSession = prefs.containsKey(PERSIST_SESSION_KEY);
    if (!hasSession) {
      return;
    }

    final jsonStr = prefs.getString(PERSIST_SESSION_KEY);
    final response = await supabase.auth.recoverSession(jsonStr);
    if (response.error != null) {
      prefs.remove(PERSIST_SESSION_KEY);
      return;
    }

    await supabase.auth.refreshSession();

    prefs.setString(PERSIST_SESSION_KEY, response.data.persistSessionString);
  }

  Future<void> redirect() async {
    await Future.delayed(const Duration(milliseconds: 100));
    await _restoreSession();

    /// Check Auth State
    final authUser = supabase.auth.currentUser;
    if (authUser == null) {
      _redirectToLoginPage();
      return;
    }
    final snap =
        await supabase.from('users').select().eq('id', authUser.id).execute();
    final error = snap.error;
    final data = snap.data as List<dynamic>;
    if (data.isEmpty) {
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
        builder: (_) => const EditProfilePage(isCreatingAccount: true),
      ),
    );
  }

  void _redirectToChatPage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ChatPage(1),
      ),
    );
  }
}
