<cfsilent>
    <cfparam name="FORM.actorname" type="string" default="">
    <cfparam name="FORM.birthdate" type="date" default="">
    <cfparam name="FORM.bornincity" type="string" default="">
    <cfquery result="result">
        INSERT INTO tActors
        ( ActorName, BirthDate, BornInCity )
        VALUES (
            <cfqueryparam value="#Trim( FORM.actorname )#" cfsqltype="VARCHAR">,
            <cfqueryparam value="#Trim( FORM.birthdate )#" cfsqltype="DATE">,
            <cfqueryparam value="#Trim( FORM.bornincity )#" cfsqltype="VARCHAR">
        )
    </cfquery>
    <cfset newId = result.generatedkey>
</cfsilent>
<cfcontent type="application/json">
<cfheader statuscode="201" statustext="Created">
<cfoutput>#newId#</cfoutput>