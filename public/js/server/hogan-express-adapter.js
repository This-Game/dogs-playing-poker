(function() {
  var HoganExpressAdapter;

  HoganExpressAdapter = (function() {
    var init;

    init = function(hogan) {
      var compile;

      compile = function(source) {
        return function(options) {
          return hogan.compile(source).render(options);
        };
      };
      return {
        compile: compile
      };
    };
    return {
      init: init
    };
  })();

  if (typeof module !== "undefined" && module.exports) {
    module.exports = HoganExpressAdapter;
  } else {
    if (typeof exports !== "undefined") {
      exports.HoganExpressAdapter = HoganExpressAdapter;
    }
  }

}).call(this);
