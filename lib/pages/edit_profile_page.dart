import 'package:flutter/material.dart';
import 'package:supabasechat/constants.dart';
import 'package:supabasechat/models/avatar.dart';

class EditProfilePage extends StatefulWidget {
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
              items: _avatars
                  .map<DropdownMenuItem<Avatar>>(
                      (avatar) => DropdownMenuItem(child: Text(avatar.url)))
                  .toList(),
              onChanged: (selectedAvatar) {
                setState(() {
                  _selectedAvatar = selectedAvatar;
                });
              }),
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
        ],
      ),
    );
  }

  @override
  void initState() {
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _getAllAvatars() async {
    final res = await supabase.from('avatars').select().execute();
    final data = List<Map<String, dynamic>>.from(res.data as List);
    _avatars = data.map<Avatar>((map) => Avatar.fromMap(map)).toList();
  }
}
