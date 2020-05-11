Installation
============

All provided setups are pre-configured docker-compose setups that suppose to work well with a general installation process and fit with
usual IT environment. The setups are mainly categorized into bundled setups and distributed setups where a bundled setup is a single
docker-compose setup that bundles all services together within one machine and an internal docker-network. A distributed setup may contain
different docker-compose configuration to set up SEB Server in a distributed environment like a cloud service for example.

**Docker Compose for bundled setup**

A docker compose configuration for a bundled setup looks pretty much the same for each setup and consists of four services:

- **seb-server-setup** This service is just to setup everything in advanced and uses a Docker container for that runs a some
 initial actions to bind the volumes and copy the initial password, make it internally available by also deleting it from the hosts
 file system. And probably some other needed commands that presets things for the specific setup. 
 
- **mariadb** This is the MariaDB service that is bound to the internal network as well as exposing its default port to the host
 network by default. This service uses the official "mariadb/server:10.3" image for the service and the configuration that is provided
 within the config/mariadb7 folder. The MariaDB container is started with the given internal password as the root password. This service
 uses a separated named docker volume to store the data (seb-server-mariadb). 
 
.. note::
    The named volume of the MariaDB service is not mapped to the host file system for default. 
    If you have to do so, for backup and restore procedure for example, you can configure this within the docker-compose setup.
 
- **seb-server** This is the main server service that starts the Spring-Boot application within the container. This service uses the 
 configuration in the folder: config/spring. The server is bound only to the internal docker network on port 8080 for default and also
 connect to the database within the internal docker network that is created with the docker-compose setup (seb-server-network). The service
 uses a separated named volume for logging as well (seb-server-logs). To install, update or down-grade to a particular SEB Server version
 you can set the SEBSERVER_VERSION attribute.
 
.. note::
    The SEBSERVER_VERSION attribute relates on a Git tag of the seb-server repository (without the "v" prefix). Usually you want to point to 
    the exact version of the SEB Server by using `sematic versioning <https://semver.org/>`_ like 1.0.0 or 1.0.1 or you can set the latest
    minor version to always get the latest specific minor version with all patches on installation or update. If you want the latest minor version
    use version tags like 1.0-latest or 1.1-latest.
 
- **reverse-proxy** This service uses a nginx server as reverse-proxy to connect the bundle to the host network. In a basic setup this 
 usually just maps the host HTTP port (80) to the internal HTTP port (8080). In a setup with end to end TLS this service is used to manage
 the TLS part and must be provided with the certificate(s) to use. The configuration of the proxy service is located in the folder confg/nginx/
 
**Docker Compose for distributed setup**
 
Default setups for distributed environments to install SEB Server as a cloud service for example are not provided yet. You can use the pre-defined components
from a bundled setup and adapt and use it for your distributed environments. Please also contact a system administrator or cloud administrator
of your company/institution to find a solution that fits best within your needs and given IT environment. If you have questions or need help / report bugs, 
please use the `issue tracker <https://github.com/SafeExamBrowser/seb-server-setup/issues>`_  on Github for reporting.

**HTTPS / TLS Configuration**

There are manly two strategies to configure HTTPS / TLS for a SEB Server;

    - The HTTPS / TLS is handled by a reverse-proxy that is exposed to the Internet and forwards the requests over HTTP to the SEB Server that in this
    case has only an simple HTTP connector and is not exposed to the Internet but to the internal network with the reverse proxy
    - The HTTPS / TLS is handled by the SEB Server itself (end to end). 
    
    .. note:: 
    
        It is highly recommended to use the first approach here that is easier to install then the end to end approach. 
    There are some prepared installations for the second approach within the seb-server-setup repository (tls) but they are experimental yet

General Installation Process
-----------------------------

First we will have a look at the overall installation process that can be applied to all bundled installation strategies we have discussed 
in section :ref:`installation-repo-label`. 
The endpoint root of every sub-directory of an installation strategies has the same structure and contains docker files, docker compose 
configurations and various configuration files within the "config" sub-directory.

