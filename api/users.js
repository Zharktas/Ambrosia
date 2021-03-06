var crypto = require('crypto');


module.exports = function(ambrosia){
    ambrosia.get('/api/users', function(req,res){
        res.json({Msg: "hi"});
    });

    ambrosia.post('/api/users', function(req,res){
        var user = {
            firstname: req.body.firstname,
            lastname: req.body.lastname,
            username: req.body.username,
            password: hash(req.body.password, salt)
        };

        //check existing
        var select = "SELECT count(username) as count from users " +
            "WHERE username = ?";
        ambrosia.db.query(select, [user.username], function(err, results){
            if (err){
                console.log(err);
            }


            if ( results[0].count != 0 ){
                res.json({Msg: 'Error: Existing Username'});
                return;
            }

            var usersql = "INSERT INTO users " +
            '(username, password, firstname, lastname)' +
            'VALUES(?,?,?,?)';

            ambrosia.db.query(usersql, [user.username, user.password, user.firstname, user.lastname], function(err, user){
                if (err){
                    //log the error
                    res.json({error: err});
                    return;
                }


                var group = {
                    name: req.body.username
                };

                var groupsql = "INSERT INTO groups " +
                    "(name)" +
                    "VALUES(?)";

                ambrosia.db.query(groupsql,[group.name], function(err, group){
                    if (err){
                        //log the error
                        res.json({error: err});
                        return;
                    }

                    var associationsql = "INSERT INTO users_has_groups " +
                        "(users_id, groups_id)" +
                        "VALUES('" + user.insertId + "','" + group.insertId + "')";

                    ambrosia.db.query(associationsql, function(err, ass){
                        if (err){
                            //log the error
                            res.json({error: err});
                            return;
                        }

                        var getHash = "SELECT password FROM users " +
                            "WHERE username = ?";
                        ambrosia.db.query(getHash, [req.body.username], function(err, results){
                            res.json({username: req.body.username, hash: results[0].password}, 201);
                        });
                    });

                });
            });
        });
    });
};

var salt = 'KissaOnMuhvi';
function hash(msg, key){
    return crypto.createHmac('sha256', key).update(msg).digest('hex');
};

