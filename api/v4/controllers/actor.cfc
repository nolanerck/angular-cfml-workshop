component name="Actor REST Endpoint"  accessors="true" output="false" {

    // FW/1 will use its dependency injection framework (DI/1) to find and
    // inject the components defined below as properties
    property fw;
    property actorService;
    property movieToActorService;

    public void function default( rc ){
        var q = actorService.getAll();

        var data = q.reduce( function( prev, row ){
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

        // renderData() is a FW/1 utility function to serialize/render data for 
        // REST APIs
        fw.renderData().data( data ).type( 'json');
    }

    public void function show( rc ){
        // If FW/1 is configured with routes, it will automatically find the 
        // id value in the URL and put it in the rc.id struct key
        var q = actorService.getById( rc.id );

        if ( q.recordCount ) {
            var movieLinks = movieToActorService.getByActorID( rc.id );
            var movieIDs = valueArray( movieLinks, "MovieID" );
            var data = {
                "ActorId" : q.ActorID,
                "ActorName" : q.ActorName,
                "BirthDate" : q.BirthDate,
                "BornInCity" : q.BornInCity,
                "MovieIDs" : movieIDs
            };
            
            fw.renderData().data( data ).type( 'json' );
        }
        else {
            fw.renderData().data( '' ).type( 'json' ).statusCode( 404 );
        }
    }

    public void function create( rc ){

        try {
            var result = actorService.insert( rc.actorname, rc.birthdate, rc.bornincity );
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
    ** Data must be sent in the request as x-www-form-urlencoded data with 
    ** "content-type" header set to "application/x-www-form-urlencoded", or as 
    ** json data with "content-type" header set to "application/json"
    */
    public void function update( rc ){
        var q = actorService.getById( rc.id );

        if ( q.recordCount ) {
            // if the REST request didn't include all of the actor arguments/fields
            // then supply them from the current database record
            rc.actorname = structKeyExists( rc, "actorname" ) ? rc.actorname : q.actorname;
            rc.birthdate = structKeyExists( rc, "birthdate") ? rc.birthdate : q.birthdate;
            rc.bornincity = structKeyExists( rc, "bornincity") ? rc.bornincity : q.bornincity;

            try {
                actorService.update( rc.id, rc.actorname, rc.birthdate, rc.bornincity );
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

    public void function destroy( rc ){
        var result = actorService.delete( rc.id );

        if ( result > 0 ) {
            fw.renderData().data( '' ).type( 'json' ).statusCode( 204 );
        }
        else {
            fw.renderData().data( '' ).type( 'json' ).statusCode( 404 );
        }
    }
}