This is an example structure of an installation strategy sub-directory. The installation directory docker/testing/basic/ in this case 
provides a setup for testing with a mariadb service, a seb-server single instance service and a reverse proxy service that is bundled and
exposed to the host network by the proxy

::
    
    - docker/testing/basic/   (this is the endpoint root directory for testing setup of a single server instance with no TLS)
        - config
            - mariadb
                config.cnf
            - nginx
                 app.config
            - spring
                application.properties
                messages_en.properties
        docker-compose.yml
        sebserver.Dockerfile
        setup.Dockerfile
        
The docker based installation typically is composed of a config directory with all the related config files, one or more docker-files that
defines images for installation related services and a docker-compose file that bundles all together. Configuration files as well as 
docker files are pre-configured in a way that a minimum of additional settings has to be done to setup the service. Usually you have to define 
the external URL on witch the service will be available in the spring application-[].properties configuration. And you have to create a file
with the internal password before starting up the server. In more advanced setups, also more pre-settings may be needed, for a TLS based 
setup for example, you have to replace the self signed certificates (that are only for example) with your own certificates. 

A usual installation process for SEB Server mostly look something like the following:

1. Connect to the remote host where the SEB Server instance has to be installed 
    
2. Install Git and Docker on the remote host if not already installed.
    
    .. note::
    
        The newest versions of Git and Docker are recommended. For installation see:
            |    - Git : https://www.atlassian.com/git/tutorials/install-git
            |    - Docker : https://docs.docker.com/install/
            |    - Docker-Compose : https://docs.docker.com/compose/install/
    
3. In the installation directory of your choice clone the seb-server-setup repository of desired version from guthub.
    
4. Navigate into the installation strategy sub-directory you want to install from and edit/prepare the configuration for your needs.
    
5. Build the docker images with docker-compose build.
    
6. Bring the docker containers up and running with docker-compose up, and do some suggested health checks.

General Update Process
-----------------------

If this initial setup has bin done once, it is possible to update to a newer SEB Server version (or down-grade) by applying the following steps:

- Stop the services with *docker-compose down*.

- Open the *docker-compose.yml* and set the *SEBSERVER_VERSION* argument from the sebserver service to the version you want to have.

- Do some additional configuration changes if needed.

- Rebuild the image with the new SEB Server version with *docker-compose build --no-cache*

- Restart the services with *docker-compose up -d*

Next part describes this process in detail for all supported installation strategies and also gives a service overview for a
specific installation strategy.


Demo
----

**Info:**

This setup provides a single, unsecured SEB Server setup for demonstrations and testing. Includes a single SEB Server instance and a single MariaDB server instance running both in a docker-container. 
With the default configuration, the MariaDB server is exposed on port 3306 and the SEB Server on port 8080.

::

        installation strategy sub-directory.........docker/demo/
        seb-server configuration....................docker/demo/config/spring
        single server setup.........................true
        secured (TLS)...............................false
        integrated mariadb service..................true
        initial data setup..........................demo data
        data setup on reload........................demo data
        integrated reverse proxy....................false
        automated backup-restore service............false
        exposed database port.......................3306
        exposed JMX port............................9090


**Requirements:**

- Git installation if not already installed
- Docker installation if not already installed

.. note::

    The newest versions of Git and Docker are recommended. For installation see:
        |    - Git : https://www.atlassian.com/git/tutorials/install-git
        |    - Docker : https://docs.docker.com/install/
        |    - Docker-Compose : https://docs.docker.com/compose/install/
    
**Setup:**

The docker setup consists of a Dockerfile that defines and builds an image for the SEB Server and a docker-compose.yml file that orchestrate the setup of the needed containers/services. 
The build of the image for SEB Server first clones the defines version of the SEB Server source repository form GitHub and build the SEB Server with Maven that leads to a self-contained, spring-boot-based, 
jar artifact that will be run with a usual java command on container startup. For MariaDB the defined public image is been used to build-up the MariaDB server service.

**Configuration**

There is only the SEB Server Spring configuration in place so far for the Demo setup. See :ref:`configuration-label`.

**Installation:**

1. Login to the target/remote host where the SEB Server demo shall be installed, on windows open a command or PowerShell, create a working directory and navigate into it.
    
    .. code-block:: bash
    
        $ mkdir sebserver
        $ cd sebserver
        
