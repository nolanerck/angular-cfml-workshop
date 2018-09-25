<cfsilent>
    <cfparam name="URL.movieid" type="integer" default=0>
    <cfquery name="getMovies">
        SELECT  MovieId
                ,Title
                ,Rating
                ,ReleaseYear
                ,PlotSummary
        FROM tMovies
        WHERE 1=1
        <cfif URL.movieid GT 0>
            AND MovieId = <cfqueryparam value="#URL.movieid#" cfsqltype="integer">
        </cfif>
    </cfquery>

    <cfif getMovies.recordCount>
        <cfset statuscode = "200">
        <cfset statustext = "OK">
        <cfset content = serializeJSON( getMovies, 'struct' )>
    <cfelse>
        <cfset statuscode = "404">
        <cfset statustext = "Not Found">
        <cfset content = "">
    </cfif>
</cfsilent>
<cfcontent type="application/json">
<cfheader statuscode="#statuscode#" statustext="#statustext#">
<cfoutput>#content#</cfoutput>