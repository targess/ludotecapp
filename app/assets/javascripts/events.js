$(document).on ('turbolinks:load', function() {
  $('.datetimepicker').datetimepicker({
  	locale: moment.locale(),
  	icons: {
            time: 'fa fa-clock-o',
            date: 'fa fa-calendar'
        }
  });
});
