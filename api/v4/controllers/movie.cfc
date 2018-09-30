component name="Movie REST Endpoint"  accessors="true" output="false" {

    // FW/1 will use its dependency injection framework (DI/1) to find and
    // inject the components defined below as properties
    property fw;
    property movieService;
    property movieToActorService;

    public void function get( rc ){
        if ( structKeyExists( rc, "id" ) ){
            var q = movieService.getById( rc.id );

            if ( q.recordCount ) {
                var movieLinks = movieToActorService.getByMovieID( rc.id );
                var actorIDs = valueArray( movieLinks, "ActorID" );
                var data = {
                    "MovieId" : q.MovieID,
                    "Title" : q.Title,
                    "Rating" : q.Rating,
                    "ReleaseYear" : q.ReleaseYear,
                    "PlotSummary" : q.PlotSummary,
                    "ActorIDs" : actorIDs
                };
                fw.renderData().data( data ).type( 'json' );
            }
            else {
                fw.renderData().data( '' ).type( 'json' ).statusCode( 404 );
            }
        }
        else {
            var q = movieService.getAll();

            var data = q.reduce( function( prev, row ){
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

            // renderData() is a FW/1 utility function to serialize/render data for 
            // REST APIs
            fw.renderData().data( data ).type( 'json');
        }
    }

    public void function post( rc ){

        try {
            var result = movieService.insert( rc.title, rc.rating, rc.releaseyear,
                rc.plotsummary );
                fw.renderData()
                .data( '' )
                .type( 'json' )
                .statusCode( 201 )
                .header( "X-INSERTED-ID", result );
        }
        catch ( any e ) {
            fw.renderData().data( '' ).type( 'json' ).statusCode( 400 );
        }
    }

    /* 
    ** Data for put and patch must be sent in the request as x-www-form-urlencoded 
    ** data with "content-type" header set to "application/x-www-form-urlencoded", 
    ** or as json data with "content-type" header set to "application/json"
    */
    public void function put( rc ){
        if ( !structKeyExists( rc, "title" ) || !structKeyExists( rc, "rating" )
              || !structKeyExists( rc, "releaseyear" ) 
              || !structKeyExists( rc, "plotsummary" ) ) {
            fw.renderData().data( '' ).type( 'json').statusCode( 400 );
            return;
        }

        var q = movieService.getById( rc.id );

        if ( q.recordCount ) {
            try {
                movieService.update( rc.id, rc.title, rc.rating, rc.releaseyear, rc.plotsummary );
                fw.renderData().data( '' ).type( 'json' ).statusCode( 204 );
            }
            catch ( any e ) {
                fw.renderData().data( '' ).type( 'json' ).statusCode( 400 );
            }
        }
    }

    public void function patch( rc ){
        var q = movieService.getById( rc.id );

        if ( q.recordCount ) {
            // if the REST request didn't include all of the movie arguments/fields
            // then supply them from the current database record
            var _title = structKeyExists( rc, "title" ) ? rc.title : q.Title;
            var _rating = structKeyExists( rc, "rating") ? rc.rating : q.Rating;
            var _releaseyear = structKeyExists( rc, "releaseyear") ? rc.releaseyear : q.ReleaseYear;
            var _plotsummary = structKeyExists( rc, "plotsummary") ? rc.plotsummary : q.PlotSummary;

            try {
                movieService.update( rc.id, _title, _rating, _releaseyear, _plotsummary );
                fw.renderData().data( '' ).type( 'json' ).statusCode( 204 );
                }
            catch ( any e ) {
                fw.renderData().data( '' ).type( 'json' ).statusCode( 400 );
            }
        }
        else {
            fw.renderData().data( '' ).type( 'json' ).statusCode( 404 );
        }
    }

    public void function delete( rc ){
        var result = movieService.delete( rc.id );

        if ( result > 0 ) {
            fw.renderData().data( '' ).type( 'json' ).statusCode( 204 );
        }
        else {
            fw.renderData().data( '' ).type( 'json' ).statusCode( 404 );
        }
    }
}