import 'package:clipboard/clipboard.dart';
import 'package:flutter/material.dart';
import 'package:supabasechat/models/user.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage(this.user, {Key? key}) : super(key: key);

  static Route<void> route(User user) {
    return MaterialPageRoute(builder: (_) => ProfilePage(user));
  }

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 100,
              child: Text(
                user.name,
                style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyText1.fontSize * 4,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('User ID: ${user.id}'),
                _CopyButton(user: user),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  const _CopyButton({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.copy),
        onPressed: () async {
          await FlutterClipboard.copy(user.id);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Copied')));
        });
  }
}
