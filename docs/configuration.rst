.. _configuration-label:

Configuration
=============

For different setups, there can be different configuration files be involved or not. The configurations coming from 
the seb-server-setup repository are listed and documented here by the service they belong to.

.. _seb-sever-configuration-label:

SEB Server Configuration
------------------------

The most important settings for the SEB Server services configurations are located within the .env file and within
the docker-compose.yml file within the respective service configuration.

The .env file contains all environment variables that must be set for a dedicated setup.
Within the docker-compose.yml file the most interesting settings are defined with its default values. If a specific
database connection must be set, this can be done within the docker-compose.yml file.
At last but not least, more specific settings are located in the service specific config directory within the also
service dedicated configuration files. For the Java/Spring services these are the application-prod.properties files.

**SEB Server Webservice Settings**

.. glossary::
    
    logging.level.ROOT
        - The initial log-level for all loggers
        - See `Spring Logging <https://docs.spring.io/spring-boot/docs/2.1.6.RELEASE/reference/html/boot-features-logging.html>`_
        - Default is WARN
    logging.level.ch
        - The initial log-level for a given package - here for all SEB Server packages
        - See `Spring Logging <https://docs.spring.io/spring-boot/docs/2.1.6.RELEASE/reference/html/boot-features-logging.html>`_
        - Default is INFO
    logging.file
        - if defined the SEB Server logs to the specified file
        - See `Spring Logging <https://docs.spring.io/spring-boot/docs/2.1.6.RELEASE/reference/html/boot-features-logging.html>`_
        - Default is /sebserver/log/sebserver.log. Note this path is also used in docker-compose to bind  the log directory to a named volume.
    sebserver.webservice.forceMaster
        - Flag indicating a primary master service instance that claims to be master when active.
        - This can be used in fail-over setups with two SEB Server nodes running, one as the master and another
          as hot-backup. The master should then have this flag set to true to become master again after recovery.
        - Default is false


    sebserver.init.adminaccount.gen-on-init
        - Indicates whether initial admin account creation is on/off
        - If an initial admin account should be created on first startup of the SEB Server this must be set
        - Default is true
    sebserver.init.adminaccount.username
        - Defines the username of the initial admin account.
        - If initial admin account creation is switched on, this is mandatory and defines the username that is created for the initial account.
        - Default is "SEB Server"
    sebserver.init.organisation.name
        - Defines the institution name for of the institution to create for the initial admin account
        - If an initial admin account must be created, we need also an institution to assign this initial account to. This defines the name of that initial institution that is created together with the initial admin account.
        - Default is "sebserver-admin"
    datastore.mariadb.server.address
        - Defines the address of the MariaDB data-store server
        - Usually the data-store is defined in a separated docker container/service and connected within a docker-network. This is usually a docker service name. If the data-store lives on a separated server, this is the server URL
    datastore.mariadb.server.port
        - Defines the port of the MariaDB data-store server
        - Same as datastore.mariadb.server.address
    spring.datasource.username
        - The username for the JDBC account to use to connect to the MariaDB server
        - In a bundled environment with docker, root is default and must not be changed
    spring.datasource.hikari.initializationFailTimeout
    spring.datasource.hikari.connectionTimeout
    spring.datasource.hikari.idleTimeout
    spring.datasource.hikari.maxLifetime
        - Hikari data-base connection pool times and timeouts
        - See `Hakari Documentation <https://github.com/brettwooldridge/HikariCP#configuration-knobs-baby>`_
    spring.datasource.url
        - the JDBC connection URL
        - This mostly is composed from other settings and must not be changed
    spring.datasource.hikari.initializationFailTimeout
    spring.datasource.hikari.connectionTimeout
    spring.datasource.hikari.idleTimeout
    spring.datasource.hikari.maxLifetime
        - Hikari data-base connection pool times and timeouts
        - See `Hakari Documentation <https://github.com/brettwooldridge/HikariCP#configuration-knobs-baby>`_
    spring.datasource.password
        - The password for the database connection
        - This usually is automatically set by the password given from the initial setup process and must not be changed. If there is the need to change this for whatever reason, be aware that it is not secure to give a password in plain test within the configuration and everyone that is able to read the configuration is able to get the password.
    sebserver.webservice.api.admin.clientSecret
        - The secret for the GUI service basic authentication to connect to the webservice; OAuth2
        - This usually is automatically set by the password given from the initial setup process and must not be changed. If there is the need to change this for whatever reason, be aware that it is not secure to give a password in plain test within the configuration and everyone that is able to read the configuration is able to get the password.
    sebserver.webservice.internalSecret
        - The secret that is used for SEB Server internal encryption.
        - This usually is automatically set by the password given from the initial setup process and must not be changed. If there is the need to change this for whatever reason, be aware that it is not secure to give a password in plain test within the configuration and everyone that is able to read the configuration is able to get the password.
    sebserver.webservice.distributed
        - Indicates whether the web-service runs within a distributed environment or as single-bundled server
        - On a distributed environment (multiple running instances with load balancing) this must set to true to ensure internal cache strategies are working correctly on distributed setup.
    sebserver.webservice.http.external.scheme
    sebserver.webservice.http.external.servername
    sebserver.webservice.http.external.port
        - This properties defines the URL on that the SEB Server can be accessed from the public Internet.
        - Set the scheme (http/https) and the server name to the external URL settings of the SEB Server. If the web-service runs on default HTTP/HTTPS ports, the port must not be specified.
    sebserver.webservice.http.redirect.gui
        - Defines the redirection URL/Path to the GUI service.
        - On a single-bundled setup this can stick to the default and for a distributed setup this must define the public URL of the GUI service, where redirects from web-service should point to.
    sebserver.webservice.api.admin.endpoint
    sebserver.webservice.api.admin.accessTokenValiditySeconds
    sebserver.webservice.api.admin.refreshTokenValiditySeconds
        - Defines properties for the admin API access.
        - The admin API access is needed to access the admin API of the web-service. The admin API defines a REST API for all administrative purposes.
    sebserver.webservice.api.exam.endpoint
    sebserver.webservice.api.exam.accessTokenValiditySeconds
    sebserver.webservice.api.exam.endpoint.v1
    sebserver.webservice.api.exam.endpoint.discovery
        - Defines properties for the exam API access.
        - The exam API access is needed to access the exam API of the web-service. The exam API defines a REST API for SEB clients to connect.
    sebserver.webservice.api.exam.enable-indicator-cache
        - Indicates if internal indicator value cache should be used where possible
        - This is usually done on a bundled single instance setup to gain performance. If we have a distributed setup with many SEB Server instances this should be set to false.
        - Default is true
    sebserver.webservice.api.pagination.maxPageSize
        - This defines a maximal page size for the REST API list/page endpoints
        - The maximal page size restricts the page size on the REST API to avoid performance problems by loading all data at once
        - Default is set to 500
    sebserver.webservice.lms.openedx.api.token.request.paths
        - Defines a comma separated list of known Open edX LMS API token request paths.
        - This paths will be used by the web-service to try to connect to a Open edX LMS REST API and request an access token.
        - Default is "/oauth2/access_token"
    sebserver.webservice.lms.moodle.api.token.request.paths
        - Defines a comma separated list of known Moodle LMS API token request paths.
        - This paths will be used by the web-service to try to connect to a Moodle LMS REST API and request an access token.
        - Default is "/login/token.php"


    sebserver.webservice.api.admin.request.limit
        - A general request limit used for request limits on certain API endpoints
        - This uses a bucked-algorithm where each request attempt removes a item from the bucket and if the bucket is empty no request is permittet
          Involved endpoints: user-account-registration
        - Default is 10
    sebserver.webservice.api.admin.request.limit.refill
        - The refill items count for the above request limit
        - Default is 2
    sebserver.webservice.api.admin.request.limit.interval.min
        - The refill interval in minutes for the above request limit
        - Default is 10
    sebserver.webservice.api.admin.create.limit
        - A general object create limit used to prevent exessive object creation (persistent storage)
        - This uses a bucked-algorithm where each creation attempt removes a item from the bucket and if the bucket is empty no object creation is permittet
          Involved endpoints: user-account-registration
        - Default is 10
    sebserver.webservice.api.admin.create.limit.refill
        - The refill items count for the above object creation limit
        - Default is 10
    sebserver.webservice.api.admin.create.limit.interval.min=3600
        - The refill interval in minutes for the above object creation limit
        - Default is 3600


