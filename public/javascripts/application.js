$(document).ready(function(){
  var f = $('.fieldWithErrors :input:first');
  if (f.length == 0) f = $('.input :input:first');
  f.focus();
});
