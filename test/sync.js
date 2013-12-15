
var expect = require('chai').expect;

describe('Synchronized Code Generation', function () {

    var parse = require('../index');

    it('should parse "."        -- dot operator', function () {
        expect(parse('.')([ 'foo' ]))
        .to.have.length.of(1)
        .and.include('foo');
    });

    it('should parse ".,."      -- comma operator', function () {
        expect(parse('.,.')([ 'foo' ]))
        .to.have.length.of(2)
        .and.include('foo');
    });

    it('should parse ".|.,."    -- pipe operator', function () {
        expect(parse('.|.,.')([ 'foo' ]))
        .to.have.length.of(2)
        .and.include('foo');
    });

});

