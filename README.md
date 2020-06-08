# Nginx-with-flutter-mongoDb-and-Npm
 This projects aims to explain how to create a web demo interface by using ```Flutter``` and creating rest Api with ```NodeJS```, with a ```CentOS``` server, that runs with ```nginx```, and a database ```MongoDB```.
 ### Please note that all the packages installaization is been take care of by using ```./setup.sh```
 #### so lets explain how the setup will work!
 it will start by installing nginx:
 ```bash
 sudo yum install epel-release && echo " done installing epel" >> $R || echo "Error while installing epel">>$R
sudo yum install nginx && echo " done installing nginx" >> $R || echo "Error while installing nginx">> $R
echo "Installing done"
echo "Starting and enabling nginx"
sudo systemctl start nginx
sudo systemctl status nginx >> $R
sudo systemctl enable nginx
````
this will install nginx and configure it on the systemctl manager.
then we will configure the network, so our server will listen to the address of the machine not the localhost 

```bash
echo "Setting up the network"
ifconfig
read -p  "Please choose an interface for the static network:(enp0s8) " networkInterface
networkInterface=${networkInterface:-enp0s8}
read -p  "Please provide the Ipv4 address for the interface:(192.168.56.101) " netInfAdd
netInfAdd=${netInfAdd:-192.168.56.101}
read -p  "Please provide the Ipv4 mask for the interface:(255.255.255.0) " netInfAddMask
netInfAddMask=${netInfAddMask:-255.255.255.0}
```
when all its done the script ```bash ./configureNetwork.sh $networkInterface $netInfAdd $netInfAddMask ``` will take care of the rest, but how it works?

```bash 
echo "Network config log will be saved into NetConf.log"
R="NetConf.log"

#The where need to change to make the network static 
whereToChange="/etc/sysconfig/network-scripts/ifcfg-$1"
echo "We will change $whereToChange"
#what need to be added to make this interface static 

whatToChange="
DEVICE=$1
BOOTPROTO=static 
IPADDR=$2 
NETMASK=$3 
NM_CONTROLLED=no
ONBOOT=yes"
#Here where it will save the changes into the server conf
echo $whatToChange > $whereToChange && echo " Done saving into $whereToChange" >> $R 
```
after editing the interface, and save the change, we will reload the network on the new changes!
``` bash systemctl restart network```
now lets setup the firewall 
```./activePort80.sh
```
this script will take care of it:
```bash
  GNU nano 4.8                                                     activePort80.sh                                                               
#this Script will setup the firwall and allow for connections on port 80
#installing Firewall
sudo yum install firewalld
#Starting Firewall
sudo systemctl start firewalld
#allwoing it to work when launch
sudo systemctl enable firewalld
#allow for port 80
sudo firewall-cmd --zone=public --add-port=80/tcp
firewall-cmd --permanent --zone=public --add-port=2500/tcp
sudo firewall-cmd --permanent --zone=public --add-service=http
sudo firewall-cmd --permanent --zone=public --add-service=https
sudo firewall-cmd --reload

````
##### please note that we enabled port 80 and port 2500, one for the http/https server and one for The Api that we will use 

now it will be time to install mongo DB:
```. /initManog.sh
```
this will install mongo db on cent OS machine!
and it works like the follow:
```
  GNU nano 4.8                                                      initManog.sh                                                                 
./addMongoDbRepo.sh
yum repolist
yum -y install mongodb-org
systemctl start mongod
netstat -plntu
systemctl status mongod
systemctl enable mongod
```
as you can see you will add the repo first by using another script on the server!
```bash 
  GNU nano 4.8                                                    addMongoDbRepo.sh                                                              
#this for Download ing the packages and installing mangoDB
cd /etc/yum.repos.d/
echo '[mongodb-org-3.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/3.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-3.2.asc' >mongodb-org-3.2.repo
```

now it will be the time to install npm, by using the following script:
``` ./InitNPM.sh
```
it will install the packages and take care of installing the node package in the API
```bash
  GNU nano 4.8                                                       InitNPM.sh                                                                  
yum install npm
cd ./SimpleUI/Api
npm i
```
###### Please note that, if you find the models not in there place, please copy the foler to ``` ./SimpleUI/Api ```

