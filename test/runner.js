var mocha
var expect = require('chai').expect;
var mysql = require('mysql');


suite('DB Connection', function(){




    test(function(){
        var db = mysql.createClient({
            user: 'root',
            password: '',
            host: 'localhost',
            port: 3306
        });

        db.query('USE ' + 'ambrosia_test', function(err){
            expect(err).to.be.null;
        });
    });
});