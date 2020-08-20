import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:spot_me/services/authentication.dart';

import 'package:spot_me/services/data.dart';
import 'package:spot_me/models/user.dart';
import 'package:spot_me/models/message.dart';
import 'package:spot_me/utils/Utils.dart';

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
  final _searchbox = TextEditingController();

  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  List<Message> _todoList;

  Query _todoQuery;

  @override
  void initState() {
    super.initState();

    //_checkEmailVerification();

    _todoList = new List();
    _todoQuery = _database.reference().child("messages").child(widget.userId);
    _onTodoAddedSubscription = _todoQuery.onChildAdded.listen(onEntryAdded);
    _onTodoChangedSubscription =
        _todoQuery.onChildChanged.listen(onEntryChanged);
  }

  onEntryChanged(Event event) {
    var oldEntry = _todoList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _todoList[_todoList.indexOf(oldEntry)] =
          Message.fromSnapshot(event.snapshot);
    });
  }

  onEntryAdded(Event event) {
    setState(() {
      _todoList.add(Message.fromSnapshot(event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
//      color: Colors.purple,
      width: 50,
      padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Conversation",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1)),
          searchInput(),
          Expanded(
              child: ListView(
            children: <Widget>[
              userMessage(),
              userMessage(),
              userMessage(),
              userMessage(),
              userMessage(),
              userMessage(),
              userMessage(),
              userMessage(),
              userMessage(),
              userMessage(),
              userMessage(),
            ],
          ))
        ],
      ),
    );
  }

  Widget searchInput() {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 30.0),
      child: Container(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 50,
                  color: Colors.red.withOpacity(0.2))
            ]),
        child: TextFormField(
          controller: _searchbox,
          keyboardType: TextInputType.text,
          decoration: new InputDecoration(
            hintText: 'rechercher un ami',
            icon: CircleAvatar(
              radius: 17,
              backgroundColor: Colors.red,
              child: IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  //
                },
              ),
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget userMessage() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/no-image.png'),
      ),
      title: Text(
        'John Judah',
      ),
      subtitle: Text('2348031980943'),
//      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
        var newMessageKey = _database
            .reference()
            .child('messages')
            .child(widget.userId)
            .push()
            .key;

        print(newMessageKey);

        // HxFa2f5PeRYzFZw7megXcg5BEqJ2
        // Zshw5TtCAUfCKbmuN2FbitgF3Tu1

//        print(ServerValue.timestamp.values.);

        _database
            .reference()
            .child('messages')
            .child(widget.userId)
            .child(newMessageKey)
            .update(new Message(
                    'Zshw5TtCAUfCKbmuN2FbitgF3Tu1', 'le message', 10654654654)
                .toJson());
//
//        print(widget.userId);
        print(_todoList.length);
//        print(_todoList[0].message);
      },
    );
  }
}