2. Get a clone of the seb-server-setup repository and navigate to the demo setup folder

    .. code-block:: bash
    
        $ git clone https://github.com/SafeExamBrowser/seb-server-setup.git
        $ cd seb-server-setup/docker/demo

3. If some specific configuration is needed, this can be done within this step. See :ref:`configuration-label`. for more details on how to configure the services

4. build the docker images. 

    .. code-block:: bash
    
        $ docker-compose build --no-cache

5. Start the services. 

    .. code-block:: bash
    
        $ docker-compose up -d
        
6. Check if the containers are started and running. There should be two containers running; seb-server and seb-server-mariadb. 
You can also check the logs of individual container

    .. code-block:: bash
    
        $ docker ps --all
        $ docker logs ${container name}
        
7. If there where no changes to the default configuration the SEB Server is now running on port 8080 and can be accessed with a browser on http://server-address:8080/. 
There is one pre-configured institution (ETH Zürich) and one user-account with all roles to manage the server. 
The username of the initial account is always "super-admin" and the password is "admin". After successful startup you will see a message like
the following within the SEB Server log file.

::

    [SEB SERVER INIT] ---->   ___  ___  ___   ___
    [SEB SERVER INIT] ---->  / __|| __|| _ ) / __| ___  _ _ __ __ ___  _ _ 
    [SEB SERVER INIT] ---->  \__ \| _| | _ \ \__ \/ -_)| '_|\ V // -_)| '_|
    [SEB SERVER INIT] ---->  |___/|___||___/ |___/\___||_|   \_/ \___||_|  
    [SEB SERVER INIT] ---->
    [SEB SERVER INIT] ----> SEB Server successfully started up!
    ...
    [SEB SERVER INIT] ----> SEB Server initial admin-account: ...
    
.. note::

    Since this is a demo installation it may not be necessary but we highly recommend to change the generated password from the initial admin account immediately after first login. 
    
**Update**

.. include:: service-update.rst
        
**Backup**

.. include:: service-backup.rst


Testing
-------

**Info:**

This setup provides currently two different setups, one with no HTTPS/TLS configuration at all "basic" and another with end to end HTTPS/TLS configuration and self-signed certificates "selfsigned". 
The setup without HTTPS/TLS configuration can be used for testing without TLS in place at all or within an internal infrastructure that has already a reverse proxy that handles TLS encryption.
The "selfsigned" setup is currently in construction and highly experimental. Because of that this setup is not described.

Basic Setup
...........

The testing basic setup comes with a webservice and GUI-service bundled single server setup defined in the usual sebserver.Docker file, a simple and integrated MariaDB setup that uses just the official
MariaDB Docker image, and a reverse proxy using the official nginx:latest Docker image. There is also a initial setup service that is defined in setup.Dockerfile and that in this case does only the 
initial password handling that is needed in the initial setup. And all is bundled together within the docker-compose.yml configuration file.

::

        installation strategy sub-directory.........docker/testing/basic/
        seb-server configuration....................docker/testing/basic/config/spring
        maria-db configuration......................docker/prod/bundled/basic/config/mariadb
        reverse-proxy configuration.................docker/testing/basic/config/nginx
        single server setup.........................true
        secured (TLS)...............................false
        integrated mariadb service..................true
        initial data setup..........................auto generated Institution and SEB Administrator
        data setup on reload........................none
        integrated reverse proxy....................true
        automated backup-restore service............false
        exposed database port.......................3306
        exposed JMX port............................9090
        
**Requirements:**

- Git installation if not already installed
- Docker installation if not already installed

.. note::

    The newest versions of Git and Docker are recommended. For installation see:
        |    - Git : https://www.atlassian.com/git/tutorials/install-git
        |    - Docker : https://docs.docker.com/install/
        |    - Docker-Compose : https://docs.docker.com/compose/install/
        
**Setup:**

