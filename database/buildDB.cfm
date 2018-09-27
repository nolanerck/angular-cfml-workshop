<!DOCTYPE html>
<cfsetting requestTimeOut = "120">
<cfscript>
    function isStructValueNull ( required struct strc, required string key ) {
        return ListFind( StructKeyList( strc ), key ) && !StructKeyExists( strc, key );
    }

    function createDatabase() {
        var SQL = "";
        
        SQL =  "CREATE TABLE tMovies (
                    MovieID INT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 26, INCREMENT BY 1) CONSTRAINT tMovies_PK PRIMARY KEY
                    ,Title VARCHAR(100) 
                    ,Rating VARCHAR(10)
                    ,ReleaseYear SMALLINT
                    ,PlotSummary VARCHAR(1000) 
                )";
        
        queryExecute( SQL );

        SQL =  "CREATE TABLE tActors (
                    ActorID INT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 85, INCREMENT BY 1) CONSTRAINT tActors_PK PRIMARY KEY
                    ,ActorName VARCHAR(100)
                    ,BirthDate DATE
                    ,BornInCity VARCHAR(100)
                )";

        queryExecute( SQL );

        SQL = "CREATE TABLE tMoviesToActors (
                    id INT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 113, INCREMENT BY 1) CONSTRAINT tMoviesToActors_PK PRIMARY KEY
                    ,MovieID INT
                    ,ActorID INT
                )";

        queryExecute( SQL );

        var curPath = Replace( GetDirectoryFromPath( GetCurrentTemplatePath() ), "\", "/", "ALL");
        var jsonPath = reverse( listRest( reverse( curPath ), "/" ) ) & '/api/v1/';

        var movies = deserializeJSON( fileRead( jsonPath & 'movies.json', 'utf-8' ) );
        movies.each( function( movie ) {
            queryExecute(
                "INSERT INTO tMovies
                ( MovieId, Title, Rating, ReleaseYear, PlotSummary )
                VALUES ( :movieid, :title, :rating, :releaseyear, :plotsummary )",
                {
                    movieid = { value = movie.MovieID, cfsqltype = 'INTEGER' },
                    title = { value = movie.Title, cfsqltype = 'VARCHAR' },
                    rating = { value = movie.Rating, cfsqltype = 'VARCHAR' },
                    releaseyear = { value = movie.ReleaseYear, cfsqltype = 'INTEGER' },
                    plotsummary = { value = movie.PlotSummary, cfsqltype = 'VARCHAR' }
                }
            );
        });
        var actors = deserializeJSON( fileRead( jsonPath & 'actors.json', 'utf-8' ) );
        actors.each( function ( actor ) {
            queryExecute(
                "INSERT INTO tActors
                ( ActorId, ActorName, BirthDate, BornInCity )
                VALUES ( :actorid, :actorname, :birthdate, :bornincity )",
                {
                    actorid = { value = actor.ActorID, cfsqltype = 'INTEGER' },
                    actorname = { value = actor.ActorName, cfsqltype = 'VARCHAR' },
                    birthdate = { value = actor.BirthDate, cfsqltype = 'DATE' },
                    bornincity = { value = actor.BornInCity, cfsqltype = 'VARCHAR' }
                }
            );
        });
        var moviesToActors = deserializeJSON( fileRead( jsonPath & 'moviesToActors.json', 'utf-8' ) );
        moviesToActors.each( function ( movieToActor ) {
            queryExecute(
                "INSERT INTO tMoviesToActors
                ( id, MovieID, ActorID )
                VALUES ( :id, :movieid, :actorid )",
                {
                    id = { value = movieToActor.id, cfsqltype = 'INTEGER' },
                    movieid = { value = movieToActor.MovieID, cfsqltype = 'INTEGER' },
                    actorid = { value = movieToActor.ActorID, cfsqltype = 'INTEGER' }
                }
            );
        });
    }
</cfscript>

<html lang="en">
    <head>
        <cfinclude template="/includes/header.cfm">
        <title>Angular CFML Workshop</title>
    </head>
    <body role="document">
        <div class="container" role="main">
            <div id="home" class="page-header">
                <ol class="breadcrumb">
                    <li class="active">
                        Home
                    </li>
                </ol>
                <h1>CFSummit 2018 Preconference Workshop</h1>
                <h2>Angular + CFML</h2>
                <h3>Nolan Erck and Carl Von Stetten</h3>
            </div>
            <p>
                The database for this application is being constructed.  Please 
                wait a few seconds.
            </p>
            <i class="fa fa-cog fa-spin fa-3x fa-fw"></i>
            <span class="sr-only">Loading...</span>
        </div>
        <cfflush>
        <cfset createDatabase()>
        <script>
            location.reload(true);
        </script>
        <cfflush>
    </body>
</html>
