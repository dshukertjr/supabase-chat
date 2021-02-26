import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:supabasechat/supabase_provider.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // TODO dispose listener
  var _listener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('unsubscribe'),
          onPressed: () {
            _listener.unsubscribe();
          },
        ),
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
    // TODO: implement dispose of listener
    super.dispose();
  }

  void setupListeners() {
    _listener = SupabaseProvider.instance
        .from('funny_memes')
        .on(SupabaseEventTypes.all, (payload) {
      print(
          'on countries.all: ${payload.table} ${payload.eventType} ${payload.oldRecord}');
    }).subscribe();
  }
}
