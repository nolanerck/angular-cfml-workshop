component extends="taffy.core.resource" taffy:uri="/actor" accessors="true" {

    property actorService;
    property movieToActorService;

    public any function get(){

        var q = actorService.getAll();
        var data = data = q.reduce( function( prev, row ){
            var movieLinks = movieToActorService.getByActorID( row.ActorID );
            var movieIDs = valueArray( movieLinks, "MovieID" );
            var actor = {
                "ActorId" : row.ActorID,
                "ActorName" : row.ActorName,
                "BirthDate" : row.BirthDate,
                "BornInCity" : row.BornInCity,
                "MovieIDs" : movieIDs
            };
            return prev.append( actor );
        }, []);

        // representationOf() is a Taffy utility function to serialize/render
        // data for REST APIs
        return representationOf( data );
    }

    public any function post( required string actorName, required date birthDate,
          required string bornInCity ){

            var data = actorService.insert( actorName, birthDate, bornInCity );

        // withHeaders is a Taffy utility method to attach custom 
        return noData().withStatus( 201, "Created" )
            .withHeaders( { "X-INSERTED-ID" : data } );
    }

}