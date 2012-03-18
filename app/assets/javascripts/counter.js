var MAXLEN = 140;

$(document).ready(function() {
  var len = $("#micropost_form").html().length;
  $("#charNum").html(MAXLEN - len);
});

function countChar(val) {
  var len = val.value.length;
  if (len > MAXLEN) {
    val.value = val.value.substr(0, MAXLEN);
  } else {
    $("#charNum").text(MAXLEN - len);
  }
};

