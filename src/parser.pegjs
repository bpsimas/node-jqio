
{

  // def(<argument 1>, <argument 2>, ...)( body )( return value ) => function text
  var def = function () {
    var capture = Array.prototype.slice.call(arguments, 0)
    return function () {
      var body = Array.prototype.slice.call(arguments, 0).join(';');
      return function (ret) {
        return '(function (' + capture.join(',') + ') { ' + body + '; ' + 'return (' + ret + '); })'
      }
    }
  }

  // map(<function code>) => map function text
  var map = function (f) {
    return def('a')(
        'var r = []',
        'for (var i = 0; i != a.length; i++) {',
        'r.push(' + f + '(a[i]))',
        '}'
    )('r')
  }

  var reduce = function (s, f) {
    return def('a')(
        'var r = ' + s,
        'for (var i = 0; i != a.length; i++) {',
        'r = ' + f + '(r, a[i])',
        '}'
    )('r')
  }

  // conj() => function text yield conjucted array from input list of array
  var conj = function () {
    return reduce('[]', def('r', 'x')('Array.prototype.push.apply(r, x)')('r'));
  }

}

start
  = filter:filter
{
  return eval(filter)
}

filter
  = pipe

pipe
  = left:comma '|' right:pipe
{
  return def('json')()(right + '(' + left + '(json))')
}
  / comma

comma
  = left:dot ',' right:comma
{ 
  return def('json')()(left + '(json).concat(' + right + '(json))')
}
  / dot

dot
  = '.' key:key
{
  return map(def('json')()('json.' + key))
}
  / '.[' range:range ']'
{
  return map(def('json')()('json.slice(' + range.start + ', ' + range.end + ')'))
}
  / '.[' name:integer/string/key ']'
{
  return map(def('json')()('json["' + name + '"]'))
}
  / '.[]'
{
  return conj()
}
  / '.'
{
  return ''
}

string
  = '"' str:character* '"'
{
  return str
}
  / "'" str:character* "'"
{
  return str
}

character = chr:('\\'[\%!=/()"'@.:{}]/[a-zA-Z_])
{
  return chr
}

key = str:[a-zA-Z_][a-zA-Z_0-9]*
{
  return str
}

range
  = start:integer ':' end:integer
{
  return { start: start, end: end }
}

integer
  = digits:[0-9]+
{
  return Number(digits.join(''))
}

literal
  = integer
  / string

