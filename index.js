
var compiled = {};
var parser = require('./gen/parser');

var jqio = module.exports = function (expr, cb) {
    var filter;

    if (compiled.hasOwnProperty(expr)) {
        filter = compiled[expr];
    } else {
        try {
            filter = parser.parse(expr);
            filter.code = expr;

            compiled[expr] = filter;
        } catch (err) {
            if (cb) {
                return cb(err);
            } else {
                throw err;
            }
        }
    }

    return (cb && cb(null, filter)) || filter;
};

var fs = require('fs');

jqio.load = function (filename, cb) {
    fs.readFile(filename, function (err, data) {
        if (err) return cb(err);
        return jqio(data.toString(), cb);
    });
};