The docker setup consists of two docker-files, "sebserver.Docker" that defines and builds an image for the SEB Server, "setup.Docker" that defines the initial setup job and a docker-compose.yml file that orchestrate the setup of the needed containers/services. 
The build of the image for SEB Server first clones the defines version of the SEB Server source repository form GitHub and build the SEB Server with Maven that leads to a self-contained, spring-boot-based, 
jar artifact that will be run with a usual java command on container startup. For MariaDB the defined public image is been used to build-up the MariaDB server service.

**Configuration**

There is the SEB Server Spring configuration in place: ref:`seb-server-configuration-label` as well as a reverse-proxy configuration: ref:`proxy-configuration-label`

**Installation:**

1. Login to the target/remote host where the SEB Server demo shall be installed, on windows open a command or PowerShell, create a working directory and navigate into it.
    
    .. code-block:: bash
    
        $ mkdir sebserver
        $ cd sebserver
        
2. Get a clone of the seb-server-setup repository and navigate to the demo setup folder

    .. code-block:: bash
    
        $ git clone https://github.com/SafeExamBrowser/seb-server-setup.git
        $ cd seb-server-setup/docker/testing/basic/

3. If some specific configuration is needed, this can be done within this step. See:ref:`configuration-label`. for more details on how to configure the services
   At least you should check the application-prod.properties file in the spring config directory, if everything is set properly.
   
   .. note::
        Check that the spring configuration properties "sebserver.webservice.http.external.*" are set correctly
        to the URL where the SEB Server can be accessed from the public.

4. build the docker images. 

    .. code-block:: bash
    
        $ docker-compose build --no-cache

    .. note::
    
        This step can be skipped if the images are already build with the right version.
        
5. Now we have to give a password that is internally used to create a data base account as well as to secure internal sensitive data.
The initial password must be set by creating a text file named "secret" with no extension and placed directly in the "config" sub-folder.
In this file the password must be written in plain text with no line brakes. Once the docker services started up the file will be copied 
into an internal docker volume and automatically deleted from the external config directory. The file can be created from the command line 
with for example : printf %s "somePassword" >> secret. Or if the password should not appear in the command-line history, 
just create the file and edit it with a text editor of your choice.

    .. code-block:: bash
    
        $ cd config
        $ printf %s "somePassword" >> secret
        $ cd ..

    .. note::
        
            This step usually must only be done once on the initial setup of the service. On a service update this is not needed and the
            password that was given by the initial setup remains
            
            This password can be used to connect directly to the database that is created with the service and should be remembered by an administrator.

6. Start the services. 

    .. code-block:: bash
    
        $ docker-compose up -d
        
7. Check if the containers are started and running. The output should look something like the following.

    .. code-block:: bash
    
        $ docker ps --all
        $ docker logs ${container name}
        
    .. image:: images/dockerServicesTestUp.png
        :align: center
        :target: https://raw.githubusercontent.com/SafeExamBrowser/seb-server-setup/master/docs/images/dockerServicesTestUp.png
        
8. If there where no changes to the default configuration the SEB Server is now running on port 80 and can be accessed with a browser on http://server-address
There is one pre-configured institution and one user-account with SEB Server Administrator role to manage the server. 
The username and generated password of the initial admin account can be found on the logs:

