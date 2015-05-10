Express = require 'express'
fs = require 'fs'

Config = {}

fibonacci = (i=34) ->
  if i < 0
    throw Error "Can not compute the #{i}nth number from " +
      "the fibonacci sequence, because it is <0."
  else if i < 2
    i
  else
    fibonacci(i-1) + fibonacci(i-2)

class Wikipage
  constructor: (@name) ->
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
