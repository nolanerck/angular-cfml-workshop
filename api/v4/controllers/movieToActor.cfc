component name="MovieToActor REST Endpoint"  accessors="true" output="false" {

    // FW/1 will use its dependency injection framework (DI/1) to find and
    // inject the components defined below as properties
    property fw;
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
        var q = movieToActorService.getAll();

        rc.data = q.reduce( function( prev, row ){
            var movieLink = {
                "id" : row.id,
                "MovieID" : row.MovieID,
                "ActorID" : row.ActorID
            };
            return prev.append( movieLink );
        }, []);
    }

    public void function show( rc ){
        // If FW/1 is configured with routes, it will automatically find the 
        // id value in the URL and put it in the rc.id struct key
        var q = movieToActorService.getById( rc.id );

        if ( q.recordCount ) {
            rc.data = {
                "id" : q.id,
                "MovieID" : q.MovieID,
                "ActorID" : q.ActorID
            };
        }
        else {
            rc.statusCode = 404;
        }
    }

    public void function create( rc ){

        try {
            rc.data = movieToActorService.insert( rc.movieid, rc.actorid );
            rc.statusCode = 201;
        }
        catch ( any e ) {
            rc.statusCode = 400;
        }
    }

    public void function update( rc ){
        rc.statusCode = 405;
    }

    public void function destroy( rc ){

        try {
            var result = movieToActorService.delete( rc.id );
            rc.statusCode = result > 0 ? 204 : 404;
        }
        catch ( any e ) {
            rc.statusCode = 400;
        }
    }

}