Production
----------

**Info:**


For production we provide currently three different default setups. Both for bundled environments. 

.. note::
    There is a new SEB Server setup approach since SEB Server version 1.2 where the docker image is not part of the setup repository
    anymore but is built and published by the main SEB Server repository within docker hub. 
    
    If you are new to SEB Server and this is your first installation, we recommend to stick with the new approach that can be found
    in the setup directory docker/prod/bundled/dockerhub/
    
    It is still possible to use the older approach if you already have setup your SEB Server and are going to update the installation
    to another version.
    
The first bundled setup is the usual basic setup with no HTTPS/TLS in place that can be used if the SEB Server shall be running in 
an environment that is already protected with an end to end TLS handling. Usually SEB Server will then run behind a reverse-proxy that handles the
TLS encryption on HTTPS and forward the decrypted traffic directly to the SEB Server on HTTP. We recommend such a setup because it is usually also
preferred by system administration and may already be in place within your IT environment. The other setup "tls" integrates the HTTPS/TLS handling
with the docker setup of SEB Server. The reverse-proxy that usually shadows the SEB Server within the docker-compose setup is used to terminate the
TLS handling and you have to configure and manage your certificates within the setup as described later in detail.

.. note::
    If you want to setup SEB Server for a cloud environment you have to adapt the available docker and docker-compose configurations to apply to
    your best-practices and standards. Please for now have a look into the testing setup directory docker/testing/cloud/ where you can find a
    experimental setup for cloud environments with separated database, webservice and guiservice.
    
    
    
Productive Setup with Dockerhub
...............................

This is the preferred way to setup a bundled SEB Server instance where all components (database, guiservice and webservice) run together within 
the same machine or host and within the same docker network.
A simple and integrated MariaDB setup that uses just the official MariaDB Docker image, and a reverse proxy using the official nginx:latest Docker image. 
This setup uses docker compose to build and run all needed containers. The docker image for SEB Server is been downloaded from docker hub.

::

        installation strategy sub-directory.........docker/prod/bundled/dockerhub/
        seb-server configuration....................docker/prod/bundled/dockerhub/config/spring
        maria-db configuration......................docker/prod/bundled/dockerhub/config/mariadb
        reverse-proxy configuration.................docker/prod/bundled/dockerhub/config/nginx
        jmx configuration...........................docker/prod/bundled/dockerhub/config/jmx
        single server setup.........................true
        secured (TLS)...............................configurable
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

This setup contains a docker-compose.yml file that orchestrate the setup of the needed containers/services and a configuration sub-directory
for all needed components. The docker image for SEB Server will be automatically fetched from docker-hub.
For MariaDB the official public image is used to build-up the MariaDB server service.

**Configuration**

The configuration for each service is located in the local /config directory separated by folders for each concern. The "spring" folder
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
    
    $ git clone -b v1.1-latest https://github.com/SafeExamBrowser/seb-server-setup.git
    $ cd seb-server-setup/docker/prod/bundled/dockerhub/

3. If some specific configuration is needed, this can be done within this step. See:ref:`configuration-label`. for more details on how to configure the services
   At least you should check the application-prod.properties file in the spring config directory, if everything is set properly.
   
   Also set the mandatory settings defined in the docker-compose.yml according to your setup:
   
- sebserver_webservice_http_external_scheme: Defines the scheme of the external URL (http or https) 
- sebserver_webservice_http_external_servername: Defines the server name of the external URL (e.g.: sebserver.ethz.ch)
- sebserver_webservice_http_external_port: Defines the port of the external URL. Mandatory only if it differs from default (http:80,https:433)

4. build the docker images. 

 .. code-block:: bash
    
    $ docker-compose build --no-cache
        
5. Now we have to give the needed passwords for an initial startup. This can either be done by creating an .env file on the working directory
   or by give the needed passwords as environment variables on the service startup within the next step.

 .. code-block:: bash
    $ printf %s "SEBSERVER_PWD=somePassword\nDB_SA_PWD=passwordForDataBase" >> .env

.. note::
    The passwords must be given also when the service is stopped and restarted again.. You can either let the .env file 
    be within the installation directory as is. Or you can delete the .env file form the host and copy or create it again when
    an update or restart of the container is needed. Note that it is very important that the SEBSERVER_PWD do not change and the same
    SEBSERVER_PWD is used for updates and restarts as it was for the initial setup. Otherwise data will be lost due to encryption with
    unknown or incorrect passwords. The password should be in the responsibility of a system administrator and handled with appropriate care.

