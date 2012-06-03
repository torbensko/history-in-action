$(function() {
	$("#year-picker input").click(function() {
		yearFilterMin = $("#year-picker input:radio:checked").val();
		
		if(yearFilterMin == "all") {
			yearFilterMax = 2020;
			yearFilterMin = 0;
		} else if(yearFilterMin == "pre") {
			yearFilterMax = 1949;
			yearFilterMin = 0;
		} else {
			yearFilterMax = yearFilterMin + 9;
		}
		performPOISelection(true);
	});
	$("#year-picker").buttonset();
	
	// $("#poi-details").jScrollPane();
	
	// make the content scrollable
	$("#poi-clickers").children().eq(0).click(function() {
		var topScroll = Math.max(0, $("#poi-details").scrollTop() - 60);
		console.log(topScroll);
		$("#poi-details").animate({
		    scrollTop: topScroll
		});
	});
	$("#poi-clickers").children().eq(1).click(function() {
		$("#poi-details").animate({
		    scrollTop: $("#poi-details").scrollTop() + 60
		});
	});
	
	var idleCheck = function() {
		// if nothing is selected, grab a new image in order to keep the home page interesting
		if(selectedSuburb == false && selectedRoute == false)
			performPOISelection();
		setTimeout(idleCheck, 3000);
	};
	idleCheck();
	
});