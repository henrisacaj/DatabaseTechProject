var mysql = require('mysql');
var express = require('express');
var http = require('http');
var app = express();
var path = require("path");
var bodyParser = require('body-parser');

//pug
var pug = require('pug');
app.set('view engine', 'pug');

// create application/json parser
var jsonParser = bodyParser.json()

var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "2774",
    database: "gym",

});

// Body-parser middleware
app.use(express.json());

app.use(express.static(__dirname + '/public'));



// Datenabfrage
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

app.post('/add_customer', jsonParser, function(req,res){
    console.log(req.body.membership_id);
    res.setHeader('Content-Type', 'text/plain')
    res.write('you posted:\n')
    res.end(JSON.stringify(req.body, null, 2))
    console.log("Using Body-parser: ", req.body)
    
    
    var  create_new_customer = "CALL create_new_customer(?, ?, ?, ?, ?, ?, ?, ?, ?);"
    con.query(create_new_customer, [req.body.membership_id, req.body.Firstname, req.body.Lastname, req.body.street, req.body.zipcode, req.body.email, req.body.phone, req.body.iban, req.body.birthday], function (err, result) {
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





//PUG yes yes


app.get('/mainsite', function(req, res){
    res.render(
        'test.pug',
        {title : 'Der gute Try', message : 'YesyEs Sehr gut'}
    )
})

app.get('/customer', function(req, res){
    res.render(
        'customer.pug'
    )
})