**SEB Server GUI Service Settings**


.. glossary::
    
    sebserver.gui.external.messages
        - Defines the path where SEB Server GUI shall load additional wording files that overrides the internal wording
        - Within the Spring configuration of SEB Server you are able to define a messages_[iso-language-code].properties file where you are able to override the default wording of SEB Server or to provide wording for additional languages.
        - Default is file:/sebserver/config/spring/messages
    sebserver.gui.multilingual
        - Indicates if the multilingual feature is on or off
        - Set this to true if the SEB Server GUI should be multi lingual. You have also to provide additional language files that contains the wording for the supported languages. See **sebserver.gui.external.messages**
        - Default is false (only english is supported)
    sebserver.gui.supported.languages
        - Comma separated list of supported language codes (iso-language code)
        - For example if you want to support the languages English (default) and German use "en,de". See also **sebserver.gui.external.messages** and **sebserver.gui.multilingual**
        - Default is "en"
    sebserver.gui.theme
        - The RAP theme css file that should be used to override the default one
        - Default is css/sebserver.css
    sebserver.gui.list.page.size
        - The default page size of lists in SEB Server GUI
        - Default is set to 20
    sebserver.gui.date.displayformat
        - The locale tag for the display format to use
        - This defines the formatting of dates and numbers within the formatting of the specified location tag
    sebserver.gui.entrypoint
        - The servlet endpoint where the GUI service servlet is located.
    sebserver.gui.webservice.protocol
    sebserver.gui.webservice.address
    sebserver.gui.webservice.port
        - The URL properties to define the URL with that the web service is accessed from the GUI component.
        - On a single-bundled setup this must not be changed since GUI runs on the same server as the web-service and communicates over standard localhost settings. For a distributed environment this must define the URL to the web-service server.
    sebserver.gui.webservice.poll-interval
        - Defines the interval in milliseconds that the GUI service uses to poll the live monitoring data from web-service.
    sebserver.gui.webservice.lms.disable.MOCKUP
        - Indicates whether a mocking LMS for testing should be available in the LMS Setup section or not.
    sebserver.gui.seb.client.config.download.filename
        - Defines the download file name of a SEB client configuration.
    sebserver.gui.seb.exam.config.download.filename
        - Defines the download file name of a SEB exam configuration
    sebserver.gui.http.external.scheme
    sebserver.gui.http.external.servername
    sebserver.gui.http.external.port
        - The URL properties that defines the URL the gui service can be accessed from external
        - On a single-bundled setup this must not be changed since GUI runs on the same server as the web-service and uses the defaults from the web-service

