import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabasechat/constants.dart';
import 'package:supabasechat/models/message.dart';
import 'package:supabasechat/models/user.dart';

import 'package:timeago/timeago.dart' as timeago;

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
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    reverse: true,
                    itemBuilder: (_, index) {
                      final message = _messages[index];
                      final user = _users[message.userId];
                      final isMyChat = user.id == message.userId;
                      List<Widget> chatContents = [
                        if (!isMyChat) ...[
                          CircleAvatar(
                            radius: 25,
                            child: Text(user.name),
                          ),
                          const SizedBox(width: 12),
                        ],
                        Flexible(
                          child: Material(
                            borderRadius: BorderRadius.circular(8),
                            color: isMyChat
                                ? Theme.of(context).accentColor
                                : Colors.black,
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(message.message),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (message.isSending)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 1),
                          )
                        else
                          Text(
                            timeago.format(message.insertedAt,
                                locale: 'en_short'),
                          ),
                      ];
                      if (isMyChat) {
                        chatContents = chatContents.reversed.toList();
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: isMyChat
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: chatContents,
                        ),
                      );
                    },
                    itemCount: _messages.length,
                  ),
          ),
          _MessageInput(
            roomId: widget.roomId,
            onSend: (message) {
              setState(() {
                _messages.insert(0, message);
              });
            },
          ),
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
    final usersTable = supabase.from('users');
    final snap = await supabase
        .from('messages')
        .select()
        .eq('room_id', widget.roomId)
        .order('inserted_at')
        .execute();
    final messages = Message.fromRows(snap.data as List);
    final userFutures = messages
        .map(
            (message) => usersTable.select().eq('id', message.userId).execute())
        .toList();
    final userSnaps = await Future.wait(userFutures);
    final users =
        userSnaps.map((userSnap) => User.fromMap(userSnap.data[0])).toList();
    for (final user in users) {
      _users[user.id] = user;
    }
    setState(() {
      _messages = messages;
      _isLoading = false;
    });
    _listener = supabase
        .from('messages:room_id=eq.${widget.roomId}')
        .on(SupabaseEventTypes.insert, (payload) {
      _messages.removeWhere((message) => message.isSending);
      _messages.insertAll(
        0,
        Message.fromRows([payload.newRecord as Map<String, dynamic>].toList()),
      );
      setState(() {});
    }).subscribe();
  }
}

class _MessageInput extends StatefulWidget {
  const _MessageInput({
    Key key,
    @required this.roomId,
    @required this.onSend,
  }) : super(key: key);

  final int roomId;
  final void Function(Message) onSend;

  @override
  __MessageInputState createState() => __MessageInputState();
}

class __MessageInputState extends State<_MessageInput> {
  TextEditingController _textController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  maxLines: null,
                  controller: _textController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Type your message...',
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  final message = _textController.text;
                  if (message.isEmpty) {
                    return;
                  }
                  final user = supabase.auth.currentUser;
                  final sendingMessage = Message(
                    id: 0,
                    userId: user.id,
                    insertedAt: DateTime.now(),
                    message: message,
                    isSending: true,
                  );
                  widget.onSend(sendingMessage);
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
        ),
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
