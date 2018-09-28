<cfcomponent displayname="MovieToActor web service" output="true">

    <cfset variables.movieToActorService = new sharedModel.movieToActorService()>

    <cffunction name="getMovieToActor" access="remote" returntype="array" returnformat="JSON">
        <cfargument name="id" type="numeric" default="0">
        <cfset var q = "">
        <cfset var data = ArrayNew(1)>

        <cfif id EQ 0>
            <cfset q = movieToActorService.getAll()>
        <cfelse>
            <cfset q = movieToActorService.getById( arguments.id )>
        </cfif>

        <cfif q.recordCount>
            <cfloop query="q">
                <cfset var link = StructNew()>

                <cfset link[ "id" ] = q.id>
                <cfset link[ "MovieID" ] = q.MovieID>
                <cfset link[ "ActorID" ] = q.ActorID>

                <cfset arrayAppend( data, link )>
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

    <cffunction name="addMovieToActor" access="remote" returntype="string" returnformat="JSON">
        <cfargument name="movieid" type="numeric" default="0">
        <cfargument name="actorid" type="numeric" default="0">
        <cfset var data = movieToActorService.insert( arguments.movieid, arguments.actorid )>

        <cfcontent type="application/json">
        <cfheader statuscode="201" statustext="Created">
        <cfreturn data>
    </cffunction>

    <cffunction name="deleteMovieToActor" access="remote" returntype="string" returnformat="JSON">
        <cfargument name="id" type="numeric" default="0">
        <cfargument name="movieid" type="numeric" default="0">
        <cfargument name="actorid" type="numeric" default="0">
        <cfset var data = "">

        <cfif id LTE 0 AND movieid LTE 0 AND actorid LTE 0>
            <cfset statuscode = "400">
            <cfset statustext = "Bad Request">
            <cfset data = "One or more arguments are missing or invalid.">
        <cfelse>
            <cfif id GT 0>
                <cfset var result = movieToActorService.delete( id = arguments.id )>
            <cfelseif movieid GT 0 AND actorid GT 0>
                <cfset var result = movieToActorService.delete( movieid = arguments.movieid,
                    actorid = arguments.actorid )>
            <cfelseif movieid GT 0>
                <cfset var result = movieToActorService.delete( movieid = arguments.movieid )>
            <cfelse>
                <cfset var result = movieToActorService.delete( actorid = arguments.actorid )>
            </cfif>
            <cfif result GT 0>
                <cfset statuscode = "204">
                <cfset statustext = "No content">
            <cfelse>
                <cfset statuscode = "404">
                <cfset statustext = "Not Found">
                <cfset data = "No MovieToActor with that id exists.">
            </cfif>
        </cfif>

        <cfcontent type="application/json">
        <cfheader statuscode="#statuscode#" statustext="#statustext#">
        <cfreturn data>
    </cffunction>

</cfcomponent>