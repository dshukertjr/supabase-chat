import 'package:flutter/foundation.dart';
import 'package:supabasechat/models/message.dart';
import 'package:supabasechat/models/user.dart';

class Room {
  final int id;
  final String name;
  final Message lastMessage;

  Room({
    @required this.id,
    @required this.name,
    this.lastMessage,
  });

  static List<Room> fromRows(List<dynamic> rows) {
    return rows
        .map<Room>((row) => Room(
              id: row['id'] as int,
              name: row['name'] as String,
              lastMessage: Message(
                id: row['message_id'] as int,
                userId: row['user_id'] as String,
                message: row['message'] as String,
                insertedAt:
                    DateTime.parse(row['message_inserted_at'] as String),
                user: User(
                  id: row['user_id'] as String,
                  name: row['user_name'] as String,
                ),
              ),
            ))
        .toList();
  }
}
