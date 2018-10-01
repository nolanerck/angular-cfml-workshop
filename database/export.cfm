<cfscript>
    path = reverse( listRest( reverse( getDirectoryFromPath( getCurrentTemplatePath() ) ), '\' ) );
    path &= '\api\v1\';
    getMovies = queryExecute( "SELECT * FROM tMovies" );
    data = getMovies.reduce( function( prev, row ){
        var movie = {
            "MovieId" : row.MovieID,
            "Title" : row.Title,
            "Rating" : row.Rating,
            "ReleaseYear" : row.ReleaseYear,
            "PlotSummary" : row.PlotSummary
        };
        return prev.append( movie );
    }, []);
    fileWrite( path & 'movies.json', serializeJSON( data ), 'utf-8' );

    getActors = queryExecute( "SELECT * FROM tActors" );
    data = getActors.reduce( function( prev, row ){
        var actor = {
            "ActorId" : row.ActorID,
            "ActorName" : row.ActorName,
            "BirthDate" : row.BirthDate,
            "BornInCity" : row.BornInCity
        };
        return prev.append( actor );
    }, []);
    fileWrite( path & 'actors.json', serializeJSON( data ), 'utf-8' );

    getMoviesToActors = queryExecute( "SELECT * FROM tMoviesToActors" );
    data = getMoviesToActors.reduce( function( prev, row ){
        var movieLink = {
            "id" : row.id,
            "MovieID" : row.MovieID,
            "ActorID" : row.ActorID
        };
        return prev.append( movieLink );
    }, []);
    fileWrite( path & 'moviesToActors.json', serializeJSON( data ), 'utf-8' );
</cfscript>
