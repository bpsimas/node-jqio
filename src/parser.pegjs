
// Global Functions {{{

{

  // def( <arglist> )( <body> )( <retval> )
  // =>
  // function (<arglist>) {
  //   [exec <body>]
  //   return <retval>
  // }
  var def = function () {
    var capture = Array.prototype.slice.call(arguments, 0)
    return function () {
      var body = Array.prototype.slice.call(arguments, 0).join(';');
      return function (ret) {
        return '(function (' + capture.join(',') + ') { ' + body + '; ' + 'return (' + ret + '); })'
      }
    }
  }

  // map(<code>) => function (array) { return [code(item) for item in array] }
  var map = function (f) {
    return def('a')(
        'var r = []',
        'for (var i = 0; i != a.length; i++) {',
        'r.push(' + f + '(a[i]))',
        '}'
    )('r')
  }

  // red(<initial>, <code>) => function (array) { return [initial = code(initial, item) for item in array] }
  var red = function (s, f) {
    return def('a')(
        'var r = ' + s,
        'for (var i = 0; i != a.length; i++) {',
        'r = ' + f + '(r, a[i])',
        '}'
    )('r')
  }

  // conj() => function (array) { return [item for item in items for items in array] }
  var conj = function () {
    return red('[]', def('r', 'x')('Array.prototype.push.apply(r, x)')('r'));
  }

}

// }}}

start
  = _ filter:filter _
{
  return eval(filter)
}

filter
  = pipe

pipe
  = left:comma _ '|' _ right:pipe
{
  return def('json')()(right + '(' + left + '(json))')
}
  / comma

comma
  = left:dot _ ',' _ right:comma
{
  return def('json')()(left + '(json).concat(' + right + '(json))')
}
  / dot

dot
  = '.' key:(identifier/string)
{
  return map(def('json')()('json["' + key + '"]'))
}
  / '.[' _ range:range _ ']'
{
  return map(def('json')()('json.slice(' + range.start + ', ' + range.end + ')'))
}
  / '.[' _ index:int _ ']'
{
  return map(def('json')()('json[' + index + ']'))
}
  / '.[' _ name:(string/identifier) _ ']'
{
  return map(def('json')()('json["' + name + '"]'))
}
  / '.[' _ ']'
{
  return conj()
}
  / '.'
{
  return def('json')()('json')
}

range
  = pair:pair
{
  return { start: pair.a, end: pair.b }
}

pair "pair"
  = a:int _ ':' _ b:int
{
  return { a: a, b: b }
}

// Lexical Elements {{{

identifier "identifier"
  = name:$([a-zA-Z_$] [a-zA-Z0-9_$]*)
{
  return name;
}

// JSON Literal Definition {{{

literal
  = string
  / number
  / "true" _  { return true;  }
  / "false" _ { return false; }
  / "null" _  { return null;  }

string "string"
  = '"' '"' _             { return "";    }
  / '"' chars:chars '"' _ { return chars; }
  / "'" "'" _             { return '';    }
  / "'" chars:chars "'" _ { return chars; }

chars
  = chars:char+ { return chars.join(""); }

char
  = [^"'\\\0-\x1F\x7f] // In the original JSON grammar: "any-Unicode-character-except-"-or-\-or-control-character"
  / '\\"'  { return '"';  }
  / "\\'"  { return "'";  }
  / "\\\\" { return "\\"; }
  / "\\/"  { return "/";  }
  / "\\b"  { return "\b"; }
  / "\\f"  { return "\f"; }
  / "\\n"  { return "\n"; }
  / "\\r"  { return "\r"; }
  / "\\t"  { return "\t"; }
  / "\\u" digits:$(hexDigit hexDigit hexDigit hexDigit)
{
  return String.fromCharCode(parseInt(digits, 16));
}

number "number"
  = parts:$(int frac exp) _ { return parseFloat(parts); }
  / parts:$(int frac) _     { return parseFloat(parts); }
  / parts:$(int exp) _      { return parseFloat(parts); }
  / parts:$(int) _          { return parseFloat(parts); }

int
  = digit19 digits
  / digit
  / "-" digit19 digits
  / "-" digit

frac
  = "." digits

exp
  = e digits

digits
  = digit+

e
  = [eE] [+-]?

digit
  = [0-9]

digit19
  = [1-9]

hexDigit
  = [0-9a-fA-F]

// }}}

// ECMAScript whitespace {{{

_ "whitespace"
  = whitespace*

whitespace
  = [ \t\n\r]

// }}}

// }}}

