function idFromUri (eventUri) {
	var uriSegments = eventUri.split("/");
	var element = uriSegments.length - 2;
	if (!isNaN(parseInt(uriSegments[element]))) {
		return uriSegments[element];	
	}
	element = uriSegments.length - 3;
		return uriSegments[element];
}

function getBoardgameFromId (boardgame) {
	boardgameAttr = boardgame.attributes;

	console.log(boardgame.free);

	$('[data-name]').text(boardgameAttr.name);
	$('[data-playingtime]').text(boardgameAttr.playingtime+" minutes");
	$('[data-minage]').text(boardgameAttr.minage+"+");
	$('[data-thumbnail]').attr('src', 'http://'+boardgameAttr.thumbnail);

	if (boardgameAttr.minplayers === boardgameAttr.maxplayers) {
		$('[data-players]').text(boardgameAttr.minplayers);
	} else {
		$('[data-players]').text(boardgameAttr.minplayers+"-"+boardgameAttr.maxplayers);

	}

	$('.js-loan-form label').first().hide();
	$('.js-loan-form input').first().hide();

	console.log(this);
	if (!boardgame.free) {
		$('.js-loan-form input').first().val("Joselito");
		$('.js-loan-form input').first().attr('disabled','disabled');

		$('.js-loan-form input').last().val("12345");
		$('.js-loan-form input').last().attr('disabled','disabled');

		$('.js-loan-form button').text('Devolver');
	}

}

function handleOnError (error) {
}

$(document).on ('ready', function() {
	$('.js-loans-modal').on ('click', function() {
		boardgameId = $(this).data("boardgameid");

		var eventId  = idFromUri($(document).context.URL);

		console.log(eventId);

		$.ajax({
			type: 'GET',
			url: '/events/'+eventId+'/boardgames/'+boardgameId,
			dataType: 'json',
			success: getBoardgameFromId,
			error: handleOnError
		});

	});
});