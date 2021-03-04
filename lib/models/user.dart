import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String name;

  User({
    @required this.id,
    @required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory User.fromMap(dynamic map) {
    if (map == null) return null;

    return User(
      id: map['id'] as String,
      name: map['name'] as String,
    );
  }
}
