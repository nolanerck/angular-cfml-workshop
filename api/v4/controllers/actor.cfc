component name="Actor REST Endpoint"  accessors="true" output="false" {
    
    property fw;
    property actorService;
    property movieToActorService;

    public void function default( rc ){
        var q = actorService.getAll();
        var data = [];
        data = q.reduce( function( prev, row ){
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

        // A Framework-One utility method to serialize/render data for REST APIs
        fw.renderData().data( data ).type( 'json' );
    }

    public void function show( rc ){
        // Framework-One automatically finds the id value in the URL and puts it
        // in the rc.id struct key
        var data = "";
        var statusCode = 200;
        var q = actorService.getById( rc.id );

        if ( q.recordCount ) {
            var movieLinks = movieToActorService.getByActorID( rc.id );
            var movieIDs = valueArray( movieLinks, "MovieID" );
            data = {
                "ActorId" : q.ActorID,
                "ActorName" : q.ActorName,
                "BirthDate" : q.BirthDate,
                "BornInCity" : q.BornInCity,
                "MovieIDs" : movieIDs
            };
        }
        else {
            statusCode = 404;
        }
        fw.renderData().data( data ).type( 'json' ).statusCode( statusCode );
    }

    public void function create( rc ){
        var statusCode = 201;
        var result = "";

        try {
            result = actorService.insert( rc.actorname, rc.birthdate, rc.bornincity );
        }
        catch ( any e ) {
            statusCode = 400;
        }

        fw.renderdata().data( result ).type( 'json' ).statusCode( statusCode );
    }

    /* data must be sent as x-www-form-urlencoded data with "content-type" header
    ** set to "application/x-www-form-urlencoded", or as json data with 
    ** "content-type" header set to "application/json"
    */
    public void function update( rc ){
        var result = "";
        var data = "";

        try {
            result = actorService.update( rc.id, rc.actorname, rc.birthdate, rc.bornincity );
            var statusCode = result > 0 ? 204 : 404;
        }
        catch ( any e ) {
            writeDump( var=e, output="console" );
            var statusCode = 400;
        }

        fw.renderdata().data( data ).type( 'json' ).statusCode( statusCode );
    }

    public void function destroy( rc ){
        
    }
}