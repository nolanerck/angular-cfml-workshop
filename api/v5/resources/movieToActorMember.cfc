component extends="taffy.core.resource" taffy:uri="/movieToActor/{id}" 
      accessors="true" {

    property movieToActorService;

    public any function get( required numeric id ){

        var q = movieToActorService.getById( id );

        if ( q.recordcount ) {
            var data = {
                "id" : q.id,
                "MovieID" : q.MovieID,
                "ActorID" : q.ActorID
            };

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

    public any function delete( required numeric id ){
        var result = movieToActorService.delete( id );

        return result > 0 ? noData().withStatus( 204, "No Content" )
            : noData().withStatus( 404, "Not Found" );
    }

}