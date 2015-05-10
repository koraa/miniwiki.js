Cluster = require 'cluster'
OS = require 'os'

numcpus = OS.cpus().length

P = console.log

module.exports = (cfg) ->
  if Cluster.isMaster && cfg.numcpus > 1
    for x in [1..(cfg.numcpus)]
      do Cluster.fork

    Cluster.on 'online', (w) ->
      P "Start Worker #{w.process.pid}"
    Cluster.on 'exit', (w) ->
      P "Exit Worker #{w.process.pid}"
      do Cluster.fork
  else
    Miniwiki = require './miniwiki'
    Miniwiki cfg