.. _proxy-configuration-label:

Reverse Proxy Configuration
---------------------------

Docker internal SEB Server setup uses a nginx reverse proxy for communication with the host and the Internet. The configuration is placed
in the app.conf file and will be loaded by nginx on startup of the container. The configuration usually has all the pre-settings needed
for working correctly within the specific setup context. If there is the need to have a different configuration for the nginx reverse proxy
we refer to the `nginx configuration documentation <http://nginx.org/en/docs/>`_ 

.. _db-configuration-label:

MariaDB Configuration
---------------------

The MariaDB configuration can be found in the config/mariadb/config.cnf file and the directory config/mariadb is mapped to the directory /etc/mysql/conf.d
of the seb-server-mariadb docker container to be used to override the default MariaDB configuration. This file can be used to configure the MariaDB
that is bundled with SEB Server in the docker-compose setup like a normal MariaDB configuration file. See `MariaDB Configuration <https://mariadb.com/kb/en/configuring-mariadb-with-option-files/>`_ 
for more information on how to configure MariaDB with the options file.

JMX Configuration
-----------------

If you want to have JMX enabled for production environment there is a prepared default configuration in config/jmx/. Please refer to the 
`JMX documentation <https://docs.oracle.com/javadb/10.10.1.2/adminguide/radminjmxenabledisable.html>`_ as well the this `JMX security guide <https://gquintana.github.io/2016/09/01/Securing-remote-JMX.html>`_
You need also the set the JMX_PORT as environment veriable in the docker-compose file to the port you want to use as well as uncomment the port mapping 
the seb-server service of the docker-compose file. And make sure also the right port is set in the jmxremote.properties file.
