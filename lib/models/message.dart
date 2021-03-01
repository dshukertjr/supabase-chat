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
}
