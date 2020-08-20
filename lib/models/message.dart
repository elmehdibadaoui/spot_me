import 'package:firebase_database/firebase_database.dart';

class Message {
  String key;
  String uid_from;
  String message;
  int timestamp;

  Message(this.uid_from, this.message, this.timestamp);

  Message.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        uid_from = snapshot.value["uid_from"],
        message = snapshot.value["message"],
        timestamp = snapshot.value["timestamp"];

  Message.fromMap(dynamic key, dynamic value)
      : key = key,
        uid_from = value["uid_from"],
        message = value["message"],
        timestamp = value["timestamp"];

  toJson() {
    return {"uid_from": uid_from, "message": message, "timestamp": timestamp};
  }
}
