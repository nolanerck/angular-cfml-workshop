component extends="taffy.core.api" output="false" {

    variables.dbPath = expandPath( "/database/Derby/" );

    this.name = hash( getCurrentTemplatePath() );
    this.applicationTimeout = CreateTimeSpan( 1, 0, 0, 0 );
    this.sessionManagement = true;
    this.sessionTimeout = CreateTimeSpan( 0, 2, 0, 0 );
    this.sessioncookie.httponly = true;
    this.sessioncookie.timeout = "10";
    this.serialization.preserveCaseForStructKey = true;
    this.passArrayByReference = true;
    this.mappings = {
        "/sharedModel" : expandPath( "../sharedModel" ),
        "/resources" : expandPath( "./resources" ),
        "/taffy" : expandPath( "./taffy" ),
        "/di1" : expandPath( "../v4/framework" )
    };
    this.datasources = {
        Movies = {
            url = "jdbc:derby:#variables.dbPath#;create=true;MaxPooledStatements=300", 
            driver = "Apache Derby Embedded"
        }
    };
    this.datasource = 'Movies';

    variables.framework = {
        debugKey = "debug",
        reloadKey = "reload",
        reloadPassword = "true",
        serializer = "taffy.core.nativeJsonSerializer",
        returnExceptionsAsJson = true,
        docs.APIName = "My Awesome 80's Movies API",
        docs.APIVersion = "1.0.0"
    };

    function onApplicationStart(){
        application.beanFactory = new di1.ioc( [ "/resources", "/sharedModel" ] );
        variables.framework.beanFactory = application.beanFactory;
        return super.onApplicationStart();
    }

    function onRequestStart(TARGETPATH){
        return super.onRequestStart(TARGETPATH);
    }

    // this function is called after the request has been parsed and all request details are known
    function onTaffyRequest(verb, cfc, requestArguments, mimeExt){
        // this would be a good place for you to check API key validity and other non-resource-specific validation
        return true;
    }

}
