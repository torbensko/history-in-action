library("plyr")

routes.all <- read.csv("/Users/torb/Sites/govhack/raw_data/buses/shapes.txt")
trips <- read.csv("/Users/torb/Sites/govhack/raw_data/buses/trips.txt")

# reduce the data
routes.cuts <- ddply(routes.all, .(shape_id), function(x) {
	print(x$shape_id[1])
	
	goal <- round(dim(x)[1]*0.2)
	cols <- colnames(x)
	
	while(dim(x)[1] > goal) {
		x$dx <- c(0, diff(x$shape_pt_lat))
		x$dy <- c(0, diff(x$shape_pt_long))
		x$r <- sqrt(x$dx*x$dx + x$dy*x$dy)
		x$r[1] <- 1000000
		x$r[dim(x)[1]] <- 1000000
		x <- x[x$r > min(x$r),]
	}
	x[,cols]
})

trips.reduced <- data.frame(shape_id=trips$shape_id, name=gsub("(.*)-10181", "\\1", trips$route_id))
trips.reduced <- ddply(trips.reduced, .(shape_id), function(x) { x[1,] })


trips.reduced <- merge(routes.cuts, trips.reduced, all.x=TRUE)



routes.text <- dlply(trips.reduced, .(shape_id), function(x) {
	x$loc <- sprintf("[%f,%f]", x$shape_pt_lon, x$shape_pt_lat);
	paste(	sprintf("{\"type\": \"Feature\", \"properties\":{ \"name\":\"%s\" }, \"geometry\": { \"type\": \"LineString\", \"coordinates\": [", as.character(x$name[1])),
			paste(x$loc, collapse=", "),
			"]}}")
})

sink("/Users/torb/Sites/govhack/data/bus-routes.json")

print(paste(
		"{\"type\": \"FeatureCollection\", \"features\": [",
		paste(routes.text, collapse=", "),
		"]}"), quote=FALSE)

sink()
