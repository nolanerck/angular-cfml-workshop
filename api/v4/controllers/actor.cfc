component name="Actor REST Endpoint"  accessors="true" output="false" {
    
    property fw;
    property actorService;
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
        var q = actorService.getAll();

        rc.data = q.reduce( function( prev, row ){
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
    }

    public void function show( rc ){
        // If FW/1 is configured with routes, it will automatically find the 
        // id value in the URL and put it in the rc.id struct key
        var q = actorService.getById( rc.id );

        if ( q.recordCount ) {
            var movieLinks = movieToActorService.getByActorID( rc.id );
            var movieIDs = valueArray( movieLinks, "MovieID" );
            rc.data = {
                "ActorId" : q.ActorID,
                "ActorName" : q.ActorName,
                "BirthDate" : q.BirthDate,
                "BornInCity" : q.BornInCity,
                "MovieIDs" : movieIDs
            };
        }
        else {
            rc.statusCode = 404;
        }
    }

    public void function create( rc ){

        try {
            rc.data = actorService.insert( rc.actorname, rc.birthdate, rc.bornincity );
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
        var q = actorService.getById( rc.id );
            
        // if the REST request didn't include all of the actor arguments/fields
        // then supply them from the current database record
        rc.actorname = structKeyExists( rc, "actorname" ) ? rc.actorname : q.actorname;
        rc.birthdate = structKeyExists( rc, "birthdate") ? rc.birthdate : q.birthdate;
        rc.bornincity = structKeyExists( rc, "bornincity") ? rc.bornincity : q.bornincity;

        try {
            var result = actorService.update( rc.id, rc.actorname, rc.birthdate, rc.bornincity );
            rc.statusCode = result > 0 ? 204 : 404;
        }
        catch ( any e ) {
            rc.statusCode = 400;
        }
    }

    public void function destroy( rc ){

        try {
            var result = actorService.delete( rc.id );
            rc.statusCode = result > 0 ? 204 : 404;
        }
        catch ( any e ) {
            rc.statusCode = 400;
        }
    }
}