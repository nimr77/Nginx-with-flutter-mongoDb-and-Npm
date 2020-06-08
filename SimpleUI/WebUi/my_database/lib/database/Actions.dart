import 'dart:convert';

import 'package:my_database/Util/APIs.dart';
import 'package:http/http.dart' as http;

class MyActions {
  static const MyHeaders = {
    "Accept": "application/json",
    // "Content-Type": "application/x-www-from-urlencoded",
    "Acess-Control-Allow-Origin": '*'
  };

  ///This will get all the colacions from the database
  static Future<List> getAllColactions() async {
    final res = await http.get(MyAPIs.GetAllCollections, headers: MyHeaders);
    Map body = json.decode(res.body);
    if (body['status'])
      return body['Message'];
    else
      return List();
  }

  ///This will get all the colacions from the database
  static Future<List> getElementForThisColleaction(
      String thisColeaction) async {
    final res = await http.post(MyAPIs.GetElementsForThisCollaction,
        headers: MyHeaders, body: {"CollectionName": thisColeaction});
    print(res.body);

    Map body = json.decode(res.body);
    if (body['status'])
      return body['message'];
    else
      return List();
  }

  ////This will add the colleaction to the database
  static Future<bool> addColleaction(String name) async {
    final res = await http.post(MyAPIs.GetElementsForThisCollaction,
        headers: MyHeaders, body: {"CollectionName": name});
    print(res.body);

    Map body = json.decode(res.body);
    return body["status"];
  }

  static Future<bool> insertInto(String name, Map theData) async {
    final res = await http.post(MyAPIs.InsertIntoCollaction,
        headers: MyHeaders, body: {"CollectionName": name, "MyData": json.encode(theData)});
    print(res.body);

    Map body = json.decode(res.body);
    return body["status"];
  }
}
