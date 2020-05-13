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
    
**Enable JMX Remote Monitoring**

If you want to be able to remotely connect to the SEB Server within a JMX monitoring tool you have to enable the JMX remote monitoring and therefore 
you have to edit some configuration files at step 3. of the installation process.

- Open the docker-compose.yml file with a text editor of your choice.
    
.. code-block:: $ vi docker-compose.yml

- Remove the commented section about JMX and monitoring and set the MONITORING_MODE environment attribute to "true".

.. code-block:: 
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

.. code-block:: $ cd config/jmx

- Open file "jmxremote.password" file in a text editor

.. code-block:: $ vi jmxremote.password

- The file is empty and you can give a password for a user (read-only) and an admin (read and write)

.. code-block:: 
    user [your password here]
    
- Save the file and go on with the installation process as decribed above.

- After starting up the SEB Server successfully you should be able to remotely connect with a JMX monitoring tool to the server. Make sure
you have a secured connection over SSH with a tunnel for example. 


**Update**

.. include:: service-update.rst
        
**Backup**

.. include:: service-backup.rst


