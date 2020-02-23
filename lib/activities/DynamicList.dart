import 'package:flutter/material.dart';

class ListDisplay extends StatefulWidget {
  List<Object> list;

//  Class itemWidget;

  ListDisplay(this.list);

  @override
  State createState() => new DyanmicList(list);
}

class DyanmicList extends State<ListDisplay> {
  List<Object> list;

//  Object itemWidget;

  DyanmicList(this.list);

  @override
  Widget build(BuildContext ctxt) {
    return Scaffold(
        appBar: AppBar(),
        body: CustomScrollView(
          slivers: <Widget>[
//            WorkSpaces("WorkSpaces"),
            SliverFixedExtentList(
                itemExtent: 50.0,
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      alignment: Alignment.center,
                      color: Colors.lightBlue[100 * (index % 9)],
                      child: Text('list item $index'),
                    );
                  },
                )),
          ],
        ));
//    return new Column(
//      children: [
//        new Expanded(
//            child: new ListView.builder(
//                itemCount: list.length,
//                itemBuilder: (BuildContext ctxt, int Index) {
//                  return (list[Index]);
//                }))
//      ],
//    );
  }
}
