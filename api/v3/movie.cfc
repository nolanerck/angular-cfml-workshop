<cfcomponent displayname="Movie web service" output="true">

    <cfset variables.movieService = new model.movie()>

    <cffunction name="getMovie" access="remote" returntype="array" returnformat="JSON">
        <cfargument name="movieid" type="numeric" default="0">
        <cfset var q = "">
        <cfset var data = ArrayNew(1)>

        <cfif movieid EQ 0>
            <cfset q = movieService.getAll()>
        <cfelse>
            <cfset q = movieService.getById( arguments.movieid )>
        </cfif>

        <cfif q.recordCount>
            <cfloop query="q">
                <cfset var row = StructNew()>
                <cfset row[ "MovieID" ] = q.MovieID>
                <cfset row[ "Title" ] = q.Title>
                <cfset row[ "Rating" ] = q.Rating>
                <cfset row[ "ReleaseYear" ] = q.ReleaseYear>
                <cfset row[ "PlotSummary" ] = q.PlotSummary>
                <cfset arrayAppend( data, row )>
            </cfloop>
            <cfset statuscode = "200">
            <cfset statustext = "OK">
        <cfelse>
            <cfset statuscode = "404">
            <cfset statustext = "Not Found">
        </cfif>
        <cfcontent type="application/json">
        <cfheader statuscode="#statuscode#" statustext="#statustext#">
        <cfreturn data>
    </cffunction>

    <cffunction name="addMovie" access="remote" returntype="string" returnformat="JSON">
        <cfargument name="title" type="string" default="">
        <cfargument name="rating" type="string" default="">
        <cfargument name="releaseyear" type="integer" default="0">
        <cfargument name="plotsummary" type="string" default="">
        <cfset var data = movieService.insert( arguments.title, 
            arguments.rating, arguments.releaseyear, arguments.plotsummary )>

        <cfcontent type="application/json">
        <cfheader statuscode="201" statustext="Created">
        <cfreturn data>
    </cffunction>

    <cffunction name="updateMovie" access="remote" returntype="string" returnformat="JSON">
        <cfargument name="movieid" type="numeric" default="0">
        <cfargument name="title" type="string" default="">
        <cfargument name="rating" type="string" default="">
        <cfargument name="releaseyear" type="integer" default="0">
        <cfargument name="plotsummary" type="string" default="">
        <cfset var data = "">

        <cfif movieid GT 0>
            <cfset var result = movieService.update( arguments.movieid, arguments.title, 
                arguments.rating, arguments.releaseyear, arguments.plotsummary )>
            <cfif result GT 0>
                <cfset statuscode = "204">
                <cfset statustext = "No content">
            <cfelse>
                <cfset statuscode = "404">
                <cfset statustext = "Not Found">
                <cfset data = "No movie with that id exists.">
            </cfif>
        <cfelse>
            <cfset statuscode = "400">
            <cfset statustext = "Bad Request">
            <cfset data = "The movieid argument is missing or invalid.">
        </cfif>

        <cfcontent type="application/json">
        <cfheader statuscode="#statuscode#" statustext="#statustext#">
        <cfreturn data>
    </cffunction>

    <cffunction name="deleteMovie" access="remote" returntype="string" returnformat="JSON">
        <cfargument name="movieid" type="numeric" default="0">
        <cfset var data = "">

        <cfif movieid GT 0>
            <cfset var result = movieService.delete( arguments.movieid )>
            <cfif result GT 0>
                <cfset statuscode = "204">
                <cfset statustext = "No content">
            <cfelse>
                <cfset statuscode = "404">
                <cfset statustext = "Not Found">
                <cfset data = "No movie with that id exists.">
            </cfif>
        <cfelse>
            <cfset statuscode = "400">
            <cfset statustext = "Bad Request">
            <cfset data = "The movieid argument is missing or invalid.">
        </cfif>

        <cfcontent type="application/json">
        <cfheader statuscode="#statuscode#" statustext="#statustext#">
        <cfreturn data>
    </cffunction>

</cfcomponent>