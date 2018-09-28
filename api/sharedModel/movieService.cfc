<cfcomponent displayname="tMovies database table interactions" output="false">

    <cfset variables.movieToActorService = new movieToActorService()>

    <cffunction name="getAll" access="public" returntype="query">
        <cfset var q = "">

        <cfquery name="q">
            SELECT  MovieID
                    ,Title
                    ,Rating
                    ,ReleaseYear
                    ,PlotSummary
            FROM tMovies
        </cfquery>

        <cfreturn q>
    </cffunction>

    <cffunction name="getById" access="public" returntype="query">
        <cfargument name="id" type="numeric" required="true">
        <cfset var q = "">

        <cfquery name="q">
            SELECT  MovieID
                    ,Title
                    ,Rating
                    ,ReleaseYear
                    ,PlotSummary
            FROM tMovies
            WHERE MovieId = <cfqueryparam value="#arguments.id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfreturn q>
    </cffunction>

    <cffunction name="insert" access="public" returntype="numeric">
        <cfargument name="title" type="string" default="">
        <cfargument name="rating" type="string" default="">
        <cfargument name="releaseyear" type="integer" default="0">
        <cfargument name="plotsummary" type="string" default="">
        <cfset var result = "">

        <cfquery result="result">
            INSERT INTO tMovies
            ( Title, Rating, ReleaseYear, PlotSummary )
            VALUES (
                <cfqueryparam value="#Trim( arguments.title )#" cfsqltype="VARCHAR">,
                <cfqueryparam value="#Trim( arguments.rating )#" cfsqltype="VARCHAR">,
                <cfqueryparam value="#Trim( arguments.releaseyear )#" cfsqltype="INTEGER">,
                <cfqueryparam value="#Trim( arguments.plotsummary )#" cfsqltype="VARCHAR">
            )
        </cfquery>
        <cfreturn result.generatedkey>
    </cffunction>

    <cffunction name="update" access="public" returntype="numeric">
        <cfargument name="id" type="numeric" default="0">
        <cfargument name="title" type="string" default="">
        <cfargument name="rating" type="string" default="">
        <cfargument name="releaseyear" type="integer" default="0">
        <cfargument name="plotsummary" type="string" default="">

        <cfif getById( id ).recordcount GT 0>
            <cfquery>
                UPDATE tMovies
                SET Title = <cfqueryparam value="#Trim( arguments.title )#" cfsqltype="VARCHAR">,
                    Rating = <cfqueryparam value="#Trim( arguments.rating )#" cfsqltype="VARCHAR">,
                    ReleaseYear = <cfqueryparam value="#Trim( arguments.releaseyear )#" cfsqltype="INTEGER">,
                    PlotSummary = <cfqueryparam value="#Trim( arguments.plotsummary )#" cfsqltype="VARCHAR">
                WHERE MovieID = <cfqueryparam value="#arguments.id#" cfsqltype="INTEGER">
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
                UPDATE tMovies
                SET Title = <cfqueryparam value="#Trim( arguments.title )#" cfsqltype="VARCHAR">,
                    Rating = <cfqueryparam value="#Trim( arguments.rating )#" cfsqltype="VARCHAR">,
                    ReleaseYear = <cfqueryparam value="#Trim( arguments.releaseyear )#" cfsqltype="INTEGER">,
                    PlotSummary = <cfqueryparam value="#Trim( arguments.plotsummary )#" cfsqltype="VARCHAR">
                WHERE MovieID = <cfqueryparam value="#arguments.id#" cfsqltype="INTEGER">
            </cfquery>
            <cfreturn arguments.id>
        <cfelseif arguments.id EQ 0>
            <cfset var result = "">
            <cfquery result="result">
                INSERT INTO tMovies
                ( Title, Rating, ReleaseYear, PlotSummary )
                VALUES (
                    <cfqueryparam value="#Trim( arguments.title )#" cfsqltype="VARCHAR">,
                    <cfqueryparam value="#Trim( arguments.rating )#" cfsqltype="VARCHAR">,
                    <cfqueryparam value="#Trim( arguments.releaseyear )#" cfsqltype="INTEGER">,
                    <cfqueryparam value="#Trim( arguments.plotsummary )#" cfsqltype="VARCHAR">
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
                DELETE FROM tMovies
                WHERE MovieID = <cfqueryparam value="#arguments.id#" cfsqltype="INTEGER">
            </cfquery>

            <cfset movieToActorService.delete( movieid = id )>
            <cfreturn 1>
        <cfelse>
            <cfreturn 0>
        </cfif>
    </cffunction>
    
</cfcomponent>