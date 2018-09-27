<cfsilent>
    <cfparam name="URL.actorid" type="integer" default=0>
    <cfquery name="getActors">
        SELECT  ActorID
                ,ActorName
                ,BirthDate
                ,BornInCity
        FROM tActors
        WHERE 1=1
        <cfif URL.actorid GT 0>
            AND ActorID = <cfqueryparam value="#URL.actorid#" cfsqltype="integer">
        </cfif>
    </cfquery>

    <cfif getActors.recordCount>
        <cfset statuscode = "200">
        <cfset statustext = "OK">
        <cfset content = serializeJSON( getActors, 'struct' )>
    <cfelse>
        <cfset statuscode = "404">
        <cfset statustext = "Not Found">
        <cfset content = "">
    </cfif>
</cfsilent>
<cfcontent type="application/json">
<cfheader statuscode="#statuscode#" statustext="#statustext#">
<cfoutput>#content#</cfoutput>