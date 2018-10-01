<cfsilent>
    <cfparam name="FORM.actorname" type="string" default="">
    <cfparam name="FORM.birthdate" type="date" default="#Now()#">
    <cfparam name="FORM.bornincity" type="string" default="">

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
                UPDATE tActors
                SET ActorName = <cfqueryparam value="#Trim( FORM.actorname )#" cfsqltype="VARCHAR">,
                    BirthDate = <cfqueryparam value="#Trim( FORM.birthdate )#" cfsqltype="DATE">,
                    BornInCity = <cfqueryparam value="#Trim( FORM.bornincity )#" cfsqltype="VARCHAR">
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
