<h1>Main</h1>
<cfoutput>
    <cfdump var ="#getBeanFactory()#">
    <cfoutput>#getBeanFactory().containsBean( 'actorService' )#</cfoutput>
</cfoutput>