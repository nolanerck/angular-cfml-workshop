<!DOCTYPE html>
<html lang="en">
    <head>
        <cfinclude template="/includes/header.cfm">
        <title>Angular + CFML</title>
    </head>
    <body role="document">
        <div class="container" role="main">
            <div id="home" class="page-header">
                <ol class="breadcrumb">
                    <li class="active">
                        Home
                    </li>
                </ol>
                <h1>CFSummit Preconference Workshop</h1>
                <h2>Angular + CFML</h2>
                <h3>Nolan Erck and Carl Von Stetten</h3>
                <p>
                    Your ColdFusion API server is now ready to accept requests!
                </p>
                <ul>
                    <li>API V1 - JSON files (/api/v1/)
                        <ul>
                            <li><a href="/api/v1/actors.json">actors.json</a></li>
                            <li><a href="/api/v1/movies.json">movies.json</a></li>
                            <li><a href="/api/v1/moviesToActors.json">moviesToActors.json</a></li>
                        </ul>
                    </li>
                    <li>API V2 - CFM files (/api/v2/)
                        <ul>
                            <li><a href="/api/v2/selectActor.cfm">selectActor.cfm</a></li>
                            <li>insertActor.cfm</li>
                            <li>updateActor.cfm</li>
                            <li>deleteActor.cfm</li>
                            <li><a href="/api/v2/selectMovie.cfm">selectMovie.cfm</a></li>
                            <li>insertMovie.cfm</li>
                            <li>updateMovie.cfm</li>
                            <li>deleteMovie.cfm</li>
                        </ul>
                    </li>
                    <li>API V3 - CFC files with "remote" methods (/api/v3/)
                        <ul>
                            <li><a href = "/api/v3/actor.cfc?method=getActor">actor.cfc?method=getActor</a></li>
                            <li>actor.cfc?method=addActor</li>
                            <li>actor.cfc?method=updateActor</li>
                            <li>actor.cfc?method=deleteActor</li>
                            <li><a href = "/api/v3/movie.cfc?method=getMovie">movie.cfc?method=getMovie</a></li>
                            <li>movie.cfc?method=addMovie</li>
                            <li>movie.cfc?method=updateMovie</li>
                            <li>movie.cfc?method=deleteMovie</li>
                            <li><a href = "/api/v3/movieToActor.cfc?method=getMovieToActor">movieToActor.cfc?method=getMovieToActor</a></li>
                            <li>movieToActor.cfc?method=addMovieToActor</li>
                            <li>movieToActor.cfc?method=deleteMovieToActor</li>
                        </ul>
                    </li>
                    <li>API V4 - FW/1 REST controllers (/api/v4/)
                        <ul>
                            <li>/actor</li>
                            <li>/movie</li>
                            <li>/movieToActor</li>
                        </ul>
                    </li>
                    <li>API V5 - Taffy REST resources (/api/v5/)
                        <ul>
                            <li>/actor</li>
                            <li>/movie</li>
                            <li>/movieToActor</li>
                            <li><a href="/api/v5">REST API Dashboard</a></li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
        <cfinclude template="/includes/footer.cfm">
    </body>
</html>
