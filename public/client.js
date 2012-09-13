$(document).ready(function() {
  $('#contact').submit(function() {
    $('#success,#error').hide();
    var url = $(this).attr('action')
    var params = $(this).serialize()
    $.getJSON(url + '?' + params + "&callback=?", function(data) {
      if(data == true) { // success
        $('#success').fadeIn("slow");
        $('#contact')[0].reset();
        $('.req').css('border', '');
      } else { // error
        $('#error').fadeIn("slow");
        for (field in data) {
          if (data[field])
            $('[name^="'+field+'"]').css('border', '1px inset red');
        }
      }
    });
    return false;
  });
});
