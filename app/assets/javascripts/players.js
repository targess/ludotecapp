function idFromUri (eventUri, position = -2) {
	var uriSegments = eventUri.split("/");
	var secondLast = uriSegments.length + position;
	return uriSegments[secondLast];
};

function getPlayerToUpdate (player) {

	$('[data-firstname]').val(player.firstname);
	$('[data-lastname]').val(player.lastname);
	$('[data-city]').val(player.city);
	$('[data-province]').val(player.province);
	$('[data-birthday]').val(player.birthday);
	$('[data-email]').val(player.email);
	$('[data-phone]').val(player.phone);
	$('[data-playerId').data('playerId', player.id);
	$('[data-playerId]').text('Inscribir');
};

function handleOnError (error) {
};

$(document).on ('ready', function() {

	$('.js-dni-autocomplete').on ('change', function(event) {
		var inputDni = $(event.target).val()

		if (inputDni.length === 9) {
			console.log('bien campeón! eso es un DNI!')
			var eventUri = $(document).context.URL;
			var eventId  = idFromUri(eventUri, -3);

			$.ajax({
				type: 'GET',
				url: '/events/'+eventId+'/players/show_by_dni?dni='+inputDni,
				dataType: 'json',
				success: getPlayerToUpdate,
				error: handleOnError
			});
		};
	});

	$('[data-playerId]').on ('click', function(myEvent) {
		myEvent.preventDefault();
		var eventUri = $(document).context.URL;
		var eventId  = idFromUri(eventUri, -3);
		playerId = $('[data-playerId]').data('playerId')
		if (playerId) {
			var myPlayer = {
				firstname: 	$('[data-firstname]').val(),
				lastname: 	$('[data-lastname]').val(),
				city: 		$('[data-city]').val(),
				province: 	$('[data-province]').val(),
				birthday: 	$('[data-birthday]').val(),
				email: 		$('[data-email]').val(),
				phone: 		$('[data-phone]').val(),
				id: 		$('[data-playerId]').data('playerId')
			};
			$.ajax({
				type: 'PATCH',
				url: '/events/'+eventId+'/players/'+myPlayer.id,
				data: { player: myPlayer }
			});
		};
	});
});
