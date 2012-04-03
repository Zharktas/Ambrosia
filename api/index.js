module.exports = function(ambrosia, express){
    require('./users')(ambrosia);
    require('./ingredients')(ambrosia, express);
    require('./units')(ambrosia);
};