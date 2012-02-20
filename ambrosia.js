var https = require('https');
var fs = require('fs');
var express = require('express');

var jade = require('jade');

var util = require('util'), crypto = require('crypto');

var options = {
	key: fs.readFileSync('../server.key'),
	cert: fs.readFileSync('../server.crt')
};

var dbFile = fs.readFileSync('db_credentials.json', 'utf8');
var db = JSON.parse(dbFile);

var loginServer = express.createServer(options);

loginServer.post('/login', function(req, res){
	res.send('logged in');
});

loginServer.listen(3100);
var Client = require('mysql').Client,
    client = new Client();
    client.host = 'localhost';
    client.port = 3306;
    client.user = db.user;
    client.password = db.password;
    //client.connect();
    // use the correct database
    client.query('USE ambrosia'); // change this

	
	
var ambrosia = express.createServer(
	express.bodyParser(),
	express.cookieParser(),
	express.session({secret: 'boliver'}));

ambrosia.set('views', __dirname + '/views');
ambrosia.set('view engine', 'jade');
//ambrosia.use(express.cookieParser({secret: "boliver" }));

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

ambrosia.get('/*.js', function(req,res){
	res.sendfile(__dirname + '/' + req.params[0] + '.js');
});

ambrosia.get('/*.css', function(req,res){
	res.sendfile(__dirname + '/' + req.params[0] + '.css');
});

ambrosia.post('/login', function(req,res){
	authenticate(req.body.user, req.body.password, function(err, user){
		console.log('foo');
		if ( err ){
			res.render('index');
		}
		console.log(sys.inspect(user));
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
	client.query('SELECT * FROM user', function( err, results, fields ){
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

	client.query('select username from user', function(err, results, fields){
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
});

ambrosia.listen(3000,"127.0.0.1");
util.puts("Ambrosia running on port 3000");
