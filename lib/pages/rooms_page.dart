import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabasechat/blocs/cubit/chat_cubit.dart';
import 'package:supabasechat/components/avatar.dart';
import 'package:supabasechat/pages/chat_page.dart';

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
      body: BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
        if (state is ChatInitial) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ChatLoaded) {
          final rooms = state.rooms;
          return ListView.separated(
            itemBuilder: (_, index) {
              final room = rooms[index];
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(ChatPage.route(room.id));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Avatar(
                        size: 70,
                        name: room.lastMessage.user.name,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            room.lastMessage.user.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            room.lastMessage.message,
                            style: const TextStyle(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemCount: rooms.length,
          );
        } else {
          return Container();
        }
      }),
    );
  }

  @override
  void initState() {
    BlocProvider.of<ChatCubit>(context).getRooms();
    super.initState();
  }
}
