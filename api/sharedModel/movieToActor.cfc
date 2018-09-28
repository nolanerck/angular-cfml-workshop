<cfcomponent displayname="tMoviesToActors database table interactions" output="false">

    <cffunction name="getAll" access="public" returntype="query">
        <cfset var q = "">

        <cfquery name="q">
            SELECT  id
                    ,MovieID
                    ,ActorID
            FROM tMoviesToActors
        </cfquery>

        <cfreturn q>
    </cffunction>


    <cffunction name="getById" access="public" returntype="query">
        <cfargument name="id" type="numeric" required="true">
        <cfset var q = "">
    
        <cfquery name="q">
            SELECT  id
                    ,MovieID
                    ,ActorID
            FROM tMoviesToActors
            WHERE id = <cfqueryparam value="#arguments.id#">
        </cfquery>
    
        <cfreturn q>
    </cffunction>

    <cffunction name="getByMovieId" access="public" returntype="query">
        <cfargument name="id" type="numeric" required="true">
        <cfset var q = "">

        <cfquery name="q">
            SELECT  id
                    ,MovieID
                    ,ActorID
            FROM tMoviesToActors
            WHERE MovieID = <cfqueryparam value="#arguments.id#">
        </cfquery>

        <cfreturn q>
    </cffunction>

    <cffunction name="getByActorId" access="public" returntype="query">
        <cfargument name="id" type="numeric" required="true">
        <cfset var q = "">

        <cfquery name="q">
            SELECT  id
                    ,MovieID
                    ,ActorID
            FROM tMoviesToActors
            WHERE ActorID = <cfqueryparam value="#arguments.id#">
        </cfquery>

        <cfreturn q>
    </cffunction>

    <cffunction name="insert" access="public" returntype="numeric">
        <cfargument name="movieid" type="numeric" required="true">
        <cfargument name="actorid" type="numeric" required="true">
        <cfset var result = "">

        <cfquery result="result">
            INSERT INTO tMoviesToActors
            ( MovieID, ActorID )
            VALUES (
                <cfqueryparam value="#arguments.movieid#" cfsqltype="INTEGER">,
                <cfqueryparam value="#arguments.actorid#" cfsqltype="INTEGER">
            )
        </cfquery>
        <cfreturn result.generatedkey>
    </cffunction>

    <cffunction name="delete" access="public" returntype="numeric">
        <cfargument name="id" type="numeric" default=0>
        <cfargument name="movieid" type="numeric" default=0>
        <cfargument name="actorid" type="numeric" default=0>

        <cfif id EQ 0 AND movieid EQ 0 AND actorid EQ 0>
            <cfreturn -1>
        </cfif>
        <cfset var linkExists = (
            getById( id ).recordcount +
            getByMovieId( movieid ).recordcount +
            getByActorId( actorid ).recordcount
        ) GT 0>
        <cfif linkExists>
            <cfquery>
                DELETE FROM tMoviesToActors
                WHERE 1=0 OR
                <cfif id GT 0>
                    id = <cfqueryparam value="#id#" cfsqltype="INTEGER">
                <cfelseif movieid GT 0 AND actorid EQ 0>
                    movieid = <cfqueryparam value="#movieid#" cfsqltype="INTEGER">
                <cfelseif actorid GT 0 AND movieid EQ 0>
                    actorid = <cfqueryparam value="#actorid#" cfsqltype="INTEGER">
                <cfelse>
                    ( 
                        movieid = <cfqueryparam value="#movieid#" cfsqltype="INTEGER">
                        AND
                        actorid = <cfqueryparam value="#actorid#" cfsqltype="INTEGER">
                    )
                </cfif>
            </cfquery>
            <cfreturn 1>
        <cfelse>
            <cfreturn 0>
        </cfif>
    </cffunction>

</cfcomponent>