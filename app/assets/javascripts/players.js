function idFromUri (eventUri) {
	var uriSegments = eventUri.split("/");
	var element = uriSegments.length - 2;
	console.log(element);
	if (!isNaN(parseInt(uriSegments[element]))) {
		console.log(element);
		return uriSegments[element];	
	}
	element = uriSegments.length - 3;
		return uriSegments[element];
}

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
}

function handleOnError (error) {
}

$(document).on ('ready', function() {

	$('.js-dni-autocomplete').on ('change', function(event) {
		var inputDni = $(event.target).val();

		if (inputDni.length === 9) {
			var eventUri = $(document).context.URL;
			var eventId  = idFromUri(eventUri);

			$.ajax({
				type: 'GET',
				url: '/events/'+eventId+'/players/show_by_dni?dni='+inputDni,
				dataType: 'json',
				success: getPlayerToUpdate,
				error: handleOnError
			});
		}
	});

	$('[data-playerId]').on ('click', function(myEvent) {
		myEvent.preventDefault();
		var eventUri = $(document).context.URL;
		var eventId  = idFromUri(eventUri);
		playerId = $('[data-playerId]').data('playerId');
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
		}
	});
});