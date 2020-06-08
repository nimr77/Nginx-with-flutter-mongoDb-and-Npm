import 'package:flutter/material.dart';
import 'package:my_database/Inputs/AddingNewData.dart';
import 'package:my_database/Inputs/MyInputDialogs.dart';
import 'package:my_database/Widgets/HomePageStateWidgets.dart';
import 'package:my_database/classes/Collactions.dart';
import 'package:my_database/database/Actions.dart';

///This Builder is only for [MyColleactions] or somethin like
///it,
class MyColleactionBuilderInBox extends StatefulWidget {
  final Function(MyColleactions myColleactions) onChooseColleaction;
  MyColleactionBuilderInBox(this.onChooseColleaction);
  @override
  _MyColleactionBuilderInBoxState createState() =>
      _MyColleactionBuilderInBoxState();
}

class _MyColleactionBuilderInBoxState extends State<MyColleactionBuilderInBox> {
  double heightOfElement = 30;

  ///This will handler the adding
  Future addingHanlder(String value) async {
    if (await MyActions.addColleaction(value))
      MyColleactions.listOfMe.add(MyColleactions(value));
  }

  @override
  Widget build(BuildContext context) {
    double myheight = heightOfElement * MyColleactions.listOfMe.length <
            MediaQuery.of(context).size.height * 0.5
        ? heightOfElement * MyColleactions.listOfMe.length
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
                        "Colleactions",
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
                        itemCount: MyColleactions.listOfMe.length,
                        itemBuilder: (context, index) => InkWell(
                              onTap: () {
                                widget.onChooseColleaction(
                                    MyColleactions.listOfMe[index]);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  height: heightOfElement,
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                        color: Colors.blue[300], width: 2.5),
                                  )),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: Text(
                                            MyColleactions.listOfMe[index].name,
                                            style: TextStyle(
                                                color: Colors.black45,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Center(
                                            child: IconButton(
                                              onPressed: () {
                                                MyAddingDataDialog.showMyDialog(
                                                    context,
                                                    "as Key Value format",
                                                    (value) => MyColleactions
                                                        .listOfMe[index]
                                                        .addingNewElementAndRefresh(
                                                            value), () {
                                                  HomePageStateWidgets.myState
                                                      .setState(() {});
                                                });
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                color: Colors.blue,
                                              ),
                                            ),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            )),
                  ),
                ],
              ),

              ///Adding a Colleaction
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: IconButton(
                      icon: CircleAvatar(
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        MyInputDialogs.showMyDialog(
                            context, "Colleaction title", addingHanlder, () {
                          setState(() {});
                        });
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
