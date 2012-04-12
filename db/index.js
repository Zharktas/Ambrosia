var Sequelize = require('sequelize');
var fs = require('fs');

module.exports = function(ambrosia){

    var dbFile = fs.readFileSync('db_credentials.json', 'utf8');
    var db = JSON.parse(dbFile);

    ambrosia.db = {};
    ambrosia.db.sequelize = new Sequelize('ambrosia', db.user, db.password);

    ambrosia.db.Models = {};

    //ambrosia.db.Models.Recipe = ambrosia.db.sequelize.import(__dirname + '/models/recipe');
    //ambrosia.db.Models.Ingredient = ambrosia.db.sequelize.import(__dirname + '/models/ingredient');
    //ambrosia.db.Models.RecipesIngredient = ambrosia.db.sequelize.import(__dirname + '/models/recipesingredient');
    //ambrosia.db.Models.Unit = ambrosia.db.sequelize.import(__dirname + '/models/unit');
    //ambrosia.db.Models.Tag = ambrosia.db.sequelize.import(__dirname + '/models/tag');
    //ambrosia.db.Models.Eatingday = ambrosia.db.sequelize.import(__dirname + '/models/eatingday');

    ambrosia.db.Models.User = ambrosia.db.sequelize.import(__dirname + '/models/user');
    ambrosia.db.Models.Group = ambrosia.db.sequelize.import(__dirname + '/models/group');
    //ambrosia.db.Models.Review = ambrosia.db.sequelize.import(__dirname + '/models/review');

    ambrosia.db.Models.User.hasMany(ambrosia.db.Models.Group);
    ambrosia.db.Models.Group.hasMany(ambrosia.db.Models.User);



    //ambrosia.db.Models.User.hasMany(ambrosia.db.Models.Eatingday, {foreignKey: 'user_id'});

    //ambrosia.db.Models.Group.hasMany(ambrosia.db.Models.Recipe, {foreignKey: 'group_id'});
    //ambrosia.db.Models.Group.hasMany(ambrosia.db.Models.Unit, {foreignKey: 'group_id'});

    //ambrosia.db.Models.Recipe.hasMany(ambrosia.db.Models.Recipe);
    //ambrosia.db.Models.Recipe.hasMany(ambrosia.db.Models.RecipesIngredient, {foreignKey: 'recipes_id'});
    //ambrosia.db.Models.Ingredient.hasMany(ambrosia.db.Models.RecipesIngredient, {foreignKey: 'ingredients_id'});
    //ambrosia.db.Models.Unit.hasMany(ambrosia.db.Models.RecipesIngredient, {foreignKey: 'units_id'});

    //ambrosia.db.Models.Tag.hasMany(ambrosia.db.Models.Recipe);
    //ambrosia.db.Models.Recipe.hasMany(ambrosia.db.Models.Tag);

    //ambrosia.db.Models.Eatingday.hasMany(ambrosia.db.Models.Recipe);
    //ambrosia.db.Models.Recipe.hasMany(ambrosia.db.Models.Eatingday);

    //ambrosia.db.Models.Eatingday.hasMany(ambrosia.db.Models.Ingredient);
    //ambrosia.db.Models.Ingredient.hasMany(ambrosia.db.Models.Eatingday);

    //ambrosia.db.Models.User.hasMany(ambrosia.db.Models.Review, {foreignKey: 'user_id'});
    //ambrosia.db.Models.Recipe.hasMany(ambrosia.db.Models.Review, {foreignKey: 'recipe_id'});

    ambrosia.db.sequelize.sync();

};