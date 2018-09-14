component {
    variables.curPath = Replace( GetDirectoryFromPath( GetCurrentTemplatePath() ), "\", "/", "ALL");
    variables.dbPath = variables.curPath & 'database/Derby/';

    this.name = "Angular-CFML-Workshop";
    this.applicationTimeout = CreateTimeSpan( 1, 0, 0, 0 );
    this.sessionManagement = true;
    this.sessionTimeout = CreateTimeSpan( 0, 2, 0, 0 );
    this.sessioncookie.httponly = true;
    this.sessioncookie.timeout = "10";
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

    public void function onRequest(required string targetPage) { 
        if ( !DirectoryExists( variables.dbPath ) ) {
            include "/database/buildDB.cfm";
            location("/", "false");
        }
        else {
            include arguments.targetPage;
        }
        return; 
    }

}