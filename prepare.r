library("plyr")

routes <- read.csv("/Users/torb/Sites/govhack/raw_data/buses/shapes.txt")
trips <- read.csv("/Users/torb/Sites/govhack/raw_data/buses/shapes.txt")

# reduce the data
# dlply(routes, .(shape_id), function(x) {
# 	
# })

routes.text <- dlply(routes, .(shape_id), function(x) {
	x$loc <- sprintf("[%f,%f]", x$shape_pt_lon, x$shape_pt_lat);
	paste(	sprintf("{\"type\": \"Feature\", \"properties\":{ \"name\":\"%d\" }, \"geometry\": { \"type\": \"LineString\", \"coordinates\": [", x$shape_id[1]),
			paste(x$loc, collapse=", "),
			"]}}")
})

print(paste(routes.text, collapse=", "), quote=FALSE)
	