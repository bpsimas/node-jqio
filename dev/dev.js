#!/usr/bin/env node

///
// Developer Script
//
// Load `./dev.json` and process JSON with script in `./dev.qs`
// Display input/output of json
// Display script content and compiled manipulation code
///

var input = require('./dev.json');

var parse = require('../index');

parse.load(__dirname + '/dev.qs', function (err, f) {
    if (err) throw err;
    console.log('=============DEVTOOL=============');
    console.log(' IN: ' + JSON.stringify(input));
    console.log('OUT: ' + JSON.stringify(f([input])));
    console.log('=============PROGRAM=============');
    console.log(f.code);
    console.log('=============COMPILE=============');
    console.log(f.toString());
});


