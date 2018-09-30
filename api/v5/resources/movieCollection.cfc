component extends="taffy.core.resource" taffy:uri="/movie" accessors="true" {

    property movieService;
    property movieToActorService;

    public any function get(){

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

        // representationOf() is a Taffy utility function to serialize/render
        // data for REST APIs
        return representationOf( data );
    }

    public any function post( required string title, required string rating,
          required numeric releaseYear, required string plotSummary ){

            var data = movieService.insert( title, rating, releaseYear, plotSummary );

        // withHeaders is a Taffy utility method to attach custom 
        return noData().withStatus( 201, "Created" )
            .withHeaders( { "X-INSERTED-ID" : data } );
    }

}