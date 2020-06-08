import 'package:flutter/material.dart';
import 'package:my_database/Widgets/HomePageStateWidgets.dart';
import 'package:my_database/classes/Collactions.dart';

///This is my home page to manage the database
///and it will show all data
///for now there is only this page
///
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static bool isLoading = true;
  @override
  void initState() {
    super.initState();
    MyColleactions.creatMeFromTheDataBase().then((value) {
      MyColleactions.loadAllElementsForAllColleactions().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget col = HomePageStateWidgets();
    return Material(
        type: MaterialType.transparency,
        color: Colors.white,
        child: isLoading
            ? Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: Row(
                    children: [
                      Expanded(
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Loading..."),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : col);
  }
}
