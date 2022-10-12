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

var urlencodedParser = bodyParser.urlencoded({ extended: false })


var con = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "2774",
    database: "my_gym",

});

// Body-parser middleware
app.use(bodyParser.urlencoded({extended:false}))
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
    res.end(JSON.stringify(req.body.body, null, 2))
    console.log("Using Body-parser: ", req.body)
});








app.post('/add_customer', function(req,res){
    //console.log(req.body.membership_id);
    //res.setHeader('Content-Type', 'text/plain')
    //res.write('you posted:\n')
    //res.end(JSON.stringify(req.body, null, 2))
    //console.log("Using Body-parser: ", req.body)
    
    
    var  create_new_customer = "CALL create_new_customer(?, ?, ?, ?, ?, ?, ?, ?, ?);"
    con.query(create_new_customer, [req.body.membership_id, req.body.Firstname, req.body.Lastname, req.body.street, req.body.zipcode, req.body.email, req.body.phone, req.body.iban, req.body.birthday], function (err, result) {
        if (err){
            var message = { mess: "Der Kunde konnte nicht hinzugefügt werden!",
                firstname: "",
                lastname: ""
            };
            res.render(
                'customer.pug',
                {custMesAd: message}
            )

          

        } 
        else {console.log("Customer created:");
        console.log(result);
        var message = { mess: "Der Kunde wurde erfolgreich hinzugefügt: ",
                firstname: req.body.Firstname,
                lastname: req.body.Lastname
        };
       
        res.render(
            'customer.pug',
            {custMesAd: message}
        )
        }
        
    });

   

});



app.listen(8080, function(){
    console.log("server is running on port 8080");
})







//PUG yes yes
var  get_view_extras = "SELECT * FROM my_gym.membership_extra;"

app.get('/', function(req, res){
    console.log("Läuft");
    con.query(get_view_extras, function(error, results, fields) {
        if(error);
        else {
            console.log('The solution is: ', results);
            res.render(
                'index.pug',
                {dataMemb: results}
            )
        }
    })
})



app.get('/customer', function(req, res){
    var message = { Mess: "",
    firstname: "",
    lastname: ""
    };
    res.render(
        'customer.pug',
        {custMesAd: message}
    )
})


app.post('/deleteCustomer', function(req,res){
    var message = { mess: "",
        firstname: "",
        lastname: "",
        deleteMessage: "" 
    };
    var  delete_customer = "CALL delete_customer(" + req.body.customerNumber + ");"
    con.query(delete_customer, function (error, results, field) {
        if (error){
            message.mess ="";
            message.firstname = "";
            message.lastname = "";
            message.deleteMessage = "Der Kunde konnte nicht gelöscht werden!";
        } 
        else {

        console.log(results);
        message.mess = "";
        message.firstname = "";
        message.lastname =  "";
        message.deleteMessage = "Der Kunde wurde erfolgreich gelöscht!";

        }
        res.render(
            'customer.pug',
            {custMesAd: message}
        )
        
    });

   

});


app.post('/findCustomer', function(req,res){
    var message = { mess: "",
        firstname: "",
        lastname: "",
        deleteMessage: "",
        findMessage: ""
    };
    var  find_customer = "SELECT get_customer_id_by_name (?,?,?) as id;"
    con.query(find_customer, [req.body.Firstname, req.body.Lastname, req.body.birthday],  function (error, results, field) {
        
 

        if (error){
            message.findMessage = "Diesen Kunden gibt es nicht!";
        } 
        else {
       
            console.log("Die ID ist: " + results[0].id);
            message.findMessage = "Die ID von " + req.body.Firstname + " " + req.body.Lastname + " ist: " + results[0].id;

        }
        res.render(
            'customer.pug',
            {custMesAd: message}
        )
        
    });

   

});