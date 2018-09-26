<cfsilent>
    <cfif NOT StructKeyExists( form, "actorid" )>
        <cfset statuscode="400">
        <cfset statustext="Bad Request">
    <cfelse>
        <cfquery name="checkRecord">
            SELECT ActorID
            FROM tActors
            WHERE ActorID = <cfqueryparam value="#FORM.actorid#" cfsqltype="INTEGER">
        </cfquery>

        <cfif checkRecord.recordCount>
            <cfquery>
                DELETE FROM tActors
                WHERE ActorID = <cfqueryparam value="#FORM.actorid#" cfsqltype="INTEGER">
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
