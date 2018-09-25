<cfsilent>
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
                DELETE FROM tMovies
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
