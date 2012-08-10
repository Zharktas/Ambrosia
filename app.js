var express = require('express'),
    http = require('http');

var util = require('util'),
    crypto = require('crypto'),
    url = require('url'),
    path = require('path'),
    fs = require('fs');

var mysql = require('mysql');

var ambrosia = express();

ambrosia.configure('all', function(){
    ambrosia.set('port', process.env.PORT || 3000);
    ambrosia.set('views', __dirname + '/views');
    ambrosia.set('view engine', 'jade');
    ambrosia.use(express.favicon());
    ambrosia.use(express.logger('dev'));
    ambrosia.use(express.bodyParser());
    ambrosia.use(express.cookieParser('boliver'));
    ambrosia.use(express.session());
    ambrosia.use(express.static(path.join(__dirname, 'public')));
});


var dbFile = fs.readFileSync('db_credentials.json', 'utf8');
var db = JSON.parse(dbFile);

ambrosia.db = mysql.createClient({
    user: db.user,
    password: db.password,
    host: 'localhost',
    port: 3306
});

ambrosia.db.query('USE ' + db.database, function(err){
    if (err){
        console.log("no db");
    }
});

require('./api')(ambrosia, express);

ambrosia.all('*', function(req, res, next){

    if (req.session.user){
        next();
    }
    else if ( req.path == '/register' || req.path == '/login' || req.path.indexOf("/api/") == 0){
        next();
    }
    else{
       res.render('login');
   }
});

ambrosia.get('/', function(req,res){
	res.render('index',{User: null});
});

ambrosia.post('/login', function(req,res){
	console.log(req.body.user + " " + req.body.password);
    authenticate(req.body.user, req.body.password, function(err, user){

		if ( err ){
            console.log(err);
			res.render('index');
		}
        else{
		    req.session.regenerate(function(){
			    req.session.user = user.username;
                req.session.user_id = user.user_id;
                req.session.group_id = user.group_id;
			    res.render('index', {User: user.firstname + ' ' + user.lastname});
            });
        }
	});
});

ambrosia.get('/logout', function(req,res){
	req.session.destroy(function(){
		res.redirect('/ambrosia');
	});
});

function authenticate(user, pass, fn){
	
	var hashedPass = hash(pass, salt);

    var query = "SELECT users.id as uid, groups.id as gid, firstname, lastname, username, password FROM users " +
        "JOIN users_has_groups ON users.id = users_id " +
        "JOIN groups ON groups_id = groups.id " +
        "WHERE username = ? and password = ?";

	ambrosia.db.query(query,[user, hashedPass], function( err, results){
        console.log(results);

        if (err){
            console.log(err);
			throw err;
		}
		
		if (results.length != 1){
            return fn( new Error('Invalid credentials'));
        }

        var User = {
			username: results[0].username,
		    firstname: results[0].firstname,
			lastname: results[0].lastname,
            user_id: results[0].uid,
            group_id: results[0].gid
		};
					
			return fn(null, User);


		
	});	
}

ambrosia.get('/register', function(req,res){
	res.render('register');
});

var salt = 'KissaOnMuhvi';
function hash(msg, key){
	return crypto.createHmac('sha256', key).update(msg).digest('hex');
}


ambrosia.get('/addrecipe', function(req,res){
    res.render('addrecipe');
});

http.createServer(ambrosia).listen(ambrosia.get('port'), function(){
    console.log("Express server listening on port " + ambrosia.get('port'));
});
