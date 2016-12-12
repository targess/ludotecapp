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
	boardgameAttr 	= boardgame.attributes;
	active_loan		= boardgame.loan;

	$('.js-loan-button').data("loanboardgameid",boardgameAttr.id);
	$('[data-name]').text(boardgameAttr.name);
	$('[data-playingtime]').text(boardgameAttr.playingtime+" minutes");
	$('[data-minage]').text(boardgameAttr.minage+"+");
	$('[data-thumbnail]').attr('src', boardgameAttr.thumbnail);

	if (boardgameAttr.minplayers === boardgameAttr.maxplayers) {
		$('[data-players]').text(boardgameAttr.minplayers);
	} else {
		$('[data-players]').text(boardgameAttr.minplayers+"-"+boardgameAttr.maxplayers);

	}

	if (active_loan) {

		$('[data-loanid]').data("loanid", active_loan.id);

		$('.js-loan-form label').first().show();
		$('.js-loan-form input').first().show();
		$('.js-loan-form input').first().val(active_loan.name);
		$('.js-loan-form input').first().attr('disabled','disabled');

		$('.js-loan-form input').last().val(active_loan.dni);
		$('.js-loan-form input').last().attr('disabled','disabled');

		$('.js-loan-form button').text('Devolver');
	}

}

function handleOnError (error) {
}

$(document).on('turbolinks:load', function() {

	$('.js-loans-modal').on ('click', function(event) {
		var boardgameId = $(this).data("boardgameid");
		var eventId  = idFromUri($(document).context.URL);

		$.ajax({
			type: 'GET',
			url: '/events/'+eventId+'/boardgames/'+boardgameId,
			dataType: 'json',
			success: getBoardgameFromId,
			error: handleOnError
		});

	});
	$('.js-loan-button').on('click', function(event) {
		event.preventDefault();
		var loanId   	= $('[data-loanid]').data("loanid");
		var eventId  	= idFromUri($(document).context.URL);
		var boardgameId = $('.js-loan-button').data("loanboardgameid");
		var dni 		= $('.js-loan-form input').last().val();
		debugger

		if (loanId) {
			$.ajax({
				type: 'PATCH',
				url: '/events/'+eventId+'/loans/'+loanId
			});
		} else {
			var loanData = { boardgame_id: boardgameId };
			$.ajax({
				type: 'POST',
				url: '/events/'+eventId+'/loans/',
				data: { loan: loanData, dni: dni }
			});
		}
	});
});


