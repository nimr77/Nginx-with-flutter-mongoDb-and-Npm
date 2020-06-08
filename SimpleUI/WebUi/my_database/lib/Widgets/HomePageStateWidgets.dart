import 'package:flutter/material.dart';
import 'package:my_database/Widgets/ColleactionsBuilderInBox.dart';
import 'package:my_database/Widgets/MyElementsBuilder.dart';
import 'package:my_database/classes/Collactions.dart';

class HomePageStateWidgets extends StatefulWidget {
  static _HomePageStateWidgetsState myState;
  @override
  _HomePageStateWidgetsState createState() => _HomePageStateWidgetsState();
}

class _HomePageStateWidgetsState extends State<HomePageStateWidgets> {
  MyColleactions myColleactions;
  Alignment homeColleactionsAlign = Alignment.center;
  Alignment homeElementsAlign = Alignment.centerRight;
  List<Widget> myMapsData = List<Widget>();

  void onChooseACol(MyColleactions myColleactions) {
    this.myColleactions = myColleactions;
    this.setState(() {
      myMapsData.clear();
    });
  }

  @override
  void setState(fn) {
    super.setState(fn);
    homeColleactionsAlign = Alignment.center;
    if (myMapsData.length != 0) {
      homeColleactionsAlign = Alignment.topLeft;
      homeElementsAlign = Alignment.topRight;
    } else {
      homeColleactionsAlign = Alignment.centerLeft;
      homeElementsAlign = Alignment.centerRight;
    }
  }

  @override
  void initState() {
    HomePageStateWidgets.myState = this;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: homeColleactionsAlign,
          child: MyColleactionBuilderInBox(onChooseACol),
        ),
        myColleactions != null
            ? Align(
                alignment: homeElementsAlign,
                child: MyElementsBuilderInBox(myColleactions),
              )
            : Container(),
        myMapsData.length != 0
            ? Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: ListView.builder(
                    itemBuilder: (context, index) => myMapsData[index],
                    itemCount: myMapsData.length,
                    scrollDirection: Axis.horizontal,
                  ),
                ),
              )
            : Container()
      ],
    );
  }
}