6. Start the services. If you want to give the needed password here instead within an .env file, you can add them as environment variables within the call

 .. code-block:: bash
    
    $ docker-compose up -d 
    
or

 .. code-block:: bash
    
    $ SEBSERVER_PWD=somePassword DB_SA_PWD=passwordForDataBase docker-compose up -d 
        
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
    
    
    

Basic Setup (deprecated)
....................

.. note::
    This setup was used for SEB Server version 1.0.x and 1.1.x and is now deprecated since there is a new and more concise setup 
    until SEB Server version 1.2.x. You can still stick with this setup and just adapt the SEBSERVER_VERSION on the docker-compose
    file for update to preferred version and rebuild the image and restart the containers as usual. Or you can migrate to the new 
    setup.

The production basic setup comes with the webservice and the GUI-service bundled in a single server setup and defined in the usual sebserver.Docker file.
A simple and integrated MariaDB setup that uses just the official MariaDB Docker image, and a reverse proxy using the official nginx:latest Docker image. 
There is also a initial setup service that is defined in setup.Dockerfile and that in this case does only the initial 
password handling that is needed for the initial setup. All this is bundled together within the docker-compose.yml configuration file to run on the same host.

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

The docker setup consists of two docker-files, "sebserver.Docker" that defines and builds an image for the SEB Server and "setup.Docker" that 
defines the initial setup job. And a docker-compose.yml file that orchestrate the setup of the needed containers/services. 
The build of the docker image for SEB Server first clones the configured version of the SEB Server source repository from GitHub and builds the SEB Server 
with the Maven build tool that leads to a self-contained, spring-boot-based jar artifact that is run with a usual java command on the container startup. 
For MariaDB the official public image is used to build-up the MariaDB server service.

**Configuration**

The configuration for each service is located in the local /config directory separated by folders for each concern. The "spring" folder
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
    
    $ git clone -b v1.1-latest https://github.com/SafeExamBrowser/seb-server-setup.git
    $ cd seb-server-setup/docker/prod/bundled/basic/

3. If some specific configuration is needed, this can be done within this step. See:ref:`configuration-label`. for more details on how to configure the services
   At least you should check the application-prod.properties file in the spring config directory, if everything is set properly.
   
   Also set the mandatory settings defined in the docker-compose.yml according to your setup:
   
- sebserver_webservice_http_external_scheme: Defines the scheme of the external URL (http or https) 
- sebserver_webservice_http_external_servername: Defines the server name of the external URL (e.g.: sebserver.ethz.ch)
- sebserver_webservice_http_external_port: Defines the port of the external URL. Mandatory only if it differs from default (http:80,https:433)

4. build the docker images. 

 .. code-block:: bash
    
    $ docker-compose build --no-cache
        
5. Now we have to give a password that is internally used to create a data base account as well as to secure internal sensitive data.
   The initial password must be set by creating a text file named "secret" with no extension and placed directly in the "config" sub-folder.
   In this file the password must be written in plain text with no line brakes. Once the docker services start up the first time the file will be copied 
   into an internal docker volume and automatically deleted from the external config directory. The file can be created from the command line 
   with for example : printf %s "somePassword" >> secret. Or if the password should not appear in the command-line history, 
   just create the file and edit it with a text editor of your choice.

 .. code-block:: bash
    
    $ cd config
    $ printf %s "somePassword" >> secret
    $ cd ..

.. note::
    This step usually must only be done once on the initial setup of the service. On a service update this is not needed and the
    password that was given by the initial setup remains.
    This password can be used to connect to the database within a SSH tunnel for example. The password should be in the responsibility of a system administrator and handled with care.

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
    
    


TLS Setup (deprecated)
..................

.. note::
    This setup was used for SEB Server version 1.0.x and 1.1.x and is now deprecated since there is a new and more concise setup 
    until SEB Server version 1.2.x. You can still stick with this setup and just adapt the SEBSERVER_VERSION on the docker-compose
    file for update to preferred version and rebuild the image and restart the containers as usual. Or you can migrate to the new 
    setup.

