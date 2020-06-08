import 'package:flutter/material.dart';
import 'package:my_database/Widgets/MyElementsBuilder.dart';

import 'HomePageStateWidgets.dart';

class MyMapBuilder extends StatefulWidget {
  final String myTitle;
  final Map myInput;
  MyMapBuilder(this.myInput, this.myTitle);
  @override
  _MyMapBuilderState createState() => _MyMapBuilderState();
}

class _MyMapBuilderState extends State<MyMapBuilder> {
  List allTheKeys = List();
  double heightOfElement = 30;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    allTheKeys = widget.myInput.keys.toList();

    double myheight = heightOfElement * allTheKeys.length <
            MediaQuery.of(context).size.height * 0.3
        ? heightOfElement * allTheKeys.length
        : MediaQuery.of(context).size.height * 0.3;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 5,
        color: Colors.white10,
        borderRadius: BorderRadius.circular(4),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          height: myheight + 80,
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 30,
                    child: Center(
                      child: Text(
                        widget.myTitle,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20.0),
                      ),
                    ),
                    color: Colors.yellow[800],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: myheight + 50,
                    child: ListView.builder(
                        itemCount: allTheKeys.length,
                        itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                  height: heightOfElement,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: MyValueBuilder(
                                      widget.myInput[allTheKeys[index]],
                                      allTheKeys[index], (key, value) {
                                    HomePageStateWidgets.myState.setState(() {
                                      HomePageStateWidgets.myState.myMapsData
                                          .add(MyMapBuilder(value, key));
                                    });
                                  })),
                            )),
                  ),
                ],
              ),

              ///Adding a Element
              ///TODO add it latter
              // Align(
              //   alignment: Alignment.bottomRight,
              //   child: Padding(
              //     padding: const EdgeInsets.all(2.0),
              //     child: IconButton(
              //         icon: CircleAvatar(
              //           child: Icon(
              //             Icons.add,
              //             color: Colors.white,
              //           ),
              //         ),
              //         onPressed: () {
              //           MyInputDialogs.showMyDialog(
              //               context, "Colleaction title", addingHanlder, () {
              //             setState(() {});
              //           });
              //         }),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
