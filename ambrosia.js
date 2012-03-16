var fs = require('fs');
var express = require('express');

var jade = require('jade');

var util = require('util'), crypto = require('crypto'), url = require('url');

var validator = require('express-validator');

var options = {
	key: fs.readFileSync('../server.key'),
	cert: fs.readFileSync('../server.crt')
};

var dbFile = fs.readFileSync('db_credentials.json', 'utf8');
var db = JSON.parse(dbFile);

var ambrosia = express.createServer();

var Client = require('mysql').Client;
ambrosia.db = new Client();
ambrosia.db.host = 'localhost';
ambrosia.db.port = 3306;
ambrosia.db.user = db.user;
ambrosia.db.password = db.password;

//client.connect();
// use the correct database
ambrosia.db.query('USE ambrosia'); // change this

	
	


ambrosia.use(express.bodyParser());
ambrosia.use(express.cookieParser());
ambrosia.use(express.session({secret: 'boliver'}));
ambrosia.use(express.static(__dirname + '/public'));
ambrosia.use(validator);

ambrosia.set('views', __dirname + '/views');
ambrosia.set('view engine', 'jade');

require('./api')(ambrosia, express);

ambrosia.all('*', function(req, res, next){

    if (req.session.user){
        next();
    }
    else if ( req.path == '/register' || req.path == '/login'){
        next();
    }
    else{
       res.render('login');
   }
});



ambrosia.get('/db', function(req, res){
  		
		res.writeHead(200, {'Content-Type': 'text/plain'});
		// Basic Select query
		client.query('SELECT * FROM recipe', // change this
		function selectCb(err, results, fields) {
    			if (err) {
     		 	throw err;
    			}
			//    console.log(results);
			//    console.log(fields);
			//    console.log(JSON.stringify(results)); // left these in so you can do some console debugging
 
			//For each item do something with the result
			for (var i in results){
          			var result = results[i];
          			res.write(sys.inspect(result)+":"); // Writes to the web browser the value of test then a : to seperate values
      			}
      			res.end(); // end the request.
  		});
	});

ambrosia.get('/', function(req,res){
	res.render('index',{User: null});
});



ambrosia.post('/login', function(req,res){
	authenticate(req.body.user, req.body.password, function(err, user){
		console.log('foo');
		if ( err ){
			res.render('index');
		}
		console.log(util.inspect(user));
		req.session.regenerate(function(){
			req.session.user = user.username;
			res.render('index', {User: user.firstname + ' ' + user.lastname});
		});
	});
});

ambrosia.get('/logout', function(req,res){
	req.session.destroy(function(){
		res.redirect('/ambrosia');
	});
});

function authenticate(user, pass, fn){
	
	var hashedPass = hash(pass, salt);
	ambrosia.db.query('SELECT * FROM user', function( err, results, fields ){
		if (err){
			throw err;
		}
		
		
		for ( var i in results ){
			if ( results[i].username == user ){
				console.log('Comparing passwords');
				console.log(results[i].password);
				console.log(hashedPass);
				if ( results[i].password == hashedPass ){
					var User = {
						username: results[i].username,
						firstname: results[i].firstname,
						lastname: results[i].lastname
					};
					
					console.log('returning user');
					return fn(null, User);
				}
				else{
					return fn( new Error('invalid password'));
				}
			}
		}
		
		return fn(new Error('unknown user'));
		
	});	
};

ambrosia.get('/register', function(req,res){
	res.render('register');
});

var salt = 'KissaOnMuhvi';
function hash(msg, key){
	console.log(msg);
	console.log(key);
	return crypto.createHmac('sha256', key).update(msg).digest('hex');
};

ambrosia.post('/register', function(req,res){
    console.log("Registering..");
	client.query('select username from user', function(err, results, fields){
		console.log("Querying..");
        if (err){
			throw err;
		}
		
		for ( var i in results ){
			if (results[i].username == req.body.username ){
				res.render('register', {Msg: 'Error: Existing Username'});
				return;
			}
		}
		
		var hashedPass = hash(req.body.password, salt);
		var query = 'INSERT INTO user ' +
		'(username, password, firstname, lastname)' +
		'VALUES(\'' + req.body.username + '\',\'' + hashedPass + '\',\'' + req.body.firstname + '\',\'' + req.body.lastname + '\')';
		client.query(query, function(err, results, fields){
			res.render('register', {Msg: 'Logins Created'});
		});	
	});

    console.log("ending");
});

ambrosia.get('/addrecipe', function(req,res){
    res.render('addrecipe');
});

ambrosia.get('/api/recipes', function(req, res){
    var query = "SELECT id, name FROM recipe";

    client.query(query, function(err, results, fields){
        if (err){
            // log the error
            res.json({});
        }

        res.json({Recipes: results});
    })
});

ambrosia.get('/api/recipes/:id', function(req, res){

    res.json({});
});

ambrosia.get('/api/recipes/search', function(req, res){
    req.sanitize('name').xss();

    var query = "SELECT * FROM recipe " +
        "WHERE name LIKE '%" + req.param('name') + "%'";

    client.query(query, function(err, results, fields){
        res.json({Results: results});
    });
});

ambrosia.post('/api/recipes', function(req, res){
    res.json({});
});

ambrosia.put('/api/recipes/:id', function(req, res){
    res.json({});
});

ambrosia.del('/api/recipes/:id', function(req, res){
    res.json({});
});




ambrosia.listen(3000,"127.0.0.1");
util.puts("Ambrosia running on port 3000");
