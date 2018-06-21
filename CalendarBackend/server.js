var express = require("express");
var bodyParser = require("body-parser");
var mongodb = require("mongodb");
var ObjectID = mongodb.ObjectID;

var EVENTS_COLLECTION = "events";

var app = express();
app.use(bodyParser.json());

// Create a database variable outside of the database connection callback to reuse the connection pool in your app.
var db;

// Connect to the database before starting the application server.
mongodb.MongoClient.connect(process.env.MONGODB_URI || "mongodb://localhost:27017/test", function (err, client) {
  if (err) {
    console.log(err);
    process.exit(1);
  }

  // Save database object from the callback for reuse.
  db = client.db();
  console.log("Database connection ready");

  // Initialize the app.
  var server = app.listen(process.env.PORT || 8080, function () {
    var port = server.address().port;
    console.log("App now running on port", port);
  });
});

// EVENTS API ROUTES BELOW

// Generic error handler used by all endpoints.
function handleError(res, reason, message, code) {
  console.log("ERROR: " + reason);
  res.status(code || 500).json({"error": message});
}

/*  "/api/events"
 *    GET: finds all events
 *    POST: creates a new event
 */

app.get("/api/events", function(req, res) {
  db.collection(EVENTS_COLLECTION).find({}).toArray(function(err, docs) {
    if (err) {
      handleError(res, err.message, "Failed to get events.");
    } else {
      res.status(200).json(docs);
    }
  });
});

app.post("/api/events", function(req, res) {
  var newEvent = req.body;

  if (!req.body.title) {
    handleError(res, "Invalid user input", "Must provide a title.", 400);
  }

  db.collection(EVENTS_COLLECTION).insertOne(newEvent, function(err, doc) {
    if (err) {
      handleError(res, err.message, "Failed to create new event.");
    } else {
      res.status(201).json(doc.ops[0]);
    }
  });
});

/*  "/api/events/:id"
 *    GET: find event by id
 *    PUT: update event by id
 *    DELETE: deletes event by id
 */

app.get("/api/events/:id", function(req, res) {
  db.collection(EVENTS_COLLECTION).findOne({ _id: new ObjectID(req.params.id) }, function(err, doc) {
    if (err) {
      handleError(res, err.message, "Failed to get event.");
    } else {
      res.status(200).json(doc);
    }
  });
});

app.put("/api/events/:id", function(req, res) {
  var updateDoc = req.body;
  delete updateDoc._id;

  db.collection(EVENTS_COLLECTION).update({ _id: new ObjectID(req.params.id)}, updateDoc, function(err, doc) {
    if (err) {
      handleError(res, err.message, "Failed to update event.");
    } else {
      updateDoc._id = req.params.id;
      res.status(200).json(updateDoc);
    }
  });
});

app.delete("/api/events/:id", function(req, res) {
  db.collection(EVENTS_COLLECTION).deleteOne({ _id: new ObjectID(req.params.id)}, function(err, result) {
    if (err) {
      handleError(res, err.message, "Failed to delete event");
    } else {
      res.status(200).json(req.params.id);
    }
  });
});
