import 'package:flutter/foundation.dart';
import 'package:supabasechat/models/user.dart';

class Message {
  final int id;
  final String userId;
  final User user;
  final DateTime insertedAt;
  final String message;
  final bool isSending;

  Message({
    @required this.id,
    @required this.userId,
    this.user,
    @required this.insertedAt,
    @required this.message,
    this.isSending = false,
  });

  static List<Message> fromRows(List<dynamic> rows) {
    return rows
        .map<Message>((row) => Message(
              id: row['id'] as int,
              userId: row['user_id'] as String,
              insertedAt: DateTime.parse(row['inserted_at'] as String),
              message: row['message'] as String,
            ))
        .toList();
  }
}
