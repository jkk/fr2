$(document).ready(function() {
  var header_options  = {};
  var header_position = 0;
  $("table.sortable th").each(function(){
    if ($(this).html() == ''){
      header_options += {header_position: {sorter: false}};
    }
    header_position += 1;
  });
  
  $(".sortable").tablesorter({headers: header_options});
});

$(document).ajaxSend(function(e, xhr, options) {
    var token = $("meta[name='csrf-token']").attr("content");
    xhr.setRequestHeader("X-CSRF-Token", token);
});
