import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:supabasechat/models/message.dart';
import 'package:supabasechat/models/room.dart';
import 'package:supabasechat/models/user.dart';

import '../../constants.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  List<Room> _rooms = [];
  Map<int, List<Message>> _messages = {};
  Map<String, User> _users = {};

  Future<void> getUser(String userId) async {
    if (_users[userId] == null) {
      final snap =
          await supabase.from('users').select().eq('id', userId).execute();
      final user = User.fromMap(snap.data[0]);
      _users[userId] = user;
    }
    return _users[userId];
  }

  Future<void> getRooms() async {
    final roomsSnap = await supabase.from('recent_chats').select().execute();
    final rooms = Room.fromRows(roomsSnap.data as List);
    _rooms = rooms;
    for (final room in rooms) {
      _users[room.lastMessage.user.id] = room.lastMessage.user;
    }
  }
}
