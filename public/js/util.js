(function() {
  var Util, crypto, fs, secrets, _;

  _ = require('underscore');

  fs = require('fs');

  crypto = require('crypto');

  secrets = JSON.parse(fs.readFileSync(__dirname + '/../config/secrets.json', 'utf8'));

  Util = {
    makeGUID: function() {
      return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      var r = Math.random() * 16|0, v = c == 'x' ? r : (r&0x3|0x8);
      return v.toString(16);
    });;
    },
    encrypt: function(string) {
      var cipher, crypted, final;

      cipher = crypto.createCipher('aes-256-cbc', secrets.deckSalt);
      crypted = cipher.update(string, 'utf8', 'base64');
      final = cipher.final('base64');
      crypted += final;
      return crypted;
    },
    decrypt: function(string) {
      var decipher, decrypted, final;

      decipher = crypto.createDecipher('aes-256-cbc', secrets.deckSalt);
      decrypted = decipher.update(string, 'base64', 'utf8');
      final = decipher.final('utf8');
      return decrypted += final;
    }
  };

  exports.Util = Util;

}).call(this);
