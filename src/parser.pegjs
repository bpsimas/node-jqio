
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
  return '(function (json) { return ' + right + '(' + left + '(json)) })'
}
  / comma

comma
  = left:dot ',' right:comma
{ 
  return '(function (json) { return ' + left + '(json).concat(' + right + '(json)) })'
}
  / dot

dot
  = '.' key:key
{
  return '(function (json) { return Array.isArray(json)?json[0]["' + key + '"]:json.' + key + ' })'
}
  / '.[' range:range ']'
{

}
  / '.[' index:integer ']'
{

}
  / '.[' name:(string/key) ']'
{
  
}
  / '.[]'
{
  return '(function (json) { return json })'
}
  / '.'
{
  return '(function (json) { return json })'
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

character = '\\'? chr:[a-zA-Z_]
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

