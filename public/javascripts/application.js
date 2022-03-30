$(function() {

  $("form.delete").submit(function(event) {
    event.preventDefault();
    event.stopPropagation();

    var ok = confirm("Confirm the permanent deletion of this interaction:");
    if (ok) {
      this.submit();
    }
  });

});