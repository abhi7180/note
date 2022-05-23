import 'package:flutter/material.dart';
import 'package:note/add_notes.dart';
import 'package:note/data_base.dart';
import 'package:note/my_data.dart';
import 'package:sqflite/sqflite.dart';

class view_notes extends StatefulWidget {
  const view_notes({Key? key}) : super(key: key);

  @override
  State<view_notes> createState() => _view_notesState();
}

class _view_notesState extends State<view_notes> {
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
                    icon: Icon(
                      Icons.cancel,
                      color: Theme.of(context).cardColor,
                    ))
              ],
            )
          : AppBar(
              title: Text(
                "NOTE",
                style: TextStyle(color: Theme.of(context).cardColor),
              ),
              backgroundColor: Theme.of(context).backgroundColor,
              actions: [
                IconButton(
                    onPressed: () {
                      setState(() {
                        search = !search;
                      });
                    },
                    icon: Icon(
                      Icons.search,
                      color: Theme.of(context).cardColor,
                    ))
              ],
            ),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: ListView.builder(
          itemCount: templist.length,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(top: 10, left: 10, right: 10),
              decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.circular(20)),
              child: ListTile(
                title: Text(
                  "${templist[index].title}",
                  style: TextStyle(color: Theme.of(context).cardColor),
                ),
                subtitle: Text(
                  "${templist[index].subtitle}",
                  style: TextStyle(color: Theme.of(context).dividerColor),
                ),
                onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) {
                      return add_notes("update", list[index].id,
                          list[index].title, list[index].subtitle);
                    },
                  ));
                },
              ),
            );
          },
        ),
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
