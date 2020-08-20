import 'package:firebase_database/firebase_database.dart';
import 'package:spot_me/models/user.dart';

class Data {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  userById(String uid) async {
    return await _database.reference().child("users").child(uid).once();
  }

  allMessages() async {
    return await _database.reference().child("messages").once();
  }

//        Data().userById('Zshw5TtCAUfCKbmuN2FbitgF3Tu1').then((snapshot){
//          User user = User.fromSnapshot(snapshot);
//          print(user.userId);
//        });

//        List<Message> _todoList = new List();
//        Data().allMessages().then((snapshot){
//            Map<dynamic, dynamic> values = snapshot.value;
//            values.forEach((key,value) {
//              _todoList.add(Message.fromMap(key, value));
//            });
//
//            print(_todoList.length);
//            print(_todoList[0].message);
//        });

}
