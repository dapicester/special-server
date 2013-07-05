var MAXLEN = 140;

var ERRCLASS = "counter-error";

var Counter = {
  avail: function(text) {
    return MAXLEN - text.length;
  }
};

(function($) {
  $.fn.countAvailable = function() {
      $(this).on("input propertychange", function() {
        var len = Counter.avail($(this).val())
        var counter = $("#counter");
        counter.text(len);
        if (len >= 0) {
            if (counter.hasClass(ERRCLASS))
                counter.removeClass(ERRCLASS);
        } else {
            if (!counter.hasClass(ERRCLASS))
                counter.addClass(ERRCLASS);
        }
      });
      $(this).trigger("input");
  };
}(jQuery));

