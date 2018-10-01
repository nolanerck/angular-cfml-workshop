component extends="framework.one" output="false" {
    
    variables.dbPath = expandPath( "/database/Derby/" );

    this.name = hash( getCurrentTemplatePath() );
    this.applicationTimeout = CreateTimeSpan( 1, 0, 0, 0 );
    this.sessionManagement = true;
    this.sessionTimeout = CreateTimeSpan( 0, 2, 0, 0 );
    this.sessioncookie.httponly = true;
    this.sessioncookie.timeout = "10";
    this.serialization.preserveCaseForStructKey = true;
    this.passArrayByReference = true;
    this.mappings = { "/sharedModel" : expandPath( "../sharedModel" ) };
    this.datasources = {
        Movies = {
            url = "jdbc:derby:#variables.dbPath#;create=true;MaxPooledStatements=300", 
            driver = "Apache Derby Embedded"
        }
    };
    this.datasource = 'Movies';

    // FW/1 settings
    variables.framework = {
        action = 'action',
        defaultSection = 'main',
        defaultItem = 'default',
        reloadApplicationOnEveryRequest = true,
        generateSES = true,
        SESOmitIndex = true,
        diEngine = "di1",
        diComponent = "framework.ioc",
        diLocations = [ "/model", "/controllers", "/sharedModel" ],
        diConfig = { },
        /*
        ** This bit here maps standard REST API URL paths to the actual controllers
        ** and methods within this Framework-One application.  It will also parse
        ** the url and identify the id value being passed in the URL.
        ** See http://framework-one.github.io/documentation/4.2/developing-applications.html#url-routes
        ** for more information.
        */
        routes = [ 
            { "$RESOURCES" = "actor,movie,movieToActor" }
        ],
        resourceRouteTemplates = [
            { method = 'get', httpMethods = [ '$GET' ] },
            { method = 'post', httpMethods = [ '$POST' ] },
            { method = 'get', httpMethods = [ '$GET' ], includeId = true },
            { method = 'put', httpMethods = [ '$PUT' ], includeId = true },
            { method = 'patch', httpMethods = [ '$PATCH' ], includeId = true },
            { method = 'delete', httpMethods = [ '$DELETE' ], includeId = true },
            { method = 'options', httpMethods = [ '$OPTIONS' ] },
            { method = 'error', httpMethods = [ '$*' ] }
        ],
        /* 
        ** The decodeRequestBody setting allows FW/1 to accept JSON data or URL-encoded 
        ** form data for POST, PUT and PATCH actions. 
        ** See http://framework-one.github.io/documentation/4.2/developing-applications.html#controllers-for-rest-apis
        ** for more information.
        */
        decodeRequestBody = true,
        /*
        ** The preflightOptions setting allows FW/1 to respond to OPTIONS requests,
        ** which many front-end applications will call before doing POST/PUT/PATCH/DELETE
        ** requests.
        */
        preflightOptions = false
    };

    public void function setupSession() {  }

    public void function setupRequest() {  }

    public void function setupView() {  }

    public void function setupResponse() {  }

    public string function onMissingView(struct rc = {}) {
        return "Error 404 - Page not found.";
    }
}