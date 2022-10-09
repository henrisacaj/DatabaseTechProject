var mysql = require('mysql');


var express = require('express');
var http = require('http');
var app = express();
var path = require("path");


var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "",
    database: "sakila",

});


con.query("SELECT * FROM actor", function (err, result) {
if (err) throw err;
console.log(result);
});


// Datenabfrage
app.post('/select', function(req,res){
    con.query("SELECT * FROM actor", function (err, result) {
        if (err) throw err;
        console.log(result);
    });
});

app.listen(8080, function(){
    console.log("server is running on port 8080");
})

app.get('/', function(req,res){
  res.sendFile(path.join(__dirname,'./index.html'));
});
