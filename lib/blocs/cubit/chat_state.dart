part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class ChatLoaded extends ChatState {
  final List<Room> rooms;

  ChatLoaded({
    this.rooms,
  });
}
