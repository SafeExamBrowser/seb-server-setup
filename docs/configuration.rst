.. _configuration-label:

Configuration
=============

For different setups, there can be different configuration files be involved or not. The configurations coming from 
the seb-server-setup repository are listed and documented here by the service they belong to.

SEB Server Configuration
------------------------

**Spring application configuration**

This is the usual spring application properties file, may be named with a setup specific related suffix 
like '_demo' or '_prod' in the file name. This property file contains all configurable settings for the 
SEB Server in as name/value pair settings. Have a look at the following table to find more information 
to each relevant setting.

.. list-table::
    :name: SEB Server Configuration Properties
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
      - The port the SEB Server listen to (HTTP/HTTPS)
      - Usually this is set to 8080 and the reverse proxy deals with mapping and TLS




Reverse Proxy Configuration
---------------------------

TODO

MariaDB Configuration
---------------------

TODO