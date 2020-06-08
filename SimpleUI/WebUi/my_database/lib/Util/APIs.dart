class MyAPIs {
  static const MyHostConnection = "http://192.168.56.102:2500";
  static const GetAllCollections = MyHostConnection + "/Api/GetAllCollections";
  static const GetElementsForThisCollaction =
      MyHostConnection + "/Api/GetMyElement";
  static const CreateCollaction = MyHostConnection + "/Api/CreateCollection";
  static const InsertIntoCollaction =MyHostConnection + "/Api/InsertInto";
}
