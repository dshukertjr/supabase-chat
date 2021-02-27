import 'package:flutter/material.dart';
import 'package:supabasechat/constants.dart';
import 'package:supabasechat/models/avatar.dart';
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
  List<Avatar> _avatars;
  Avatar _selectedAvatar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 20,
        ),
        children: [
          DropdownButtonFormField<Avatar>(
            validator: (val) {
              if (val == null) {
                return 'Required';
              }
              return null;
            },
            items: _avatars
                .map<DropdownMenuItem<Avatar>>(
                    (avatar) => DropdownMenuItem(child: Text(avatar.url)))
                .toList(),
            onChanged: (selectedAvatar) {
              setState(() {
                _selectedAvatar = selectedAvatar;
              });
            },
          ),
          const SizedBox(height: 24),
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
          ElevatedButton(onPressed: _save, child: const Text('保存'))
        ],
      ),
    );
  }

  @override
  void initState() {
    _getAllAvatars();
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final user = supabase.auth.currentUser;
    await supabase.from('users').insert({
      'id': user.id,
      'avatar_id': _selectedAvatar.id,
    }, upsert: true).execute();
    if (widget.isCreatingAccount) {
      Navigator.of(context).pushReplacement(SplashPage.route());
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _getAllAvatars() async {
    final res = await supabase.from('avatars').select().execute();
    final data = List<Map<String, dynamic>>.from(res.data as List);
    _avatars = data.map<Avatar>((map) => Avatar.fromMap(map)).toList();
    setState(() {});
  }
}
