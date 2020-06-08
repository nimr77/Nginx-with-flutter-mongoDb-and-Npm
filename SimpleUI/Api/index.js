
const express = require("express");
const MongoClient = require("mongodb").MongoClient;
var bodyParser = require('body-parser');
var cors = require("cors");
const join = require('path');
const url = "mongodb://localhost:27017";
const app = express();
const port = 2500;
var db;
// enable json
app.use(express.json());
app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
MongoClient.connect(url, function (err, client) {
  if (err) throw err;
  console.log("Database Connected!");
  db = client.db('mydb');
});

app.get('/', (req, res) => {
  res.sendFile(join(__dirname + '/DatabasePage.html'));
});

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
var server = app.listen(port, function () {

  var host = server.address().address

  console.log('Example app listening at http://%s:%s', host, port)

});