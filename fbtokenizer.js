/*
  Soixante circuits
  App token generator
  v.0.0.1
  This allow to generate a token for an application
  which you can use with the facebook graph tool :
  https://developers.facebook.com/tools/explorer
*/

var https = require("https"),
    querystring = require("querystring");

var instructions = "node fbtokenizer.js app_id app_secret";

if(process.argv.length > 3){
    var app_id = process.argv[2],
    app_secret = process.argv[3],
    app_token_url = "/oauth/access_token?client_id=" + app_id + "&client_secret=" + app_secret + "&grant_type=client_credentials";

    options = {
      host: 'graph.facebook.com',
      path: app_token_url
    },
    response = '';

  var req = https.get(options, function(res) {
    res.on("data", function(chunk) {
      response += chunk;
      var params = querystring.parse(response);
      console.log("This app's access token is: " + params.access_token);
    });
  }).on('error', function(e) {
    console.log("An error occured while retrieving the token: " + e.message);
  });  
} else {
  console.log("No app id or app secret, please type like this : ");
  console.log(instructions);
}

