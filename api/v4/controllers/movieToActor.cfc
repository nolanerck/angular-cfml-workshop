component name="MovieToActor REST Endpoint"  accessors="true" output="false" {

    // FW/1 will use its dependency injection framework (DI/1) to find and
    // inject the components defined below as properties
    property fw;
    property movieToActorService;

    public void function get( rc ){
        if ( structKeyExists( rc, "id" ) ){
            var q = movieToActorService.getById( rc.id );

            if ( q.recordCount ) {
                var data = {
                    "id" : q.id,
                    "MovieID" : q.MovieID,
                    "ActorID" : q.ActorID
                };
    
                fw.renderData().data( data ).type( 'json' );
            }
            else {
                fw.renderData().data( '' ).type( 'json' ).statusCode( 404 );
            }
        }
        else {
            var q = movieToActorService.getAll();

            var data = q.reduce( function( prev, row ){
                var movieLink = {
                    "id" : row.id,
                    "MovieID" : row.MovieID,
                    "ActorID" : row.ActorID
                };
                return prev.append( movieLink );
            }, []);

            // renderData() is a FW/1 utility function to serialize/render data for 
            // REST APIs
            fw.renderData().data( data ).type( 'json');
        }
    }

    public void function post( rc ){

        try {
            var result = movieToActorService.insert( rc.movieid, rc.actorid );
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

    public void function put( rc ){
        fw.renderData().data( '' ).type( 'json' ).statusCode( 405 );
    }

    public void function patch( rc ){
        fw.renderData().data( '' ).type( 'json' ).statusCode( 405 );
    }

    public void function delete( rc ){
        var result = movieToActorService.delete( rc.id );

        if ( result > 0 ) {
            fw.renderData().data( '' ).type( 'json' ).statusCode( 204 );
        }
        else {
            fw.renderData().data( '' ).type( 'json' ).statusCode( 404 );
        }
    }

}