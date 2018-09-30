component extends="taffy.core.resource" taffy:uri="/movie/{movieId}" accessors="true" {

    property movieService;
    property movieToActorService;

    public any function get( required numeric movieId ){

        var q = movieService.getById( movieId );

        if ( q.recordcount ) {
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

        // representationOf() is a Taffy utility function to serialize/render
        // data for REST APIs
        return representationOf( data );
        }
        else {
            // noData() and withStatus() are Taffy utility methods you can use
            // when you don't want to actually return data, and want to send a
            // specific HTTP status code
            return noData().withStatus( 404, "Not Found" );
        }
    }

    /*
    public any function post( required string title, required string rating,
          required numeric releaseYear, required string plotSummary ){

            var data = movieService.insert( title, rating, releaseYear, plotSummary );

        // withHeaders is a Taffy utility method to attach custom 
        return noData().withStatus( 201, "Created" )
            .withHeaders( { "X-INSERTED-ID" : data } );
    }
    */

    public any function put( required numeric movieId, required string title, 
          required string rating, required numeric releaseYear, 
          required string plotSummary ){

        var q = movieService.getById( movieId );

        if ( q.recordcount ) {
            movieService.update( movieId, title, rating, releaseYear, plotSummary );

            return noData().withStatus( 204, "No Content" );
        }
        else {
            return noData().withStatus( 404, "Not Found" );
        }
    }

    public any function patch( required numeric movieId,  string title, string rating,
          numeric releaseYear, string plotSummary ){

        var q = movieService.getById( movieId );

        if ( q.recordcount ) {
            // if the REST request didn't include all of the actor arguments/fields
            // then supply them from the current database record
            var _title = !isNull( title ) ? title : q.Title;
            var _rating = !isNull( rating ) ? rating : q.Rating;
            var _releaseYear = !isNull( releaseYear ) ? releaseYear : q.ReleaseYear;
            var _plotSummary = !isNull( plotSummary ) ? plotSummary : q.PlotSummary;

            movieService.update( movieId, _title, _rating, _releaseYear, _plotSummary );

            return noData().withStatus( 204, "No Content" );
        }
        else {
            return noData().withStatus( 404, "Not Found" );
        }
    }

    public any function delete( required numeric movieId ){
        var result = movieService.delete( movieId );

        return result > 0 ? noData().withStatus( 204, "No Content" )
            : noData().withStatus( 404, "Not Found" );
    }

}