import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabasechat/constants.dart';
import 'package:supabasechat/models/message.dart';
import 'package:supabasechat/models/user.dart';

class ChatPage extends StatefulWidget {
  final int roomId;

  const ChatPage(this.roomId, {Key key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> _messages = [];
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
          _MessageInput(roomId: widget.roomId),
        ],
      ),
    );
  }

  @override
  void initState() {
    _getChats();
    super.initState();
  }

  @override
  void dispose() {
    _listener.unsubscribe();
    super.dispose();
  }

  Future<void> _getChats() async {
    final messagesTable = supabase.from('messages');
    final snap = await messagesTable.select().execute();
    setState(() {
      _messages = Message.fromRows(snap.data as List);
    });
    _listener = messagesTable.on(SupabaseEventTypes.insert, (payload) {
      setState(() {
        _messages.addAll(Message.fromRows(payload.newRecord as List));
      });
    }).subscribe();
  }
}

class _MessageInput extends StatefulWidget {
  const _MessageInput({
    Key key,
    @required this.roomId,
  }) : super(key: key);

  final int roomId;

  @override
  __MessageInputState createState() => __MessageInputState();
}

class __MessageInputState extends State<_MessageInput> {
  TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _textController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type your message...',
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final user = supabase.auth.currentUser;
              final message = _textController.text;
              final result = await supabase.from('messages').insert([
                {
                  'message': message,
                  'user_id': user.id,
                  'room_id': widget.roomId,
                }
              ]).execute();
              if (result.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Error occured'),
                ));
              }
              _textController.clear();
            },
            child: const Text('send'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
