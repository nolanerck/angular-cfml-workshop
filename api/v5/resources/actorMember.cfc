component extends="taffy.core.resource" taffy:uri="/actor/{actorId}" accessors="true" {

    property actorService;
    property movieToActorService;

    public any function get( required numeric actorId ){

        var q = actorService.getById( actorId );

        if ( q.recordcount ) {
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
        else {
            // noData() and withStatus() are Taffy utility methods you can use
            // when you don't want to actually return data, and want to send a
            // specific HTTP status code
            return noData().withStatus( 404, "Not Found" );
        }
    }

    /*
    public any function post( required string actorName, required date birthDate,
          required string bornInCity ){

            var data = actorService.insert( actorName, birthDate, bornInCity );

        // withHeaders is a Taffy utility method to attach custom 
        return noData().withStatus( 201, "Created" )
            .withHeaders( { "X-INSERTED-ID" : data } );
    }
    */

    public any function put( required numeric actorId, required string actorName, 
          required date birthDate, required string bornInCity ){

        var q = actorService.getById( actorId );

        if ( q.recordcount ) {
            actorService.update( actorId, actorName, birthDate, bornInCity );

            return noData().withStatus( 204, "No Content" );
        }
        else {
            return noData().withStatus( 404, "Not Found" );
        }
    }

    public any function patch( required numeric actorId, string actorName, 
          date birthDate, string bornInCity ){

        var q = actorService.getById( actorId );

        if ( q.recordcount ) {
            // if the REST request didn't include all of the actor arguments/fields
            // then supply them from the current database record
            var _actorName = !isNull( actorName ) ? actorName : q.ActorName;
            var _birthDate = !isNull( birthDate ) ? birthDate : q.BirthDate;
            var _bornInCity = !isNull( bornInCity ) ? bornInCity : q.BornInCity;

            actorService.update( actorId, _actorName, _birthDate, _bornInCity );

            return noData().withStatus( 204, "No Content" );
        }
        else {
            return noData().withStatus( 404, "Not Found" );
        }
    }

    public any function delete( required numeric actorId ){
        var result = actorService.delete( actorId );

        return result > 0 ? noData().withStatus( 204, "No Content" )
            : noData().withStatus( 404, "Not Found" );
    }

}