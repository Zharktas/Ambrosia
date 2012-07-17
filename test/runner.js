var expect = require('chai').expect;
var mysql = require('mysql');
var db;

suite('Database', function(){
    setup(function(){
        var db = mysql.createClient({
            user: 'root',
            password: '',
            host: 'localhost',
            port: 3306
        });
   });

    test("Connect DB", function(){
        db.query('USE ' + 'ambrosia_test', function(err){
            expect(err).not.to.be.null;
        });
    });
});