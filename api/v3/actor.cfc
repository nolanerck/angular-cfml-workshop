<cfcomponent displayname="Actor web service" output="true">

    <cfset variables.actorService = new sharedModel.actorService()>
    <cfset variables.movieToActorService = new sharedModel.movieToActorService()>

    <cffunction name="getActor" access="remote" returntype="array" returnformat="JSON">
        <cfargument name="actorid" type="numeric" default="0">
        <cfset var q = "">
        <cfset var data = ArrayNew(1)>

        <cfif actorid EQ 0>
            <cfset q = actorService.getAll()>
        <cfelse>
            <cfset q = actorService.getById( arguments.actorid )>
        </cfif>

        <cfif q.recordCount>
            <cfloop query="q">
                <cfset var actor = StructNew()>
                <cfset var movieLinks = movieToActorService.getByActorId( q.ActorID )>
                <cfset var movieIds = valueArray( movieLinks, "MovieID" )>

                <cfset actor[ "ActorID" ] = q.ActorID>
                <cfset actor[ "ActorName" ] = q.ActorName>
                <cfset actor[ "BirthDate" ] = q.BirthDate>
                <cfset actor[ "BornInCity" ] = q.BornInCity>
                <cfset actor[ "MovieIDs"] = movieIds>

                <cfset arrayAppend( data, actor )>
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

    <cffunction name="addActor" access="remote" returntype="string" returnformat="JSON">
        <cfargument name="actorname" type="string" default="">
        <cfargument name="birthdate" type="date" default="#Now()#">
        <cfargument name="bornincity" type="string" default="">
        <cfset var data = actorService.insert( arguments.actorname, 
            arguments.birthdate, arguments.bornincity )>

        <cfcontent type="application/json">
        <cfheader statuscode="201" statustext="Created">
        <cfreturn data>
    </cffunction>

    <cffunction name="updateActor" access="remote" returntype="string" returnformat="JSON">
        <cfargument name="actorid" type="numeric" default="0">
        <cfargument name="actorname" type="string" default="">
        <cfargument name="birthdate" type="date" default="#Now()#">
        <cfargument name="bornincity" type="string" default="">
        <cfset var data = "">

        <cfif actorid GT 0>
            <cfset var result = actorService.update( arguments.actorid, arguments.actorname,
                arguments.birthdate, arguments.bornincity )>
            <cfif result GT 0>
                <cfset statuscode = "204">
                <cfset statustext = "No content">
            <cfelse>
                <cfset statuscode = "404">
                <cfset statustext = "Not Found">
                <cfset data = "No actor with that id exists.">
            </cfif>
        <cfelse>
            <cfset statuscode = "400">
            <cfset statustext = "Bad Request">
            <cfset data = "The actorid argument is missing or invalid.">
        </cfif>

        <cfcontent type="application/json">
        <cfheader statuscode="#statuscode#" statustext="#statustext#">
        <cfreturn data>
    </cffunction>

    <cffunction name="deleteActor" access="remote" returntype="string" returnformat="JSON">
        <cfargument name="actorid" type="numeric" default="0">
        <cfset var data = "">

        <cfif actorid GT 0>
            <cfset var result = actorService.delete( arguments.actorid )>
            <cfif result GT 0>
                <cfset statuscode = "204">
                <cfset statustext = "No content">
            <cfelse>
                <cfset statuscode = "404">
                <cfset statustext = "Not Found">
                <cfset data = "No actor with that id exists.">
            </cfif>
        <cfelse>
            <cfset statuscode = "400">
            <cfset statustext = "Bad Request">
            <cfset data = "The actorid argument is missing or invalid.">
        </cfif>

        <cfcontent type="application/json">
        <cfheader statuscode="#statuscode#" statustext="#statustext#">
        <cfreturn data>
    </cffunction>

</cfcomponent>