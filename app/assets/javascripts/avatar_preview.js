/* global $ */

$(function() {
  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();
      reader.onload = function (e) {
        $('#avatar_prev').attr('src', e.target.result);
      };
      reader.readAsDataURL(input.files[0]);
    }
  }
  $("#avatar_img").change(function(){
    readURL(this);
  });
});

$('#delete_prev').click(function(){
  $('#avatar_prev').attr('src', '/app/assets/images/default_avatar.png');
})