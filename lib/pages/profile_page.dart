import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:spot_me/models/user.dart';
import 'package:spot_me/services/authentication.dart';

import 'package:image_picker/image_picker.dart';

import 'dart:io' as Io;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  User user = null;
  final _city = TextEditingController();
  final _gender = TextEditingController();
  final _height = TextEditingController();
  final _eye_color = TextEditingController();
  final _hair_color = TextEditingController();

  Query _profileQuery;

  bool _status = true;

  bool _isLoading = false;

  StreamSubscription<Event> _onProfilAddedSubscription;
  StreamSubscription<Event> _onProfilChangedSubscription;

  @override
  void initState() {
    super.initState();

//    _checkEmailVerification();

    _profileQuery = _database
        .reference()
        .child("users")
        .orderByChild("userId")
        .equalTo(widget.userId);

    _onProfilAddedSubscription =
        _profileQuery.onChildAdded.listen(onEntryAdded);
    _onProfilChangedSubscription =
        _profileQuery.onChildChanged.listen(onEntryChanged);
  }

  onEntryAdded(Event event) {
    print("something added");
    setState(() {
      user = User.fromSnapshot(event.snapshot);

      _city.text = user.city;
      _gender.text = user.gender;
      _height.text = user.height;
      _eye_color.text = user.eye_color;
      _hair_color.text = user.hair_color;
    });
  }

  onEntryChanged(Event event) {
    print("something updated");
    setState(() {
      user = User.fromSnapshot(event.snapshot);
    });
  }

