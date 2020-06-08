import 'dart:convert';

import 'package:my_database/classes/Elements.dart';
import 'package:my_database/database/Actions.dart';

class MyColleactions {
  String name;
  List<MyElement> myElements = List<MyElement>();
  MyColleactions(this.name);
  static List<MyColleactions> listOfMe = List<MyColleactions>();

  ///This will create the element
  Future getMyElements() async {
    var data = await MyActions.getElementForThisColleaction(this.name);
    myElements = MyElement.buildMeFromListData(data);
  }

  ////This will handle inserting the data into the server
  Future addingNewElementAndRefresh(String userInput) async { 
    if (await MyActions.insertInto(name, json.decode(userInput) as Map))
      await getMyElements();
  }

  ///This will handle  Loading the Collactions
  static Future creatMeFromTheDataBase() async {
    List data = await MyActions.getAllColactions();
    data.forEach((element) {
      listOfMe.add(MyColleactions(element["name"]));
    });
  }

  ///This will get all elements for the colleaction
  static Future loadAllElementsForAllColleactions() async {
    List<Future> myLoaders = List<Future>();
    listOfMe.forEach((element) {
      myLoaders.add(element.getMyElements());
    });
    await Future.wait(myLoaders);
  }
}