The production tls setup comes with the webservice and the GUI-service bundled in single server setup defined in the usual sebserver.Docker file. 
A simple and integrated MariaDB setup that uses just the official MariaDB Docker image, and a reverse proxy using the official nginx:latest Docker image. 
There is also a initial setup service that is defined in setup.Dockerfile and that in this case does the initial 
password handling that is needed for the initial setup. All is bundled together within the docker-compose.yml configuration file to run on the same host. 
Additional to the basic setup, this setup contains a nginx app.conf file with HTTPS configuration and a sub-directory "certs" that contains
self-signed certificates that are only for documentation purposes and that must be replaced by your singed certificates in step 4.
of the installation process.

::

        installation strategy sub-directory.........docker/prod/bundled/tls/
        seb-server configuration....................docker/prod/bundled/tls/config/spring
        maria-db configuration......................docker/prod/bundled/tls/config/mariadb
        reverse-proxy configuration.................docker/prod/bundled/tls/config/nginx
        jmx configuration...........................docker/prod/bundled/tls/config/jmx
        single server setup.........................true
        secured (TLS)...............................true
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
   
   Also set the mandatory settings defined in the docker-compose.yml according to your setup:
   
- sebserver_webservice_http_external_scheme: Defines the scheme of the external URL (http or https) 
- sebserver_webservice_http_external_servername: Defines the server name of the external URL (e.g.: sebserver.ethz.ch)
- sebserver_webservice_http_external_port: Defines the port of the external URL. Mandatory only if it differs from default (http:80,https:433)
 
4. You have to replace the self-signed certificates that are provided just for documentation purposes by going in to the configuration sub
   directory config/nginx/certs and replace the localhost.crt and localhost.key file with your signed certificate and key file.

5. build the docker images. 

 .. code-block:: bash
    
    $ docker-compose build --no-cache
        
6. Now we have to give a password that is internally used to create a data base account as well as to secure internal sensitive data.
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
    This password can be used to connect to the database within a SSH tunnel for example. The password should be in the responsibility of a system administrator and handled with care.

7. Start the services. 

 .. code-block:: bash
    
    $ docker-compose up -d
        
8. Check if the containers are started and running. The output should look something like the following.

 .. code-block:: bash
    
    $ docker ps --all
    $ docker logs ${container name}
        
.. image:: images/dockerServicesTestUp.png
    :align: center
    :target: https://raw.githubusercontent.com/SafeExamBrowser/seb-server-setup/master/docs/images/dockerServicesTestUp.png
    
9. If there where no changes to the default configuration the SEB Server is now running on port 80 and can be accessed with a browser on http(s)://server-address
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
    
    
    

Enable JMX Remote Monitoring
............................

If you want to be able to remotely connect to the SEB Server within a JMX monitoring tool you have to enable the JMX remote monitoring and therefore 
you have to edit some configuration files at step 3. of the installation process.

- Open the docker-compose.yml file with a text editor of your choice.
    
 .. code-block:: bash

    $ vi docker-compose.yml

- Remove the commented section about JMX and monitoring and set the MONITORING_MODE environment attribute to "true".

 .. code-block:: bash

    environment:
        - MONITORING_MODE=false
      # - JMX_PORT=9090
      # Connect this port to host if you want to use JMX (MONITORING_MODE=true)
      #ports:
      #  - 9090:9090
      
      alter to
      
      environment:
        - MONITORING_MODE=true
        - JMX_PORT=9090
      # Connect this port to host if you want to use JMX (MONITORING_MODE=true)
      ports:
        - 9090:9090
      
- Save the modified file and go into the jmx configuration directory

 .. code-block:: bash

    $ cd config/jmx

- Open file "jmxremote.password" file in a text editor

 .. code-block:: bash

    $ vi jmxremote.password

- The file is empty and you can give a password for a user (read-only) and an admin (read and write). 

 .. code-block:: bash

    user [your password here]
    
- Save the file and change to access rights according to JMX setup with:

 .. code-block:: bash
 
    $ chmod 600 jmxremote.password
    
- Go further form here with the normal installation process
    
- After starting up the SEB Server successfully you should be able to remotely connect with a JMX monitoring tool to the server. Make sure
  you have a secured connection over SSH with a tunnel for example. 


Service Update
..............

.. include:: service-update.rst

Service Reset
.............

.. include:: service-reset.rst
        
Service Backup / Restore
........................

.. include:: service-backup.rst


