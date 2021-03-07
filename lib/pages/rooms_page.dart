import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabasechat/blocs/cubit/chat_cubit.dart';

class RoomsPage extends StatefulWidget {
  static Route<void> route() {
    return MaterialPageRoute(builder: (context) => RoomsPage());
  }

  @override
  _RoomsPageState createState() => _RoomsPageState();
}

class _RoomsPageState extends State<RoomsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rooms'),
      ),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    BlocProvider.of<ChatCubit>(context).getRooms();
    super.initState();
  }
}
