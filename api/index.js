
var db;
var VerifyAuth = function(req, res, next){

    var username = req.param('username');
    var hash = req.param('hash');

    if (username.length == 0 || hash.length == 0){
        res.json({Error: "Access Denied"});
    }

    var sql = "SELECT count(username) as count, groups.id as gid FROM users " +
        "JOIN users_has_groups ON users.id = users_id " +
        "JOIN groups ON groups_id = groups.id " +
        "WHERE username = ? AND password = ?";

    db.query(sql,[username, hash], function(err, results){

        if (results[0].count == 1 ){
            req.group_id = results[0].gid;
            next();
        }
        else{


        res.json({Error: "Access Denied"});
        }

    });
}

module.exports = function(ambrosia, express){
    ambrosia.VerifyAuth = VerifyAuth;
    db = ambrosia.db;

    require('./users')(ambrosia);
    require('./ingredients')(ambrosia, express);
    require('./units')(ambrosia);
};