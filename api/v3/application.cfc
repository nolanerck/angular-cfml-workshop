component {
    variables.dbPath = expandPath( "/database/Derby/" );

    this.name = hash( getBaseTemplatePath() );
    this.applicationTimeout = CreateTimeSpan( 1, 0, 0, 0 );
    this.sessionManagement = true;
    this.sessionTimeout = CreateTimeSpan( 0, 2, 0, 0 );
    this.sessioncookie.httponly = true;
    this.sessioncookie.timeout = "10";
    this.serialization.preserveCaseForStructKey = true;
    this.passArrayByReference = true;
    this.mappings = { "/model" : expandPath( "../sharedModel" ) };
    this.datasources = {
        Movies = {
            url = "jdbc:derby:#variables.dbPath#;create=true;MaxPooledStatements=300", 
            driver = "Apache Derby Embedded"
        }
    };
    this.datasource = 'Movies';


    public boolean function onApplicationStart() { 
        return true; 
    } 

}