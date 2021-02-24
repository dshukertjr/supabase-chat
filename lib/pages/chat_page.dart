import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabasechat/supabase_provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // TODO dispose listener
  // RealtimeSubscription _listener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Container(),
    );
  }

  @override
  void initState() {
    setupListeners();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose of listener
    super.dispose();
  }

  void setupListeners() {
    final listener = SupabaseProvider.instance
        .from('chats')
        .on(SupabaseEventTypes.all, (payload) {
      print(
          'on countries.delete: ${payload.table} ${payload.eventType} ${payload.oldRecord}');
    }).subscribe((String event, {String errorMsg}) {
      print('event: $event error: $errorMsg');
    });
  }
}