::

    [SEB SERVER INIT] ---->   ___  ___  ___   ___
    [SEB SERVER INIT] ---->  / __|| __|| _ ) / __| ___  _ _ __ __ ___  _ _ 
    [SEB SERVER INIT] ---->  \__ \| _| | _ \ \__ \/ -_)| '_|\ V // -_)| '_|
    [SEB SERVER INIT] ---->  |___/|___||___/ |___/\___||_|   \_/ \___||_|  
    [SEB SERVER INIT] ---->
    [SEB SERVER INIT] ----> SEB Server successfully started up!
    ...
    [SEB SERVER INIT] ----> ***********************************************************************************************************************************************************************
    [SEB SERVER INIT] ----> SEB Server initial admin-account; name: sebserver-admin, pwd: i![qt}O3mUrCAA7WSZj5`ETRb4kfiy+za_IepZgnBCc^Br9=B%7lWXwcVABOAPJA
    [SEB SERVER INIT] ---->
    [SEB SERVER INIT] ----> !!!! NOTE: Do not forget to login and reset the generated admin password immediately !!!!
    [SEB SERVER INIT] ----> ***********************************************************************************************************************************************************************

    
.. note::

    We highly recommend to change the generated password from the initial admin account immediately after first login. 
    
**Update**

.. include:: service-update.rst
        
**Backup**

.. include:: service-backup.rst


Production
----------

**Info:**

For production we provide currently two different default setups, both for bundled environments. Setups for distributed environments will follow as soon
as possible. The first bundled setup is the usual basic setup with no HTTPS/TLS in place that can be used if the SEB Server shall be running in 
an environment that is already protected with an end to end TLS handling. Usually SEB Server will then run behind a reverse-proxy that handles the
TLS encryption on HTTPS and forward the decrypted traffic directly to the SEB Server on HTTP. We recommend such a setup because it is usually also
prefered by system administration and may already be in place within your IT environment. The other setup "tls" integrates the HTTPS/TLS handling
with the docker setup of SEB Server. The reverse-proxy that usually shodows the SEB Server within the docker-compose setup is used to terminate the
TLS handling and you have to configure and manage your certificates within the setup as described later in detail.

.. note::
    If you want to setup SEB Server for a cloud environment you have to adapt the available docker and docker-compose configurations to apply to
    your best-practices and standards. Currently there are no default configurations for cloud setup on cloud environments. Since SEB Server
    is built to be able to separte GUI- and web-service parts and to scale-up the web-service to run with many instances, it is just a matter of
    setting up all things properly and use cloud integration like docker-swarm or kubernetes. This should be possible but is not tested yet.
    

Basic Setup
...........

The testing basic setup comes with a webservice and GUI-service bundled single server setup defined in the usual sebserver.Docker file, a simple and integrated MariaDB setup that uses just the official
MariaDB Docker image, and a reverse proxy using the official nginx:latest Docker image. There is also a initial setup service that is defined in setup.Dockerfile and that in this case does only the 
initial password handling that is needed in the initial setup. And all is bundled together within the docker-compose.yml configuration file.

::

        installation strategy sub-directory.........docker/prod/bundled/basic/
        seb-server configuration....................docker/prod/bundled/basic/config/spring
        maria-db configuration......................docker/prod/bundled/basic/config/mariadb
        reverse-proxy configuration.................docker/prod/bundled/basic/config/nginx
        jmx configuration...........................docker/prod/bundled/basic/config/jmx
        single server setup.........................true
        secured (TLS)...............................false
        integrated mariadb service..................true
        initial data setup..........................auto generated Institution and SEB Administrator
        data setup on reload........................Spring - Flyway migration setup
        integrated reverse proxy....................true
        automated backup-restore service............false
        exposed database port.......................3306
        exposed JMX port............................9090 (by default this is not mapped to the host)
        
**Requirements:**

- Git installation if not already installed
- Docker installation if not already installed

.. note::

    The newest versions of Git and Docker are recommended. For installation see:
        |    - Git : https://www.atlassian.com/git/tutorials/install-git
        |    - Docker : https://docs.docker.com/install/
        |    - Docker-Compose : https://docs.docker.com/compose/install/
        
**Setup:**

The docker setup consists of two docker-files, "sebserver.Docker" that defines and builds an image for the SEB Server, "setup.Docker" that 
defines the initial setup job and a docker-compose.yml file that orchestrate the setup of the needed containers/services. 
The build of the image for SEB Server first clones the defines version of the SEB Server source repository form GitHub and build the SEB Server 
with Maven that leads to a self-contained, spring-boot-based, jar artifact that will be run with a usual java command on container startup. 
For MariaDB the defined public image is been used to build-up the MariaDB server service.

**Configuration**

The configuration for each service are located in the local /config directory separated by folders for each concern. The "spring" folder
contains all the Spring and Spring-Boot based configurations and is used by the seb-server service. The "mariadb" folder contains the
usual mariadb configuration file that is loaded form the seb-server-mariadb service on startup. The "nginx" folder contains a usual 
nginx reverse-proxy configuration and is used by the reverse-proxy service. The "jmx" folder contains JMX related configurations and is also
used by the seb-server service if JMX is enabled. For more details on how to configure each service see ref:`configuration-label`

**Installation:**

1. Login to the target/remote host where the SEB Server demo shall be installed, on windows open a command or PowerShell, create a working directory and navigate into it.
    
    .. code-block:: bash
    
        $ mkdir sebserver
        $ cd sebserver
        
2. Get a clone of the seb-server-setup repository and navigate to the demo setup folder

    .. code-block:: bash
    
        $ git clone https://github.com/SafeExamBrowser/seb-server-setup.git
        $ cd seb-server-setup/docker/prod/bundled/basic/

3. If some specific configuration is needed, this can be done within this step. See:ref:`configuration-label`. for more details on how to configure the services
   At least you should check the application-prod.properties file in the spring config directory, if everything is set properly.
   
   .. note::
        Check that the spring configuration properties "sebserver.webservice.http.external.*" are set correctly to the URL where the SEB Server 
        can be accessed from the public. Usually your server has an URL like https://example.com. so use "https" for the scheme, "example.com"
        for the servername and specify the port if differs from default.

4. build the docker images. 

    .. code-block:: bash
    
        $ docker-compose build --no-cache

    .. note::
    
        This step can be skipped if the images are already build with the right version.
        
5. Now we have to give a password that is internally used to create a data base account as well as to secure internal sensitive data.
The initial password must be set by creating a text file named "secret" with no extension and placed directly in the "config" sub-folder.
In this file the password must be written in plain text with no line brakes. Once the docker services started up the file will be copied 
into an internal docker volume and automatically deleted from the external config directory. The file can be created from the command line 
with for example : printf %s "somePassword" >> secret. Or if the password should not appear in the command-line history, 
just create the file and edit it with a text editor of your choice.

    .. code-block:: bash
    
        $ cd config
        $ printf %s "somePassword" >> secret
        $ cd ..

    .. note::
        
            This step usually must only be done once on the initial setup of the service. On a service update this is not needed and the
            password that was given by the initial setup remains
            
            This password can be used to connect directly to the database that is created with the service and should be remembered by an administrator.

6. Start the services. 

    .. code-block:: bash
    
        $ docker-compose up -d
        
7. Check if the containers are started and running. The output should look something like the following.

    .. code-block:: bash
    
        $ docker ps --all
        $ docker logs ${container name}
        
    .. image:: images/dockerServicesTestUp.png
        :align: center
        :target: https://raw.githubusercontent.com/SafeExamBrowser/seb-server-setup/master/docs/images/dockerServicesTestUp.png
        
8. If there where no changes to the default configuration the SEB Server is now running on port 80 and can be accessed with a browser on http(s)://server-address
There is one pre-configured institution and one user-account with SEB Server Administrator role to manage the server. 
The username and generated password of the initial admin account can be found on the logs:

::

    [SEB SERVER INIT] ---->   ___  ___  ___   ___
    [SEB SERVER INIT] ---->  / __|| __|| _ ) / __| ___  _ _ __ __ ___  _ _ 
    [SEB SERVER INIT] ---->  \__ \| _| | _ \ \__ \/ -_)| '_|\ V // -_)| '_|
    [SEB SERVER INIT] ---->  |___/|___||___/ |___/\___||_|   \_/ \___||_|  
    [SEB SERVER INIT] ---->
    [SEB SERVER INIT] ----> SEB Server successfully started up!
    ...
    [SEB SERVER INIT] ----> ***********************************************************************************************************************************************************************
    [SEB SERVER INIT] ----> SEB Server initial admin-account; name: sebserver-admin, pwd: i![qt}O3mUrCAA7WSZj5`ETRb4kfiy+za_IepZgnBCc^Br9=B%7lWXwcVABOAPJA
    [SEB SERVER INIT] ---->
    [SEB SERVER INIT] ----> !!!! NOTE: Do not forget to login and reset the generated admin password immediately !!!!
    [SEB SERVER INIT] ----> ***********************************************************************************************************************************************************************

    
.. note::

    We highly recommend to change the generated password from the initial admin account immediately after first login. 
    
**Update**

.. include:: service-update.rst
        
**Backup**

.. include:: service-backup.rst

