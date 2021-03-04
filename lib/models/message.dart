import 'package:flutter/foundation.dart';

class Message {
  final String id;
  final String userId;
  final DateTime createdAt;
  final String message;

  Message({
    @required this.id,
    @required this.userId,
    @required this.createdAt,
    @required this.message,
  });

  static List<Message> fromRows(List<dynamic> rows) {
    return rows
        .map<Message>((row) => Message(
              id: row['id'] as String,
              userId: row['user_id'] as String,
              createdAt:
                  DateTime.fromMillisecondsSinceEpoch(row['created_at'] as int),
              message: row['message'] as String,
            ))
        .toList();
  }
}
