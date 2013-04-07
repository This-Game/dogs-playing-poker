{Util} = require 'main/util.coffee'

s = Util.encrypt 'hey ho the live long day!'
console.log s

d = Util.decrypt s
console.log d