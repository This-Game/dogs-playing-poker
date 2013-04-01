HoganExpressAdapter = (->
  init = (hogan) ->
    compile = (source) ->
      (options) ->
        hogan.compile(source).render options

    compile: compile

  init: init
)()
if typeof module isnt "undefined" and module.exports
  module.exports = HoganExpressAdapter
else exports.HoganExpressAdapter = HoganExpressAdapter  if typeof exports isnt "undefined"