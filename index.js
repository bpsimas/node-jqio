
var compiled = {};
var parser = require('./gen/parser');

module.exports = function (expr, cb) {
    var filter;

    if (compiled.hasOwnProperty(expr)) {
        filter = compiled[expr];
    } else {
        try {
            filter = parser.parse(expr);
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

