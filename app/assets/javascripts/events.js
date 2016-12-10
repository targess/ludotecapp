$(document).on ('ready', function() {
  $('.datetimepicker').datetimepicker({
  	locale: moment.locale(),
  	icons: {
            time: 'fa fa-clock-o',
            date: 'fa fa-calendar'
        }
  });
});