var files = ["test/database.js"];

var Mocha = require('mocha');

var mocha = new Mocha;
mocha.reporter('spec').ui('tdd');

files.forEach(function(file){
    mocha.addFile(file);
})

var runner = mocha.run(function(){
    console.log('done');
});