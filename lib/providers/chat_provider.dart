import 'package:Beepo/app.dart';
import 'package:Beepo/providers/account_provider.dart';
import 'package:Beepo/services/database.dart';
import 'package:Beepo/session/foreground_session.dart';
import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:xmtp/xmtp.dart';

class ChatProvider extends ChangeNotifier {
  List<DecodedMessage>? messages;
  List<Conversation>? convos;
  String? me;

  Future<String> uploadStatus(base64Image, text, privacy) async {
    try {
      await dbUploadStatus(base64Image, AccountProvider().db!, text, privacy, me!);

      return "done";
    } catch (e) {
      if (kDebugMode) {
        print(e);
        return (e.toString());
      }
    }
    return ('Not done');
  }

  void updateMessages(List<DecodedMessage> event) async {
    print(event.length);
    if (event.isEmpty) return;
    if (messages != null && messages!.isNotEmpty) {
      if (messages![0].sentAt == event[0].sentAt && messages![0].sender == event[0].sender) {
        messages = event;
        notifyListeners();
        return;
      }
      if (event[0].sender.toString() == me) {
        messages = event;
        notifyListeners();
        return;
      }
      sendNotification(event[0]);
    }
    messages = event;
    notifyListeners();
  }

  void updateConvos(List<Conversation> event) async {
    if (event.isEmpty) return;
    me = me ?? event[0].me.toString();
    convos = event;
    notifyListeners();
  }

  Stream<List<Conversation>> findAndWatchAllConvos() {
    return _useLookupStream(
      () => session.findConversations(),
      () => session.watchConversations(),
    );
  }

  Stream<List<DecodedMessage>> findAndWatchAllMessages() {
    return _useLookupStream(
      () => session.findAllMessages(),
      () => session.watchAllMessages(),
    );
  }

  Stream<T> _useLookupStream<T>(
    Future<T> Function() find,
    Stream<T> Function() watch, [
    List<Object?> keys = const <Object>[],
  ]) =>
      StreamGroup.mergeBroadcast([find().asStream(), watch()]);
}
