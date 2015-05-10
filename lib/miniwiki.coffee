Express = require 'express'
fs = require 'fs'

Config = {}

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
  res.send new Wikipage(req.params.page).getText()
App.post '/:page', (req, res) ->
  res.send new Wikipage(req.params.page).setText req.raw

module.exports = (cfg) ->
  Config = cfg
  App.listen cfg.port