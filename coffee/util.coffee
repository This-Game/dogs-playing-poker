_ = require 'underscore'
fs = require 'fs'
crypto = require 'crypto'
secrets = JSON.parse(fs.readFileSync(__dirname + '/../config/secrets.json', 'utf8'))

Util =
  makeGUID: ->
    `'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random() * 16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    });`

  encrypt: (string) ->
    cipher = crypto.createCipher('aes-256-cbc', secrets.deckSalt)
    # console.log("ENCRYPTING", string)
    crypted = cipher.update(string, 'utf8', 'base64')
    final = cipher.final('base64')
    crypted += final
    # console.log "CRYPTED", crypted
    crypted

  decrypt: (string) ->
    decipher = crypto.createDecipher('aes-256-cbc', secrets.deckSalt)
    decrypted = decipher.update(string, 'base64', 'utf8')
    final = decipher.final('utf8')
    decrypted += final

exports.Util = Util