//  @override
//  Widget build(BuildContext context) {
//    return Row(
//      children: [
//        RaisedButton(
//          onPressed: () {
//
//            _database.reference().child("users").child(widget.userId).set({
//              "userId": widget.userId,
//              "firstname": "11111111111111",
//              "lastname": "momoli009",
//            });
//
//
//            print("user je suis la " + widget.userId);
//          },
//          child: Text('Add', style: TextStyle(fontSize: 20)),
//        ),
//        RaisedButton(
//          onPressed: () {
//            _database.reference().child("users").child(widget.userId).set({
//              "userId": widget.userId,
//              "firstname": "22222222",
//              "lastname": "33333333",
//            });
//
//            print("user je suis la " + widget.userId);
//          },
//          child: Text('Update', style: TextStyle(fontSize: 20)),
//        ),
//        RaisedButton(
//          onPressed: () {
//            print("user je suis la ");
//            print(user.lastname);
//            print("user je suis la ");
////            print(_database.reference().child("users").child(widget.userId).len);
//          },
//          child: Text('Show', style: TextStyle(fontSize: 20)),
//        ),
//      ],
//    );
//  }

  _openGallery(BuildContext context) async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((_pic) {
      List<int> imageBytes = _pic.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);

      _database.reference().child("users").child(widget.userId).update({
        "photo": base64Image,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      color: Colors.white,
      child: _getProfileScolet(),
    ));
  }


  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  Widget _getProfileScolet() {
    if (user != null) {
      return new ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              new Container(
                height: 250.0,
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Stack(fit: StackFit.loose, children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Container(
                              width: 140.0,
                              height: 140.0,
                              decoration: (
                                  user.photo == ""
                                      ? new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: new ExactAssetImage(
                                            'assets/no-image.png'),
                                      ))
                                      : new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: new Image.memory(
                                            base64.decode(user.photo))
                                            .image,
                                      ))
                              ),
                            )
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: () {
                                    _openGallery(context);
                                  },
                                  child: new CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 25.0,
                                    child: new Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ]),
                    )
                  ],
                ),
              ),
              new Container(
                color: Color(0xffFFFFFF),
                padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      _showCircularProgress(),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Renseignements personnels',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _status ? _getEditIcon() : new Container(),
                                ],
                              )
                            ],
                          )),
                      //                          Padding(
                      //                            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                      //                            child: new DropdownButton(
                      //                              icon: new Icon(
                      //                                Icons.location_city,
                      //                                color: Colors.grey,
                      //                              ),
                      //                              hint: Text('Please choose a location'), // Not necessary for Option 1
                      //                              onChanged: (newValue) {
                      //                                setState(() {
                      ////                                  _selectedLocation = newValue;
                      //                                });
                      //                              },
                      //                              items: ['A', 'B', 'C', 'D'].map((location) {
                      //                                return DropdownMenuItem(
                      //                                  child: new Text(location),
                      //                                  value: location,
                      //                                );
                      //                              }).toList(),
                      //                            ),
                      //                          ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: new TextFormField(
                          controller: _city,
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          decoration: new InputDecoration(
                              hintText: 'city',
                              icon: new Icon(
                                Icons.location_city,
                                color: Colors.grey,
                              )
                          ),
                          validator: (value) =>
                          value.isEmpty
                              ? 'Can\'t be empty'
                              : null,
                          enabled: !_status,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: new TextFormField(
                          controller: _gender,
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          decoration: new InputDecoration(
                              hintText: 'gender',
                              icon: new Icon(
                                Icons.help_outline,
                                color: Colors.grey,
                              )
                          ),
                          validator: (value) =>
                          value.isEmpty
                              ? 'Can\'t be empty'
                              : null,
                          enabled: !_status,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: new TextFormField(
                          controller: _height,
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          decoration: new InputDecoration(
                              hintText: 'height',
                              icon: new Icon(
                                Icons.present_to_all,
                                color: Colors.grey,
                              )
                          ),
                          validator: (value) =>
                          value.isEmpty
                              ? 'Can\'t be empty'
                              : null,
                          enabled: !_status,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: new TextFormField(
                          controller: _eye_color,
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          decoration: new InputDecoration(
                              hintText: 'eye_color',
                              icon: new Icon(
                                Icons.remove_red_eye,
                                color: Colors.grey,
                              )
                          ),
                          validator: (value) =>
                          value.isEmpty
                              ? 'Can\'t be empty'
                              : null,
                          enabled: !_status,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                        child: new TextFormField(
                          controller: _hair_color,
                          maxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          decoration: new InputDecoration(
                              hintText: 'hair_color',
                              icon: new Icon(
                                Icons.content_cut,
                                color: Colors.grey,
                              )
                          ),
                          validator: (value) =>
                          value.isEmpty
                              ? 'Can\'t be empty'
                              : null,
                          enabled: !_status,
                        ),
                      ),
                      //                          Padding(
                      //                              padding: EdgeInsets.only(
                      //                                  left: 25.0, right: 25.0, top: 25.0),
                      //                              child: new Row(
                      //                                mainAxisSize: MainAxisSize.max,
                      //                                children: <Widget>[
                      //                                  new Column(
                      //                                    mainAxisAlignment: MainAxisAlignment.start,
                      //                                    mainAxisSize: MainAxisSize.min,
                      //                                    children: <Widget>[
                      //                                      new Text(
                      //                                        'Name',
                      //                                        style: TextStyle(
                      //                                            fontSize: 16.0,
                      //                                            fontWeight: FontWeight.bold),
                      //                                      ),
                      //                                    ],
                      //                                  ),
                      //                                ],
                      //                              )),
                      //                          Padding(
                      //                              padding: EdgeInsets.only(
                      //                                  left: 25.0, right: 25.0, top: 2.0),
                      //                              child: new Row(
                      //                                mainAxisSize: MainAxisSize.max,
                      //                                children: <Widget>[
                      //                                  new Flexible(
                      //                                    child: new TextField(
                      //                                      decoration: const InputDecoration(
                      //                                        hintText: "Enter Your Name",
                      //                                      ),
                      //                                      enabled: !_status,
                      //                                      autofocus: !_status,
                      //
                      //                                    ),
                      //                                  ),
                      //                                ],
                      //                              )),
                      //                          Padding(
                      //                              padding: EdgeInsets.only(
                      //                                  left: 25.0, right: 25.0, top: 25.0),
                      //                              child: new Row(
                      //                                mainAxisSize: MainAxisSize.max,
                      //                                children: <Widget>[
                      //                                  new Column(
                      //                                    mainAxisAlignment: MainAxisAlignment.start,
                      //                                    mainAxisSize: MainAxisSize.min,
                      //                                    children: <Widget>[
                      //                                      new Text(
                      //                                        'Email ID',
                      //                                        style: TextStyle(
                      //                                            fontSize: 16.0,
                      //                                            fontWeight: FontWeight.bold),
                      //                                      ),
                      //                                    ],
                      //                                  ),
                      //                                ],
                      //                              )),
                      //                          Padding(
                      //                              padding: EdgeInsets.only(
                      //                                  left: 25.0, right: 25.0, top: 2.0),
                      //                              child: new Row(
                      //                                mainAxisSize: MainAxisSize.max,
                      //                                children: <Widget>[
                      //                                  new Flexible(
                      //                                    child: new TextField(
                      //                                      decoration: const InputDecoration(
                      //                                          hintText: "Enter Email ID"),
                      //                                      enabled: !_status,
                      //                                    ),
                      //                                  ),
                      //                                ],
                      //                              )),
                      //                          Padding(
                      //                              padding: EdgeInsets.only(
                      //                                  left: 25.0, right: 25.0, top: 25.0),
                      //                              child: new Row(
                      //                                mainAxisSize: MainAxisSize.max,
                      //                                children: <Widget>[
                      //                                  new Column(
                      //                                    mainAxisAlignment: MainAxisAlignment.start,
                      //                                    mainAxisSize: MainAxisSize.min,
                      //                                    children: <Widget>[
                      //                                      new Text(
                      //                                        'Mobile',
                      //                                        style: TextStyle(
                      //                                            fontSize: 16.0,
                      //                                            fontWeight: FontWeight.bold),
                      //                                      ),
                      //                                    ],
                      //                                  ),
                      //                                ],
                      //                              )),
                      //                          Padding(
                      //                              padding: EdgeInsets.only(
                      //                                  left: 25.0, right: 25.0, top: 2.0),
                      //                              child: new Row(
                      //                                mainAxisSize: MainAxisSize.max,
                      //                                children: <Widget>[
                      //                                  new Flexible(
                      //                                    child: new TextField(
                      //                                      decoration: const InputDecoration(
                      //                                          hintText: "Enter Mobile Number"),
                      //                                      enabled: !_status,
                      //                                    ),
                      //                                  ),
                      //                                ],
                      //                              )),
                      //                          Padding(
                      //                              padding: EdgeInsets.only(
                      //                                  left: 25.0, right: 25.0, top: 25.0),
                      //                              child: new Row(
                      //                                mainAxisSize: MainAxisSize.max,
                      //                                mainAxisAlignment: MainAxisAlignment.start,
                      //                                children: <Widget>[
                      //                                  Expanded(
                      //                                    child: Container(
                      //                                      child: new Text(
                      //                                        'Pin Code',
                      //                                        style: TextStyle(
                      //                                            fontSize: 16.0,
                      //                                            fontWeight: FontWeight.bold),
                      //                                      ),
                      //                                    ),
                      //                                    flex: 2,
                      //                                  ),
                      //                                  Expanded(
                      //                                    child: Container(
                      //                                      child: new Text(
                      //                                        'State',
                      //                                        style: TextStyle(
                      //                                            fontSize: 16.0,
                      //                                            fontWeight: FontWeight.bold),
                      //                                      ),
                      //                                    ),
                      //                                    flex: 2,
                      //                                  ),
                      //                                ],
                      //                              )),
                      //                          Padding(
                      //                              padding: EdgeInsets.only(
                      //                                  left: 25.0, right: 25.0, top: 2.0),
                      //                              child: new Row(
                      //                                mainAxisSize: MainAxisSize.max,
                      //                                mainAxisAlignment: MainAxisAlignment.start,
                      //                                children: <Widget>[
                      //                                  Flexible(
                      //                                    child: Padding(
                      //                                      padding: EdgeInsets.only(right: 10.0),
                      //                                      child: new TextField(
                      //                                        decoration: const InputDecoration(
                      //                                            hintText: "Enter Pin Code"),
                      //                                        enabled: !_status,
                      //                                      ),
                      //                                    ),
                      //                                    flex: 2,
                      //                                  ),
                      //                                  Flexible(
                      //                                    child: new TextField(
                      //                                      decoration: const InputDecoration(
                      //                                          hintText: "Enter State"),
                      //                                      enabled: !_status,
                      //                                    ),
                      //                                    flex: 2,
                      //                                  ),
                      //                                ],
                      //                              )),
                      !_status ? _getActionButtons() : new Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      );
    }
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                      });
                      _database.reference().child("users")
                          .child(widget.userId)
                          .update({
                        "city": _city.text,
                        "gender": _gender.text,
                        "height": _height.text,
                        "eye_color": _eye_color.text,
                        "hair_color": _hair_color.text,
                        "userId": widget.userId
                      })
                          .then((_) {
                        setState(() {
                          _isLoading = false;
                        });
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }
}
