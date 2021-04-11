import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:intl/intl.dart' show DateFormat;
import './signin.dart';
import './postwindow.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:http/http.dart' as http;
import './constant.dart' as Constant;

class Calendar extends StatefulWidget {
  Calendar({Key key, this.title, @required this.theUser}) : super(key: key);

  final String title;
  final String theUser;

  @override
  _MyCalendarState createState() => _MyCalendarState();
}

class _MyCalendarState extends State<Calendar> {

  bool _enableSignIn = false;
  bool loading = true;
  List<dynamic> monthposts;
  var _user_info;
  int _consecutive = 0;
  int _totalSignin = 0;
  int _highest = 0;
  DateTime _currentDate = new DateTime.now();
  int _timeoffset = 0;
  DateTime _currentDate2 = new DateTime.now();
  String _currentMonth = DateFormat.yMMM().format(new DateTime.now());
  DateTime _targetDateTime = new DateTime.now();
  EventList<Event> _markedDateMap = new EventList<Event>();
  CalendarCarousel _calendarCarouselNoHeader;


  static Widget _nkeventIcon =  
     new Container(
       child: Text("已签"),
       alignment: Alignment.topCenter,
      );

  void buildEventList(List<dynamic> monthposts){
    EventList<Event> newmarkedDateMap = new EventList<Event>();
    for(int i = 0; i < monthposts.length; i++){
      // print("$i with post ${monthposts[i]}");
      // print(monthposts[i]['msg']);
      if(monthposts[i]['user'] == widget.theUser){
        DateTime date = DateTime.parse(monthposts[i]['date']);
        newmarkedDateMap.add(new DateTime(date.year, date.month, date.day), new Event(
          date: new DateTime(date.year, date.month, date.day),
          title: 'Event 5',
          icon: _nkeventIcon
        ));
      }
    }
    this.setState(() => this._markedDateMap = newmarkedDateMap);
  }

  @override
  void initState() {
      // TODO: implement initState
      super.initState();
      _timeoffset = IsDST(_currentDate.day, _currentDate.month, _currentDate.weekday%7)?Constant.SAVING_OFFSET:Constant.STANDARD_OFFSET;
      getMonthPosts(_currentDate.month, _currentDate.year);
      getTheUser(widget.theUser);
    }

  void getTheUser(String user) async {
    var user_domain = Constant.DOMAIN;
    var user_url = "/api/user/" + widget.theUser;
    var response;
    try{
      response = await http.get(Uri.https(user_domain, user_url),
      headers: {

      });
    }catch(e){
      print("Error Sending Get Request " + e.toString());
    }
    var decode_user = jsonDecode(response.body)['user'];
    DateTime rep_day = DateTime.parse(decode_user['prevSignin']);
    DateTime today = new DateTime.now().toUtc().subtract(Duration(hours: _timeoffset));
    DateTime date1 = DateTime(rep_day.year, rep_day.month, rep_day.day);
    DateTime date2 = DateTime(today.year, today.month, today.day);
  print(date1);
  print(date2);
  print(date2.difference(date1).inDays);
    if(date2.difference(date1).inDays != 0 && !isOverTime(today)){
      this._enableSignIn = true;
    }
    this.setState(() {
          _user_info = decode_user;
          _consecutive = decode_user['consecutive']!=null?decode_user['consecutive']:0;
          _totalSignin = decode_user['totalSignin']!=null?decode_user['totalSignin']:0;
          _highest = decode_user['highest']!=null?decode_user['highest']:0;
          _enableSignIn = this._enableSignIn;
        });
  }
  
  void getMonthPosts(int month, int year) async {
    var post_url = Constant.DOMAIN;
    var post_signin = "/api/post/posts";
    var response;
    try{
      response = await http.post(Uri.https(post_url, post_signin),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        // 'Access-Control-Allow-Origin': '*', // Required for CORS support to work
        // "Access-Control-Allow-Credentials": "true", // Required for cookies, authorization headers with HTTPS
        // "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
        // "Access-Control-Allow-Methods": "POST, OPTIONS"
        'nulideren': widget.theUser,
        'kai-nian-fighting-super-token': Constant.SECRETS
      },
      body: json.encode({
            "month": month,
            "year": year
        })
      );//http post

      if(response.statusCode != 200){
        throw Exception('Fail to load post');
      }
    }
    catch(e){
      print("Error Sending Post Request " + e.toString());
      return;
    }
    List<dynamic> newmonthposts = jsonDecode(response.body)['posts'];
    this.monthposts = newmonthposts;
    // print(this.monthposts);
    buildEventList(newmonthposts);
    // this.setState(() => this.monthposts = newmonthposts);
    this.setState(()=>this.loading=false);
  }

  void updateMonthposts(var newposts){
    this.monthposts.add(newposts);
    this.setState(()=>this._enableSignIn=false);
    buildEventList(this.monthposts);
  }

  void updateDayBoard(int newtotal, int newconsec, int newhighest, String newday){
    this.setState(() {
          this._totalSignin = newtotal;
          this._consecutive = newconsec;
          this._highest = newhighest;
          this._user_info['prevSignin'] = newday;
        });
  }

  void signInWindow(){
    showDialog(context: context, builder: (context){return SignIn(notifyparent: refresh
        , theUser: widget.theUser
        , userInfo: this._user_info
        , updateDayBoard: updateDayBoard
        , updateMonthposts: updateMonthposts
        , timeoffset: this._timeoffset,);
      }
    );
  }

  void postsWindow(DateTime date){
    showDialog(context: context, builder: (context){return PostWindow(posts: this.monthposts, date: date,);});
  }

  void refresh(){
    this.setState(()=>this.loading=true);
    getMonthPosts(_currentDate.month, _currentDate.year);
    getTheUser(widget.theUser);
  }

  void setNext(){
    this.setState(() {
      _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month +1);
      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
    });
    getMonthPosts(_targetDateTime.month, _targetDateTime.year);
  }

  void setPrev(){
    setState(() {
      _targetDateTime = DateTime(_targetDateTime.year, _targetDateTime.month -1);
      _currentMonth = DateFormat.yMMM().format(_targetDateTime);
    });
    getMonthPosts(_targetDateTime.month, _targetDateTime.year);
  }


  bool isOverTime(DateTime now){
    int current_hour = now.hour;
    if(current_hour <= 6 || current_hour >= 9){
      return true;
    }
    return false;
  }


