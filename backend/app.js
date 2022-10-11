var mysql = require('mysql');
var express = require('express');
var http = require('http');
var app = express();
var path = require("path");
var bodyParser = require('body-parser');

var jsonParser = bodyParser.json()

var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "db-tech",
    database: "sakila",
});

// Body-parser middleware
app.use(express.json());

app.use(express.static(__dirname + '/public'));

/*app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});
*/

//>>> POST methods 

//Datenabfrage
app.post('/select', function(req,res){
    con.query("SELECT * FROM actor", function (err, result) {
        if (err) throw err;
        console.log(result);
    });
});

app.post('/add', jsonParser, function(req,res){
    res.setHeader('Content-Type', 'text/plain')
    res.write('you posted:\n')
    res.end(JSON.stringify(req.body.Firstname, null, 2))
    console.log("Using Body-parser: ", req.body)
});

var insert = "INSERT INTO actor (first_name, last_name) VALUES (?, ?)"

app.post('/add_user', jsonParser, function(req,res){
    res.setHeader('Content-Type', 'text/plain')
    res.write('you posted:\n')
    res.end(JSON.stringify(req.body, null, 2))
    console.log("Using Body-parser: ", req.body)


    con.query(insert, [req.body.Firstname, req.body.Lastname,], function (err, result) {
        if (err) throw err;
        console.log(result);
    });
});

// POST methods <<<

app.listen(8080, function(){
    console.log("server is running on port 8080");
})

app.get('/', function(req,res){
  res.sendFile(path.join(__dirname,'./index.html'));
});
