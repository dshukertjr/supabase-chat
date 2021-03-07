import 'package:flutter/material.dart';

class RoomsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