bool IsDST(day, month, dow)
{
    //January, february, and december are out.
    if (month < 3 || month > 11) { return false; }
    //April to October are in
    if (month > 3 && month < 11) { return true; }
    int previousSunday = day - dow;
    //In march, we are DST if our previous sunday was on or after the 8th.
    if (month == 3) { return previousSunday >= 8; }
    //In november we must be before the first sunday to be dst.
    //That means the previous sunday must be before the 1st.
    return previousSunday <= 0;
}

  @override
  Widget build(BuildContext context) {

    _calendarCarouselNoHeader = CalendarCarousel<Event>(
      todayBorderColor: Colors.green,
      onDayPressed: (DateTime date, List<Event> events) {
        // print("date pressed");
        this.setState(() => _currentDate2 = date);
        // events.forEach((event) => print(event.title));
      },
      daysHaveCircularBorder: true,
      showOnlyCurrentMonthDate: false,
      weekendTextStyle: TextStyle(
        color: Colors.red,
      ),
      thisMonthDayBorderColor: Colors.grey,
      weekFormat: false,
      markedDatesMap: _markedDateMap,
      height: 420.0,
      selectedDateTime: _currentDate2,
      targetDateTime: _targetDateTime,
      customGridViewPhysics: NeverScrollableScrollPhysics(),
      markedDateCustomShapeBorder: CircleBorder(
        side: BorderSide(color: Colors.yellow)
      ),
      markedDateCustomTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.blue,
      ),
      showHeader: false,
      todayTextStyle: TextStyle(
        color: Colors.blue,
      ),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 1,
      markedDateIconBuilder: (event) {
        return event.icon;
      },
      markedDateMoreShowTotal:
          true,
      todayButtonColor: Colors.yellow,
      selectedDayTextStyle: TextStyle(
        color: Colors.yellow,
      ),
      minSelectedDate: _currentDate.subtract(Duration(days: 360)),
      maxSelectedDate: _currentDate.add(Duration(days: 360)),
      prevDaysTextStyle: TextStyle(
        fontSize: 16,
        color: Colors.pinkAccent,
      ),
      inactiveDaysTextStyle: TextStyle(
        color: Colors.tealAccent,
        fontSize: 16,
      ),
      onCalendarChanged: (DateTime date) {
        this.setState(() {
          _targetDateTime = date;
          _currentMonth = DateFormat.yMMM().format(_targetDateTime);
        });
      },
      onDayLongPressed: (DateTime date) {
        // print('long pressed date $date');
        postsWindow(date);
      },
    );

    return ModalProgressHUD( inAsyncCall: loading ,child: new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: 
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //custom icon without header
                Container(
                  child: IconButton(icon: Image.asset('assets/refresh.png'),onPressed: refresh,),
                ),
                Center(
                  child: 
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: 100,
                            margin: EdgeInsets.only(bottom: 10.0),
                            child: this._enableSignIn?ElevatedButton(onPressed: signInWindow, child: Text("签到"))
                                                      :ElevatedButton(onPressed: null, child: Text("签到")),
                          ),
                          Text("只能在6：00 ~ 9：00之间签到")
                        ],
                      ),
                    ) 
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: 30.0,
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: new Row(
                    children: <Widget>[
                      Expanded(
                          child: Text(
                        _currentMonth,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0,
                        ),
                      )),
                      FlatButton(
                        child: Text('PREV'),
                        onPressed: setPrev,
                      ),
                      FlatButton(
                        child: Text('NEXT'),
                        onPressed: setNext,
                      )
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  child: _calendarCarouselNoHeader,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Text("连续天数：$_consecutive"),
                      Text("总天数：  $_totalSignin"),
                      Text("最高连续天数： $_highest"),
                    ],
                  ),
                ) //
              ],
            ),
          )
        )
    );
  }
}