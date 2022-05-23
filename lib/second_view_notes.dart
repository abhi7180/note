import 'package:flutter/material.dart';
import 'package:note/add_notes.dart';
import 'package:note/data_base.dart';
import 'package:note/my_data.dart';
import 'package:sqflite/sqflite.dart';

class second_view_notes extends StatefulWidget {
  const second_view_notes({Key? key}) : super(key: key);

  @override
  State<second_view_notes> createState() => _second_view_notesState();
}

class _second_view_notesState extends State<second_view_notes> {
  TextEditingController t = TextEditingController();

  bool search = false;

  Database? db;
  List<my_data> list = [];
  List<my_data> templist = [];

  String qry = "";

  getalldata() {
    data_base().createDatabase().then((value) {
      db = value;
      qry = "select * from note";
      setState(() {
        value.rawQuery(qry).then((value) {
          setState(() {
            for (int i = 0; i < value.length; i++) {
              list.add(my_data.fromMap(value[i]));
              templist.add(my_data.fromMap(value[i]));

              print("${list[i]}");
            }
          });
        });
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getalldata();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: search
          ? AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: TextField(
          controller: t,
          onChanged: (value) {
            setState(() {
              templist.clear();
              for (int i = 0; i < list.length; i++) {
                if (list[i]
                    .title!
                    .toLowerCase()
                    .contains(value.toLowerCase())) {
                  templist.add(list[i]);
                }
              }
            });
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              )),
        ),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  search = !search;
                });
              },
              icon: Icon(Icons.cancel,color: Theme.of(context).cardColor,))
        ],
      )
          : AppBar(
        title: Text("NOTE",style: TextStyle(color: Theme.of(context).cardColor),),
        backgroundColor: Theme.of(context).backgroundColor,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  search = !search;
                });
              },
              icon: Icon(Icons.search,color: Theme.of(context).cardColor,))
        ],
      ),
      body: Container(
        height: 180,
        width: 250,
        color: Theme.of(context).primaryColor,
        child: GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemCount: templist.length,
          itemBuilder: (context, index) {
          return InkWell(
            child: Container(
              child: Column(
                children: [
                  Text("${templist[index].title}", style: TextStyle(color: Theme.of(context).cardColor)),
                  Text("${templist[index].subtitle}",style: TextStyle(color: Theme.of(context).dividerColor),),
                ],
              ),
            ),
          );
        },),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(
            builder: (context) {
              return add_notes("insert");
            },
          ));
        },
        child: Icon(Icons.add),
        foregroundColor: Theme.of(context).cardColor,
        backgroundColor: Theme.of(context).backgroundColor,
      ),
    );
  }
}
