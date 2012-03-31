module.exports = function(ambrosia, express){
    ambrosia.get('/api/ingredients', function(req, res){

        var query = "SELECT * FROM ingredient";

        ambrosia.db.query(query, function(err, results, fields){
            if (err){
                // log the error
                res.json({});
            }

            res.json({Ingredients: results});
        })

    });

    ambrosia.get('/api/ingredients/:id', function(req,res){
        res.json({});
    });

    ambrosia.post('/api/ingredients', function(req, res){
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

    ambrosia.put('/api/ingredients/:id', function(req, res){
        res.json({});
    });

    ambrosia.del('/api/ingredients/:id', function(req, res){
        res.json({});
    });

    ambrosia.get('/api/ingredients/search', function(req, res){
        req.sanitize('name').xss();

        var query = "SELECT * FROM ingredient " +
            "WHERE name LIKE '%" + req.param('name') + "%'";

        ambrosia.db.query(query, function(err, results, fields){
            res.json({Results: results});
        });
    });
}