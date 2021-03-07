import 'package:flutter/material.dart';

class Avatar extends StatelessWidget {
  final String name;
  final double size;

  const Avatar({
    Key key,
    @required this.name,
    this.size = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      child: Text(
        name,
        style: TextStyle(
          fontSize: Theme.of(context).textTheme.bodyText1.fontSize * size / 50,
        ),
      ),
    );
  }
}
