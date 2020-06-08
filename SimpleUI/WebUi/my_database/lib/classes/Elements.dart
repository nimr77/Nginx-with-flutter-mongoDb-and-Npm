class MyElement {
  Map data = Map();
  String id = "Nothing";
  MyElement();
  MyElement.fromData(this.id, this.data);
  getOtherElementsFromTheElements() {
    return data.entries;
  }

  ///This will Creat the element fro mthe init value that comes from the database
  static List<MyElement> buildMeFromListData(List data) {
    List<MyElement> myData = List<MyElement>();
    data.forEach((element) {
      List keys = element.keys.toList();
      print("The Size OF This element is " + keys.length.toString());

      for (int index = 1; index < keys.length; index++) {
        var anotherKey = keys[index];
        myData.add(MyElement.fromData(
            element["_id"], {anotherKey: element[anotherKey]}));
      }
    });
    return myData;
  }
}
