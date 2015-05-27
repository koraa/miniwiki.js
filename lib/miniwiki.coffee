Express = require 'express'
fs = require 'fs'

Config = {}

# Fast doubling algorithm
# http://www.nayuki.io/page/fast-fibonacci-algorithms
_fib = (n) ->
  return [0,1] if n == 0
  [a, b] = _fib n // 2
  c = a * (b*2 - a)
  d = a * a + b * b
  if n % 2 == 0
    [c, d]
  else
    [d, c + d]

fibonacci = (i=34) ->
  if i < 0
    throw Error "Can not compute the #{i}nth number from " +
      "the fibonacci sequence, because it is <0."
  _fib(i)[0]

class Wikipage
  constructor: (@name) ->
    unless @name.match /^[a-zA-Z-_]*$/
      throw Error "The wikipage name may only contain word characters"
    @path = "#{Config.prefix}/#{@name}"
  exists: ->
    fs.existsSync @path
  setText: (txt) ->
    fs.writeFileSync @path, txt
  getText: ->
    fs.readFileSync(@path).toString()

App = new Express

# Parse Plain Text
App.use (req, res, next) ->
  buf = []
  req.setEncoding 'utf8'
  req.on 'data', (d) ->
    buf.push d
  req.on 'end', ->
    req.raw = buf.join ""
    do next

App.get '/:page', (req, res) ->
  fibonacci()
  page = new Wikipage(req.params.page)
  unless page.exists()
    res.status(404).send "No such page! '#{page.name}'\n"
  else
    res.send page.getText()
App.post '/:page', (req, res) ->
  fibonacci()
  page = new Wikipage(req.params.page)
  page.setText req.raw
  res.send "Updated page '#{page.name}'\n"

module.exports = (cfg) ->
  Config = cfg
  unless fs.existsSync Config.prefix
    fs.mkdirSync Config.prefix
  App.listen cfg.port
