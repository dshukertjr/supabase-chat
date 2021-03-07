import 'package:flutter/foundation.dart';
import 'package:supabasechat/models/message.dart';

class Room {
  final String id;
  final String name;
  final Message lastMessage;

  Room({
    @required this.id,
    @required this.name,
    this.lastMessage,
  });
}
