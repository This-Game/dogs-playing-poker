Hogan = require 'hogan.js'
fs = require 'fs'

exports.MustacheViews =
  hand: Hogan.compile(fs.readFileSync(__dirname + '/views/hand.mustache', 'utf8'))