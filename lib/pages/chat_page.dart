import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabasechat/constants.dart';
import 'package:supabasechat/models/message.dart';
import 'package:supabasechat/models/user.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Message> _messages = [];
  final Map<String, User> _users = {};
  var _listener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemBuilder: (_, index) {
                final message = _messages[index];
                final user = _users[message.userId];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          child: Text(user.name),
                        ),
                        Flexible(
                          child: Material(
                            elevation: 2,
                            child: Text(message.message),
                          ),
                        ),
                        const Text('12m'),
                      ],
                    )
                  ],
                );
              },
              itemCount: _messages.length,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(),
                ),
                TextButton(onPressed: () {}, child: const Text('send'))
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    setupListeners();
    super.initState();
  }

  @override
  void dispose() {
    _listener.unsubscribe();
    super.dispose();
  }

  void setupListeners() {
    _listener = supabase.from('chats').on(SupabaseEventTypes.insert, (payload) {
      payload.newRecord;
    }).subscribe();
  }
}
