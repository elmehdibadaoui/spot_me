import 'package:flutter/material.dart';
import 'package:spot_me/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:spot_me/models/todo.dart';
import 'dart:async';

import 'package:spot_me/pages/explore_page.dart';
import 'package:spot_me/pages/chat_page.dart';
import 'package:spot_me/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> _todoList;

  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _textEditingController = TextEditingController();
  StreamSubscription<Event> _onTodoAddedSubscription;
  StreamSubscription<Event> _onTodoChangedSubscription;

  Query _todoQuery;

  //bool _isEmailVerified = false;



//  void _checkEmailVerification() async {
//    _isEmailVerified = await widget.auth.isEmailVerified();
//    if (!_isEmailVerified) {
//      _showVerifyEmailDialog();
//    }
//  }

//  void _resentVerifyEmail(){
//    widget.auth.sendEmailVerification();
//    _showVerifyEmailSentDialog();
//  }

//  void _showVerifyEmailDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content: new Text("Please verify account in the link sent to email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Resent link"),
//              onPressed: () {
//                Navigator.of(context).pop();
//                _resentVerifyEmail();
//              },
//            ),
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content: new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new FlatButton(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  @override
  void dispose() {
    _onTodoAddedSubscription.cancel();
    _onTodoChangedSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Spot Me'),
            actions: <Widget>[
              new FlatButton(
                  child: new Text('Fermer',
                      style: new TextStyle(
                          fontSize: 17.0, color: Colors.white)),
                  onPressed: signOut)
            ],
          ),
          bottomNavigationBar: menu(),
          body: TabBarView(
            children: [
              new ExplorePage(
                userId: widget.userId,
                auth: widget.auth,
                logoutCallback: widget.logoutCallback,
              ),
              new ChatPage(
                userId: widget.userId,
                auth: widget.auth,
                logoutCallback: widget.logoutCallback,
              ),
              new ProfilePage(
                userId: widget.userId,
                auth: widget.auth,
                logoutCallback: widget.logoutCallback,
              )
            ],
          ),
        ),
      ),
//        floatingActionButton: FloatingActionButton(
//          onPressed: () {
//            showAddTodoDialog(context);
//          },
//          tooltip: 'Increment',
//          child: Icon(Icons.add),
//        )
    );
  }

  Widget menu() {
    print("********************************" + widget.userId);
    return Container(
      color: Colors.red,
      child: TabBar(
        indicatorColor: Colors.white,
        tabs: [
          Tab(icon: Icon(Icons.explore)),
          Tab(icon: Icon(Icons.chat)),
          Tab(icon: Icon(Icons.person)),
        ],
      ),
    );
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }
}

//showTodoList()
