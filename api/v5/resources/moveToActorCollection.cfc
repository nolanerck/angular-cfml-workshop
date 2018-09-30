component extends="taffy.core.resource" taffy:uri="/movieToActor" accessors="true" {

    property movieToActorService;

    public any function get(){

        var q = movieToActorService.getAll();
        var data = q.reduce( function( prev, row ){
            var movieLink = {
                "id" : row.id,
                "MovieID" : row.MovieID,
                "ActorID" : row.ActorID
            };
            return prev.append( movieLink );
        }, []);

        // representationOf() is a Taffy utility function to serialize/render
        // data for REST APIs
        return representationOf( data );
    }

    public any function post( required numeric movieId, required numeric actorId ){

            var data = movieToActorService.insert( movieId, actorId );

        // withHeaders is a Taffy utility method to attach custom 
        return noData().withStatus( 201, "Created" )
            .withHeaders( { "X-INSERTED-ID" : data } );
    }

}