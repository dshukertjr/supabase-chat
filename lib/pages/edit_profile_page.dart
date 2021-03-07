import 'package:flutter/material.dart';
import 'package:supabasechat/constants.dart';
import 'package:supabasechat/models/user.dart';
import 'package:supabasechat/pages/splash_page.dart';

class EditProfilePage extends StatefulWidget {
  final bool isCreatingAccount;

  const EditProfilePage({
    Key key,
    @required this.isCreatingAccount,
  }) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(
            vertical: 30,
            horizontal: 20,
          ),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'User Name',
              ),
              validator: (val) {
                if (val.isEmpty) {
                  return 'Required';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: _save, child: const Text('Save'))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    _getCurrentProfile();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = supabase.auth.currentUser;
    if (!_formKey.currentState.validate()) {
      return;
    }
    final name = _nameController.text;
    await supabase.from('users').insert([
      {
        'id': user.id,
        'name': name,
      }
    ], upsert: true).execute();
    if (widget.isCreatingAccount) {
      Navigator.of(context).pushReplacement(SplashPage.route());
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _getCurrentProfile() async {
    final user = supabase.auth.currentUser;
    final res =
        await supabase.from('users').select().eq('id', user.id).execute();
    final data = res.data as List<dynamic>;
    if (data.isEmpty) {
      return;
    }
    final userProfile = User.fromMap(data.first);
    if (userProfile != null) {
      setState(() {
        _nameController.text = userProfile.name;
      });
    }
  }
}
