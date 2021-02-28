import 'package:flutter/foundation.dart';

class User {
  final String uuid;
  final String name;

  User({
    @required this.uuid,
    @required this.name,
  });

  Map<String, dynamic> toMap() {
    return {
      'uuid': uuid,
      'name': name,
    };
  }

  factory User.fromMap(dynamic map) {
    if (map == null) return null;

    return User(
      uuid: map['uuid'] as String,
      name: map['name'] as String,
    );
  }
}
