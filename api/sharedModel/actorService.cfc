<cfcomponent displayname="tActors database table interactions" output="false">

    <cfset variables.movieToActorService = new movieToActorService()>

    <cffunction name="getAll" access="public" returntype="query">
        <cfset var q = "">

        <cfquery name="q">
            SELECT  ActorID
                    ,ActorName
                    ,BirthDate
                    ,BornInCity
            FROM tActors
        </cfquery>

        <cfreturn q>
    </cffunction>

    <cffunction name="getById" access="public" returntype="query">
        <cfargument name="id" type="numeric" required="true">
        <cfset var q = "">

        <cfquery name="q">
            SELECT  ActorID
                    ,ActorName
                    ,BirthDate
                    ,BornInCity
            FROM tActors
            WHERE ActorID = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn q>
    </cffunction>

    <cffunction name="insert" access="public" returntype="numeric">
        <cfargument name="actorname" type="string" default="">
        <cfargument name="birthdate" type="date" default="">
        <cfargument name="bornincity" type="string" default="">
        <cfset var result = "">

        <cfquery result="result">
            INSERT INTO tActors
            ( ActorName, BirthDate, BornInCity )
            VALUES (
                <cfqueryparam value="#Trim( arguments.actorname )#" cfsqltype="VARCHAR">,
                <cfqueryparam value="#Trim( arguments.birthdate )#" cfsqltype="DATE">,
                <cfqueryparam value="#Trim( arguments.bornincity )#" cfsqltype="VARCHAR">
            )
        </cfquery>
        <cfreturn result.generatedkey>
    </cffunction>

    <cffunction name="update" access="public" returntype="numeric">
        <cfargument name="id" type="numeric" default="0">
        <cfargument name="actorname" type="string" default="">
        <cfargument name="birthdate" type="date" default="">
        <cfargument name="bornincity" type="string" default="">

        <cfif getById( id ).recordcount GT 0>
            <cfquery>
                UPDATE tActors
                SET ActorName = <cfqueryparam value="#Trim( arguments.actorname )#" cfsqltype="VARCHAR">,
                    BirthDate = <cfqueryparam value="#Trim( arguments.birthdate )#" cfsqltype="DATE">,
                    BornInCity = <cfqueryparam value="#Trim( arguments.bornincity )#" cfsqltype="VARCHAR">
                WHERE ActorID = <cfqueryparam value="#arguments.id#" cfsqltype="INTEGER">
            </cfquery>
            <cfreturn arguments.id>
        <cfelse>
            <cfreturn -1>
        </cfif>
    </cffunction>

    <!---  Instead of using separate "insert" and "update" functions, you can
            combine them in a single "save" function --->
    <cffunction name="save" access="public" returntype="numeric">
        <cfargument name="id" type="numeric" default="0">
        <cfargument name="title" type="string" default="">
        <cfargument name="rating" type="string" default="">
        <cfargument name="releaseyear" type="integer" default="0">
        <cfargument name="plotsummary" type="string" default="">
        
        <cfif arguments.id GT 0 AND getById( id ).recordcount GT 0>
            <cfquery>
                UPDATE tActors
                SET ActorName = <cfqueryparam value="#Trim( arguments.actorname )#" cfsqltype="VARCHAR">,
                    BirthDate = <cfqueryparam value="#Trim( arguments.birthdate )#" cfsqltype="DATE">,
                    BornInCity = <cfqueryparam value="#Trim( arguments.bornincity )#" cfsqltype="VARCHAR">
                WHERE ActorID = <cfqueryparam value="#arguments.id#" cfsqltype="INTEGER">
            </cfquery>
            <cfreturn arguments.id>
        <cfelseif arguments.id EQ 0>
            <cfset var result = "">
            <cfquery result="result">
                INSERT INTO tActors
                ( ActorName, BirthDate, BornInCity )
                VALUES (
                    <cfqueryparam value="#Trim( arguments.actorname )#" cfsqltype="VARCHAR">,
                    <cfqueryparam value="#Trim( arguments.birthdate )#" cfsqltype="DATE">,
                    <cfqueryparam value="#Trim( arguments.bornincity )#" cfsqltype="VARCHAR">
                )
            </cfquery>
            <cfreturn result.generatedkey>
        <cfelse>
            <cfreturn -1>
        </cfif>
    </cffunction>

    <cffunction name="delete" access="public" returntype="numeric">
        <cfargument name="id" type="numeric" required="true">

        <cfif getById( id ).recordcount GT 0>
            <cfquery>
                DELETE FROM tActors
                WHERE ActorID = <cfqueryparam value="#arguments.id#" cfsqltype="INTEGER">
            </cfquery>

            <cfset movieToActorService.delete( actorid = id )>
            <cfreturn 1>
        <cfelse>
            <cfreturn 0>
        </cfif>
    </cffunction>
    
</cfcomponent>