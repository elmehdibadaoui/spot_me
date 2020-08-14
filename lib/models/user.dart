import 'package:firebase_database/firebase_database.dart';

class User {
  String key;
  String photo;
  String city;
  String gender;
  String height;
  String eye_color;
  String hair_color;
  String userId;

  User(this.photo, this.city, this.gender, this.height, this.eye_color,
      this.hair_color, this.userId);

  User.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        photo = snapshot.value["photo"],
        city = snapshot.value["city"],
        gender = snapshot.value["gender"],
        height = snapshot.value["height"],
        eye_color = snapshot.value["eye_color"],
        hair_color = snapshot.value["hair_color"],
        userId = snapshot.value["userId"];

  toJson() {
    return {
      "photo": photo,
      "city": city,
      "gender": gender,
      "height": height,
      "eye_color": eye_color,
      "hair_color": hair_color,
      "userId": userId
    };
  }
}
