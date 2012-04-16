module.exports = function(ambrosia){
    ambrosia.get("/api/units", ambrosia.VerifyAuth, function(req, res){

        var query = "select * from units " +
            "where group_id = ?";

        ambrosia.db.query(query, [req.group_id], function(err, results, fields){
            if (err){
                throw err;
            }

            res.json({Results: results});
        });
    });
    ambrosia.post("/api/units", ambrosia.VerifyAuth, function(req,res){
            req.sanitize("name").xss();

            var name = req.param("name");

            var sql = "select count(name) as count from units " +
                "where name = ? and group_id = ?";

            ambrosia.db.query(sql, [name, req.group_id], function(err, results, fields){
                if (err){
                    throw err;
                }

                if (results[0].count != 0){
                    return;
                }

                sql = "insert into units " +
                    "(name, group_id) values (?,?)";

                ambrosia.db.query(sql, [name, req.group_id], function(err, results, fields){
                    if (err){
                        throw err;
                    }

                    res.json({success: true});
                });
            });
        });

    ambrosia.del("/api/units/:id", ambrosia.VerifyAuth, function(req,res){

        var id = req.params.id;

        var sql = "DELETE FROM units " +
            "WHERE id = ?";

        console.log(sql);
        console.log(id);
        ambrosia.db.query(sql,[id], function(err, results){
           if (err){
               console.log(err);
           }
            console.log(results);
            res.json({Msg: "Record deleted"}, 200 );
        });
    });

    ambrosia.put("/api/units/:id", ambrosia.VerifyAuth, function(req,res){
        var id = req.params.id;
        var name = req.body.name;

        var sql = "UPDATE units " +
            "SET name = ? " +
            "WHERE id = ?";

        ambrosia.db.query(sql,[name, id], function(err, results){
            if (err){
                console.log(err);
            }
            console.log(results);
            res.json({Msg: "Record Updated"}, 200 );
        })

    });

};