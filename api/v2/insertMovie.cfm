<cfsilent>
    <cfparam name="FORM.title" type="string" default="">
    <cfparam name="FORM.rating" type="string" default="">
    <cfparam name="FORM.releaseyear" type="integer" default=0>
    <cfparam name="FORM.plotsummary" type="string" default="">
    <cfquery result="result">
        INSERT INTO tMovies
        ( Title, Rating, ReleaseYear, PlotSummary )
        VALUES (
            <cfqueryparam value="#Trim( FORM.title )#" cfsqltype="VARCHAR">,
            <cfqueryparam value="#Trim( FORM.rating )#" cfsqltype="VARCHAR">,
            <cfqueryparam value="#Trim( FORM.releaseyear )#" cfsqltype="INTEGER">,
            <cfqueryparam value="#Trim( FORM.plotsummary )#" cfsqltype="VARCHAR">
        )
    </cfquery>
    <cfset newId = result.generatedkey>
</cfsilent>
<cfcontent type="application/json">
<cfheader statuscode="201" statustext="Created">
<cfoutput>#newId#</cfoutput>