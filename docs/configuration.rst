.. _configuration-label:

Configuration
=============

For different setups, there can be different configuration files be involved or not. The configurations coming from 
the seb-server-setup repository are listed and documented here by the service they belong to.

.. _seb-sever-configuration-label:

SEB Server Configuration
------------------------

**Spring application configuration**

This is the usual spring application properties file, may be named with a setup specific related suffix 
like '_demo' or '_prod' in the file name. This property file contains all configurable settings for the 
SEB Server in as name/value pair settings. Have a look at the following table to find more information 
to each relevant setting.

The settings can be divided into three categories, global settings, gui-service settings and web-service settings.
If the SEB Server is deployed as stand-alone server then all the properties are in one properties file with the
setup specific related suffix. If the gui and the web-service is deployed separately there will be two property files
one for the gui server containing the global settings and all gui-service related settings and one for the webservice
with also the global settings and all webservice related settings.

**Global Settings**

.. list-table::
    :name: SEB Server Global Settings
    :widths: 200 100 100
    :header-rows: 1
    
    * - Property Name
      - Description
      - Info
    * - file.encoding
      - Defines the standard encoding
      - Default is 'UTF-8'
    * - server.address
      - The IP address the SEB Server binds to
      - Usually set to 0.0.0.0 for docker internal communication
    * - server.port
      - The port the SEB Server listen to (HTTP/HTTPS). 
      - Usually this is set to 8080 and the reverse proxy deals with mapping and TLS
    * - server.servlet.context-path
      - The context path where the servers entry-point is mapped to
      - For default this is the root '/'
    * - logging.level.ch
      - The initial log-level for a given package
      - See `Spring Logging <https://docs.spring.io/spring-boot/docs/2.1.6.RELEASE/reference/html/boot-features-logging.html>`_
    * - logging.file
      - if defined the SEB Server logs to the specified file
      - See `Spring Logging <https://docs.spring.io/spring-boot/docs/2.1.6.RELEASE/reference/html/boot-features-logging.html>`_
    * - security.require-ssl
      - Set true if the SEB Server shall deal with TLS
      - | Usually a reverse proxy deals with TLS. SEB Server is able to do it also by it's own 
        | but needs more effort. It is recommended to delegate the TLS handling to a reverse proxy
        
        
**Webservice Settings**

.. list-table::
    :name: SEB Server Webservice Settings
    :widths: 200 100 100
    :header-rows: 1
    
    * - Property Name
      - Description
      - Info
    * - datastore.mariadb.server.address
      - Defines the address of the MariaDB data-store server
      - | Usually the data-store is defined in a separated docker container/service and connected within a docker-network.
        | So this is usually a docker service name. If the data-store lives on a separated server, this is the server URL
    * - datastore.mariadb.server.port
      - Defines the port of the MariaDB data-store server
      - Same as datastore.mariadb.server.address
    * - spring.datasource.username
      - The username for the JDBC account to use to connect to the MariaDB server
      - 
    * - spring.datasource.url
      - the JDBC connection URL 
      - This mostly is composed from other settings and must not be changed
    * - | spring.datasource.hikari.initializationFailTimeout
        | spring.datasource.hikari.connectionTimeout
        | spring.datasource.hikari.idleTimeout
        | spring.datasource.hikari.maxLifetime
      - Hikari data-base connection pool times and timeouts
      - See `Hakari Documentation <https://github.com/brettwooldridge/HikariCP#configuration-knobs-baby>`_

**Webservice Settings**

**GUI Service Settings**

.. _proxy-configuration-label:

Reverse Proxy Configuration
---------------------------

TODO

.. _db-configuration-label:

MariaDB Configuration
---------------------

TODO