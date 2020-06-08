import 'package:flutter/material.dart';
import 'package:my_database/Widgets/HomePageStateWidgets.dart';
import 'package:my_database/classes/Collactions.dart';
import 'package:my_database/classes/Elements.dart';

import 'MyMapBuilder.dart';

///This Builder is only for [MyElement] or somethin like
///it,
class MyElementsBuilderInBox extends StatefulWidget {
  final MyColleactions myCol;
  MyElementsBuilderInBox(this.myCol);
  @override
  _MyElementsBuilderInBoxState createState() => _MyElementsBuilderInBoxState();
}

class _MyElementsBuilderInBoxState extends State<MyElementsBuilderInBox> {
  double heightOfElement = 30;

  @override
  Widget build(BuildContext context) {
    double myheight = heightOfElement * widget.myCol.myElements.length <
            MediaQuery.of(context).size.height * 0.5
        ? heightOfElement * widget.myCol.myElements.length
        : MediaQuery.of(context).size.height * 0.5;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5,
        color: Colors.white10,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: myheight + 100,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 30,
                    child: Center(
                      child: Text(
                        widget.myCol.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0),
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: myheight + 50,
                    child: ListView.builder(
                        itemCount: widget.myCol.myElements.length,
                        itemBuilder: (context, index) {
                          String myKey = widget
                              .myCol.myElements[index].data.keys
                              .toList()[0]
                              .toString();
                          dynamic myValue = widget.myCol.myElements[index].data[
                              widget.myCol.myElements[index].data.keys
                                  .toList()[0]
                                  .toString()];
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              height: heightOfElement,
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: MyValueBuilder(myValue, myKey,
                                  (myKey, myValue) {
                                HomePageStateWidgets.myState.setState(() {
                                  HomePageStateWidgets.myState.myMapsData
                                      .clear();
                                  HomePageStateWidgets.myState.myMapsData
                                      .add(MyMapBuilder(myValue, myKey));
                                });
                              }),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///This will return a Text with the right value
///as if its a map or List or whatever
///it requer the key for this value too
///with its decorations
class MyValueBuilder extends StatelessWidget {
  final dynamic value;
  final String myKey;

  ///This Function will be called only if its Map or a List
  final Function(
    String theKey,
    Map theValue,
  ) onPressed;
  String whatToShow;
  bool callFunction = false;
  Map outPut;
  TextStyle myStyle = TextStyle(color: Colors.black38);
  MyValueBuilder(this.value, this.myKey, this.onPressed, {this.myStyle});

  @override
  Widget build(BuildContext context) {
    if (value != null && myKey != null) {
      if (value is List) {
        callFunction = true;
        outPut = value.asMap();
        whatToShow = value.length.toString() + " Element";
      } else if (value is Map) {
        callFunction = true;
        outPut = value;
        whatToShow = value.keys.toList().length.toString() + " Element";
      } else
        whatToShow = value.toString();
      return FlatButton(
        disabledColor: Colors.white,
        onPressed: callFunction
            ? () {
                onPressed(this.myKey, this.outPut);
              }
            : null,
        child: Text(
          "$myKey: $whatToShow",
          style: myStyle,
        ),
        color: Colors.white,
        shape: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      );
    }
    return Container();
  }
}
