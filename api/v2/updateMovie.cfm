<cfsilent>
    <cfparam name="FORM.title" type="string" default="">
    <cfparam name="FORM.rating" type="string" default="">
    <cfparam name="FORM.releaseyear" type="integer" default=0>
    <cfparam name="FORM.plotsummary" type="string" default="">

    <cfif NOT StructKeyExists( form, "movieid" )>
        <cfset statuscode="400">
        <cfset statustext="Bad Request">
    <cfelse>
        <cfquery name="checkRecord">
            SELECT MovieID
            FROM tMovies
            WHERE MovieID = <cfqueryparam value="#FORM.movieid#" cfsqltype="INTEGER">
        </cfquery>

        <cfif checkRecord.recordCount>
            <cfquery>
                UPDATE tMovies
                SET Title = <cfqueryparam value="#Trim( FORM.title )#" cfsqltype="VARCHAR">,
                    Rating = <cfqueryparam value="#Trim( FORM.rating )#" cfsqltype="VARCHAR">,
                    ReleaseYear = <cfqueryparam value="#Trim( FORM.releaseyear )#" cfsqltype="INTEGER">,
                    PlotSummary = <cfqueryparam value="#Trim( FORM.plotsummary )#" cfsqltype="VARCHAR">
                WHERE MovieID = <cfqueryparam value="#FORM.movieid#" cfsqltype="INTEGER">
            </cfquery>
            <cfset statuscode="204">
            <cfset statustext = "No Content">
        <cfelse>
            <cfset statuscode="404">
            <cfset statustext = "Not Found">
        </cfif>
    </cfif>
</cfsilent>
<cfcontent type="application/json">
<cfheader statuscode="#statuscode#" statustext="#statustext#">
