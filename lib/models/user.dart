import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  final String uuid;
  final String name;
  final String avatarUrl;

  User({
    @required this.uuid,
    @required this.name,
    @required this.avatarUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
      'avatarUrl': avatarUrl,
    };
  }

  factory User.fromMap(dynamic map) {
    if (map == null) return null;

    return User(
      uuid: map['uuid'] as String,
      name: map['name'] as String,
      avatarUrl: map['avatarUrl'] as String,
    );
  }
}
