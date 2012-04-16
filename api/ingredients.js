module.exports = function(ambrosia, express){
    ambrosia.get('/api/ingredients', ambrosia.VerifyAuth, function(req, res){

        var query = "SELECT * FROM ingredients " +
            "where group_id = ?";

        ambrosia.db.query(query,[req.session.group_id], function(err, results, fields){
            if (err){
                // log the error
                throw err;
            }

            res.json({Ingredients: results});
        })

    });

    ambrosia.get('/api/ingredients/:id', ambrosia.VerifyAuth, function(req,res){
        res.json({});
    });

    ambrosia.post('/api/ingredients', ambrosia.VerifyAuth, function(req, res){
        req.sanitize('name').xss();

        var name = req.param('name');

        var existingquery = "SELECT name FROM ingredients " +
            "WHERE name = ? and group_id = ?";
        ambrosia.db.query(existingquery, [name, req.session.group_id], function(err, results, fields){
            if (err){
                //log the error
                console.log(err);

            }

            if ( results.length == 0){
                var addquery = "INSERT INTO ingredients " +
                    "(name, group_id) VALUES(?, ?)";
                ambrosia.db.query(addquery,[name, req.session.group_id], function(err, results, fields){
                    if (err) console.log(err);
                    res.json({success: true});
                });
            }
            else{
                res.json({success: false});
            }
        });

    });

    ambrosia.put('/api/ingredients/:id', ambrosia.VerifyAuth, function(req, res){
        var id = req.params.id;
        var name = req.body.name;

        var sql = "UPDATE ingredients " +
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

    ambrosia.del('/api/ingredients/:id', ambrosia.VerifyAuth, function(req, res){
        var id = req.params.id;

        var sql = "DELETE FROM ingredients " +
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

    ambrosia.get('/api/ingredients/search', ambrosia.VerifyAuth, function(req, res){
        req.sanitize('name').xss();

        var query = "SELECT * FROM ingredient " +
            "WHERE name LIKE '%" + req.param('name') + "%'";

        ambrosia.db.query(query, function(err, results, fields){
            res.json({Results: results});
        });
    });
}