now aftre all of that time for nginx first we will copy the UI to the Html of our nfinx 
```./setupUI.sh ```
this will copy the demo database manager.
and finaly we will configure the nginx by using 
``` bash ./configNginx.sh ```
this will chnage the defualt configuration of nginx and restart it.

if all clear, now we can lunch the Api:
its launcher is loact into the ``` Launcher ``` folder and to test it go to http://Server-Address/databaseDriver/web/


### The API
after installing all packages now we can launch the Api and deal with it, but how it works ?

First its under ``` .//SimpleUI/Api ``` Here there is only one server that hanlde the work its ```index.js```, so lets walk throw it!
##### First we will require all packages that we need, and set up the port
```js 
const express = require("express");
const MongoClient = require("mongodb").MongoClient;
var bodyParser = require('body-parser');
var cors = require("cors");
const join = require('path');
const url = "mongodb://localhost:27017";
const app = express();
const port = 2500;
var db;
```
now lets setup express 
```js 
app.use(express.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
```
then we setup our DB:
```js 
MongoClient.connect(url, function (err, client) {
  if (err) throw err;
  console.log("Database Connected!");
  db = client.db('mydb');
});
```
All clear now the APIs 
lets start of getting all the Colleactions
```js 
app.get('/Api/GetAllCollections', (req, res) => {
  db.listCollections().toArray(function (err, collInfos) {
    // collInfos is an array of collection info objects that look like:
    // { name: 'test', options: {} }
    console.log(collInfos);
    if (Array.isArray(collInfos) && collInfos.length)

      res.send({
        status: true,
        Message: collInfos
      });
    else
      res.send({
        status: false,
        Message: "No Collactions"
      });
  });

});
```
How about creating one:
```js
app.post('/Api/CreateCollection', (req, res) => {
  const CollectionName = req.body.Name;
  db.createCollection(CollectionName, function (err, res) {
    if (err) {
      res.send({
        status: false,
        message: "err"
      });
      throw err;
    }
    console.log("Collection created! " + CollectionName);
    res.send({
      status: true,
      message: "Created"
    });
  });

});
```
and inserting into it:
```js
app.post('/Api/InsertInto', (req, res) => {
  const CollectionName = req.body.CollectionName;
  const CollectionData = JSON.parse(req.body.MyData);

  db.collection(CollectionName).insertOne(CollectionData, function (err, col) {
    if (err) {
      res.send({
        status: false,
        message: "Error"
      });
      throw err;
    }
    console.log("1 document inserted");
    res.send({
      status: true,
      message: "Added"
    });
  });

});
```
now lets get what we added:
```js
app.post('/Api/GetMyElement', (req, res) => {
  console.log(req.body.CollectionName);
  db.collection(req.body.CollectionName).find({}).toArray(function (err, result) {
    if (err) {
      res.send({
        status: false,
        message: "error"
      });
      throw err;
    }
    res.send({
      status: true,
      message: result
    });
  });


});
```
so what is left is launching the API:
``` js
var server = app.listen(port, function () {

  var host = server.address().address

  console.log('Example app listening at http://%s:%s', host, port)

});

```

and thats it for our nodejs coding, 
### Now the UI !
#### as for the UI we will use Flutter to code, and build it as Html and JS for Web!
##### Here I will explain only the important functions!
we got only one page that handel's everything ''' MyHomePage '''
all my classes are named with ``` Myxxxxx ```

in the initState we will load the data from the database!
```dart
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
  ```
  ##### PLease note that the class of MyColleactions handel's it's own actions with the database, so we got the CLASS and MyActions
 ##### ``` MyActions is the one that handels all with the database ```  others will fetsh the data only.
 
 so we got 
``` dart 
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
```
and the class of Actions 
```dart
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
``` 
and the APIs url are in ``` API.dart ```

### Please when you change the address please dont forget to change the address of the server in the UI!!!!!!
```dart
class MyAPIs {
  static const MyHostConnection = "http://192.168.56.102:2500";
  static const GetAllCollections = MyHostConnection + "/Api/GetAllCollections";
  static const GetElementsForThisCollaction =
      MyHostConnection + "/Api/GetMyElement";
  static const CreateCollaction = MyHostConnection + "/Api/CreateCollection";
  static const InsertIntoCollaction =MyHostConnection + "/Api/InsertInto";
}
```


