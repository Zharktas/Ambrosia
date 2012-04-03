module.exports = function(ambrosia){
    ambrosia.get("/api/units", function(req, res){
        var query = "select * from units " +
            "where group_id = ?";

        ambrosia.db.query(query, [req.session.group_id], function(err, results, fields){
            if (err){
                throw err;
            }

            res.json({Results: results});
        });

        ambrosia.post("/api/units", function(req,res){
            req.sanitize("name").xss();

            var name = req.param("name");

            var sql = "select count(name) as count from units " +
                "where name = ? and group_id = ?";

            ambrosia.db.query(sql, [name, req.session.group_id], function(err, results, fields){
                if (err){
                    throw err;
                }

                if (results[0].count != 0){
                    return;
                }

                sql = "insert into units " +
                    "(name, group_id) values (?,?)";

                ambrosia.db.query(sql, [name, req.session.group_id], function(err, results, fields){
                    if (err){
                        throw err;
                    }

                    res.json({success: true});
                });
            });
        });

    });
};