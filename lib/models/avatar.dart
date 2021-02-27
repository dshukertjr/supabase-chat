import 'dart:convert';

import 'package:flutter/foundation.dart';

class Avatar {
  final String id;
  final String url;

  Avatar({
    @required this.id,
    @required this.url,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'url': url,
    };
  }

  factory Avatar.fromMap(dynamic map) {
    if (map == null) return null;

    return Avatar(
      id: map['id'] as String,
      url: map['url'] as String,
    );
  }
}
