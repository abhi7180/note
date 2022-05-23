import 'package:flutter/material.dart';
import 'package:note/data_base.dart';
import 'package:note/view_notes.dart';
import 'package:sqflite/sqflite.dart';

import 'my_data.dart';

class add_notes extends StatefulWidget {
  String? typ;
  int? id;
  String? title, subtitle;

  add_notes([this.typ, this.id, this.title, this.subtitle]);

  @override
  State<add_notes> createState() => _add_notesState();
}

class _add_notesState extends State<add_notes> {
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();

  Database? db;
  bool type = false;
  bool save = false;

  List<my_data> list = [];
  String qry = "";
  String vlu="";

  getalldata() {
    if (widget.typ == "update") {
      t1.text = widget.title!;
      t2.text = widget.subtitle!;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getalldata();
    data_base().createDatabase().then((value) {
      db = value;
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: type || save
              ? AppBar(
                  backgroundColor: Theme.of(context).backgroundColor,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return view_notes();
                          },
                        ));
                      },
                      icon: Icon(Icons.arrow_back_outlined,color: Theme.of(context).cardColor,)),
                  actions: [

                    InkWell(
                      onTap: ()async {
                        String title = t1.text;
                        String subtitle = t2.text;
                        // if(title.isEmpty)
                        //   {
                        //     setState(() {
                        //       save=true;
                        //     });
                        //
                        //   }

                        if (widget.typ == "insert") {
                          String qry =
                              "insert into note (title, subtitle ) values ('$title','$subtitle')";
                          int a = await db!.rawInsert(qry);
                          print(a);
                        } else {
                          print(widget.title);

                          String qry =
                              "update note set title= '$title', subtitle = '$subtitle' where id = '${widget.id}'";
                          int a = await db!.rawUpdate(qry);
                          print("$a");
                        }
                        setState(() {
                          type = false;
                          save=false;
                        });

                      },

                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        child: save ? Icon(Icons.check,color: Theme.of(context).cardColor,) : null,
                      )
                    ),
                    // IconButton(
                    //     onPressed: () async {
                    //
                    //       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    //       //   return view_notes();
                    //       // },));
                    //     },
                    //     icon: save ? Icon(Icons.check) : Icon(Icons.save))
                  ],
                )
              : AppBar(
            backgroundColor: Theme.of(context).backgroundColor,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) {
                            return view_notes();
                          },
                        ));
                      },
                      icon: Icon(Icons.arrow_back_outlined,color: Theme.of(context).cardColor,)),
                  actions: [
                    PopupMenuButton(
                      offset: Offset(0,50),
                      icon: Icon(Icons.menu,color: Theme.of(context).cardColor,),


                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                      ),
                      elevation: 20,
                      color: Theme.of(context).primaryColor,
                      onSelected: (value) async {
                        if (value == 1) {
                          String qry =
                              "delete from note where id = '${widget.id}'";
                          await db!.rawDelete(qry);

                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) {
                              return view_notes();
                            },
                          ));
                        }
                      },
                      itemBuilder: (context) => [

                        PopupMenuItem(


                          textStyle: TextStyle(color: Theme.of(context).backgroundColor),


                          child: Text("Delete",style: TextStyle(color:Theme.of(context).cardColor),),
                          value: 1,
                        )
                      ],
                    )
                  ],
                ),
          body:Container(
            color: Theme.of(context).backgroundColor,
            child:  Column(
              children: [
                TextField(
                  onChanged: (value) {

                    setState(() {
                      vlu=value;
                      print("$vlu");
                    });
                    if(value.isNotEmpty)
                    {
                      setState(() {

                        save=true;
                      });

                    }
                    else
                    {
                      setState(() {
                        save=false;
                      });
                    }
                  },
                  controller: t1,
                  onTap: () {
                    setState(() {
                      type = true;
                      if(vlu.isNotEmpty)
                      {
                        setState(() {
                          save=true;
                        });

                      }
                      if(widget.typ=="update")
                        {
                          setState(() {
                            save=true;
                          });
                        }

                    });
                  },
                  style: TextStyle(fontSize: 30),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 30, top: 20),
                    hintText: "Title",
                    hintStyle: TextStyle(fontSize: 30),
                    border: InputBorder.none,
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    print(value);
                    if(value.isNotEmpty)
                    {
                      setState(() {
                        save=true;
                      });

                    }
                    else
                    {
                      setState(() {
                        save=false;
                      });
                    }
                  },
                  controller: t2,
                  onTap: () {
                    setState(() {
                      type = true;
                      if(vlu.isNotEmpty)
                      {
                        setState(() {
                          save=true;
                        });
                      }
                    });
                  },
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(left: 30, top: 20),
                    hintText: "Subtitle",
                    hintStyle: TextStyle(fontSize: 20),
                    border: InputBorder.none,
                  ),
                ),
              ],
            ),
          ),
        ),
        onWillPop: goBack);
  }

  Future<bool> goBack() {
    // Navigator.pop(context);

    Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context) {
        return view_notes();
      },
    ));
    return Future.value();
  }
}
