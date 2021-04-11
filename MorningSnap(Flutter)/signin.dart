import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import './constant.dart' as Constant;

class SignIn extends StatefulWidget {
  SignIn({Key key, this.title
  , @required this.notifyparent
  , @required this.theUser
  , @required this.userInfo
  , @required this.updateDayBoard
  , @required this.updateMonthposts
  , @required this.timeoffset}) : super(key: key);

  final String title;
  final Function() notifyparent;
  final Function(int newtotal, int newconsec, int newhighest, String newday) updateDayBoard;
  final Function(dynamic newpost) updateMonthposts;
  final String theUser;
  final dynamic userInfo;
  final int timeoffset;

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  bool _signning = false;
  String post_msg = "";
  
  send(String msg) async{
    var post_url = Constant.DOMAIN;
    var post_signin = "/api/post/signin";
    DateTime today = new DateTime.now().toUtc().subtract(Duration(hours: widget.timeoffset));
    // now = new DateTime(2021, 3, 9).toIso8601String();
    if(isOverTime(today)){
      //refresh the page if over the time constraint
      widget.notifyparent();
      Navigator.of(context).pop();
      return;
    }
    var now = today.toIso8601String();
    var response;
    try{
      response = await http.post(Uri.https(post_url, post_signin),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
          "user": widget.theUser,
          "msg": msg,
          "date": now
        })
      );//http post
    }
    catch(e){
      print("Error Sending Post Request " + e.toString());
    }
      // this.setState(() => _signning = false);
      Navigator.of(context).pop();
      if(response.statusCode == 200){
        // widget.notifyparent();
        //now update user
        updateUserInfo(today);
        var newpost = {"date": now, "msg": msg,  "user": widget.theUser };
        widget.updateMonthposts(newpost);
        // print("post sucessfully sent");
        
      }
      else{
        throw Exception('Fail to send post');
      }
  }

  updateUserInfo(DateTime today) async {
    var newtotal = widget.userInfo['totalSignin'] + 1;
    var newconsec = 1;
    var newhighest = widget.userInfo['highest'];
    DateTime prevdate = DateTime.parse(widget.userInfo['prevSignin']);
    // DateTime today = DateTime.now();
    String isotoday = today.toIso8601String();
    // today = new DateTime(2021, 3, 9);
    
    var date1 = DateTime(today.year, today.month, today.day);
    var date2 = DateTime(prevdate.year, prevdate.month, prevdate.day);
    
    // check if it's a date before
    if(date1.difference(date2).inDays == 1){
      newconsec = widget.userInfo['consecutive'] + 1;
    }

    if(newconsec > newhighest){
       newhighest = newconsec;
    }

    var post_url = Constant.DOMAIN;
    var post_signin = "/api/user/update";
    var response;
    try{
      response = await http.post(Uri.https(post_url, post_signin),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: json.encode({
          "user": widget.theUser,
          "consecutive": newconsec,
          "totalSignin": newtotal,
          "highest": newhighest,
          "prevSignin": isotoday
        })
      );//http post
    }
    catch(e){
      print("Error Sending Post Request " + e.toString());
    }

    widget.updateDayBoard(newtotal, newconsec, newhighest, isotoday);
  }

  bool isOverTime(DateTime now){
    int current_hour = now.hour;
    if(current_hour <= 6 || current_hour >= 9){
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {

    Widget _signin_widget(){
        return Container(
          child: AlertDialog(
          title: Text('签到'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('你想说什么？'),
                TextField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(100)
                  ],
                  onChanged: (String str){
                     this.setState(() => post_msg = str);
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('确定'),
              onPressed: () {
                this.setState(() => _signning = true);
                // DateTime today = new DateTime.now().toUtc().subtract(Duration(hours: widget.timeoffset));
                // today = new DateTime(2021, 3, 11);
                // print(today.toIso8601String());
                send(post_msg);
                // updateUserInfo(today);
              },
            ),
          ],
        ),
      );
    }
    
    return ModalProgressHUD(inAsyncCall: _signning, child: _signin_widget());
  }
}