import 'package:flutter/material.dart';
import 'package:spot_me/services/authentication.dart';

class ChatPage extends StatefulWidget {
  ChatPage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Text("je dans la page Chat");
  }
}
