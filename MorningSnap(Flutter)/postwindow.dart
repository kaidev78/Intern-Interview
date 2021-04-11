import 'package:flutter/material.dart';

class PostWindow extends StatefulWidget {
  PostWindow({Key key, this.title, @required this.posts, @required this.date}) : super(key: key);

  final String title;
  final List<dynamic> posts;
  final DateTime date;

  @override
  _PostWindowState createState() => _PostWindowState();
}


class _PostWindowState extends State<PostWindow> {

  String NPost = null;
  String KPost = null;
  DateTime NPostTime = null;
  DateTime KPostTime = null;

  @override
    void initState() {
      // TODO: implement initState
      super.initState();
      findpost();
    }

  void findpost(){
    for(int i = 0; i < widget.posts.length; i++){
      DateTime post_date = DateTime.parse(widget.posts[i]['date']);
      if(post_date.year == widget.date.year && post_date.month == widget.date.month &&
        post_date.day == widget.date.day){
          if(widget.posts[i]['user'] == 'nianyi'){
            NPost = widget.posts[i]['msg'];
            NPostTime = DateTime.parse(widget.posts[i]['date']);
          }else{
            KPost = widget.posts[i]['msg'];
            KPostTime = DateTime.parse(widget.posts[i]['date']);
          }
        }

        if(NPost != null && KPost != null)break;
    }
  }


  @override
  Widget build(BuildContext context){
    return Container(
          child: AlertDialog(
          title: Text('签到墙(${widget.date.month}-${widget.date.day}-${widget.date.year})'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child:(this.KPostTime!=null)?Text("凯文(${KPostTime.hour}:${KPostTime.minute}:${KPostTime.second}):"):Text("凯文(TOO LAZY)：")
                        ),
                      Container(
                        alignment: Alignment.topLeft,
                        child: (this.KPost!=null)?Text(KPost, style: TextStyle(fontFamily: ""),):Text("还没有签到", style: TextStyle(color: Colors.red),),
                      )
                    ],
                  )
                ),
                Divider(color: Colors.black,),
                Container(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: (this.NPostTime!=null)?Text("年毅(${NPostTime.hour}:${NPostTime.minute}:${NPostTime.second}):"):Text("年毅(TOO LAZY)："),
                      ), 
                      Container(
                        alignment: Alignment.topLeft,
                        child: (this.NPost!=null)?Text(NPost, style: TextStyle(fontFamily: ""),):Text("还没有签到", style: TextStyle(color: Colors.red),),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('返回'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
  }
}