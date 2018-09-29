component name="Movie REST Endpoint"  accessors="true" output="false" {

    // FW/1 will use its dependency injection framework (DI/1) to find and
    // inject the components defined below as properties
    property fw;
    property movieService;
    property movieToActorService;

    // FW/1 will automatically run the before() function before any controller
    // functions are run
    public void function before( rc ){
    }

    // FW/1 will automatically run the after() function after any controller 
    // functions are run
    public void function after( rc ){
        rc.data = rc.data ?: "";
        rc.statusCode = rc.statusCode ?: 200;

        // renderData() is a FW/1 utility function to serialize/render data for 
        // REST APIs
        fw.renderData().data( rc.data ).type( 'json').statusCode( rc.statusCode );
    }

    public void function default( rc ){
        var q = movieService.getAll();

        rc.data = q.reduce( function( prev, row ){
            var movieLinks = movieToActorService.getByMovieID( row.MovieID );
            var actorIDs = valueArray( movieLinks, "ActorID" );
            var movie = {
                "MovieId" : row.MovieID,
                "Title" : row.Title,
                "Rating" : row.Rating,
                "ReleaseYear" : row.ReleaseYear,
                "PlotSummary" : row.PlotSummary,
                "ActorIDs" : actorIDs
            };
            return prev.append( movie );
        }, []);
    }

    public void function show( rc ){
        // If FW/1 is configured with routes, it will automatically find the 
        // id value in the URL and put it in the rc.id struct key
        var q = movieService.getById( rc.id );

        if ( q.recordCount ) {
            var movieLinks = movieToActorService.getByMovieID( rc.id );
            var actorIDs = valueArray( movieLinks, "ActorID" );
            rc.data = {
                "MovieId" : q.MovieID,
                "Title" : q.Title,
                "Rating" : q.Rating,
                "ReleaseYear" : q.ReleaseYear,
                "PlotSummary" : q.PlotSummary,
                "ActorIDs" : actorIDs
            };
        }
        else {
            rc.statusCode = 404;
        }
    }

    public void function create( rc ){

        try {
            rc.data = movieService.insert( rc.title, rc.rating, rc.releaseyear,
                rc.plotsummary );
            rc.statusCode = 201;
        }
        catch ( any e ) {
            rc.statusCode = 400;
        }
    }

    /* 
    ** Data must be sent in the request as x-www-form-urlencoded data with 
    ** "content-type" header set to "application/x-www-form-urlencoded", or as 
    ** json data with "content-type" header set to "application/json"
    */
    public void function update( rc ){
        var q = movieService.getById( rc.id );
            
        // if the REST request didn't include all of the movie arguments/fields
        // then supply them from the current database record
        rc.title = structKeyExists( rc, "title" ) ? rc.title : q.Title;
        rc.rating = structKeyExists( rc, "rating") ? rc.rating : q.Rating;
        rc.releaseyear = structKeyExists( rc, "releaseyear") ? rc.releaseyear : q.ReleaseYear;
        rc.plotsummary = structKeyExists( rc, "plotsummary") ? rc.plotsummary : q.PlotSummary;

        try {
            var result = movieService.update( rc.id, rc.title, rc.rating, rc.releaseyear,
                rc.plotsummary );
            rc.statusCode = result > 0 ? 204 : 404;
        }
        catch ( any e ) {
            rc.statusCode = 400;
        }
    }

    public void function destroy( rc ){

        try {
            var result = movieService.delete( rc.id );
            rc.statusCode = result > 0 ? 204 : 404;
        }
        catch ( any e ) {
            rc.statusCode = 400;
        }
    }
}