Installation
============

First we will have a look at the overall installation process that can be applied to all different installation strategies we have discussed 
in section :ref:`installation-repo-label`. 

The endpoint root of every sub-directory of an installation strategies has the same structure and contains docker files, docker compose 
configurations and various configuration files within the "config" sub-directory

This is an example structure of an installation strategy sub-directory. The installation directory docker/testing/noencrypt/ in this case 
provides a setup for testing with a mariadb service, a seb-server single instance service and a reverse proxy service that is exposed and

::
    
    - docker/testing/noencrypt/   (this is the endpoint root directory for testing setup of a single server instance with no TLS)
        - config
            - nginx
                 app.config
            - spring
                application.properties
                messages_en.properties
        docker-compose.yml
        sebserver.Dockerfile
        setup.Dockerfile
        
The docker based installation typically contains a config directory with all the related config files, one or more docker-files that
defines images for installation related services and a docker-compose file that bundles all together. Configuration files as well as 
docker files can be modified for the specified needs on the installation environment.
So a usual installation process for SEB Server mostly look something like:

1. Connecting to the remote machine where the SEB Server instance has to be installed 
    
2. Install Git and Docker if not already installed.
    
    .. note::
    
        The newest versions of Git and Docker are recommended. For installation see:
            |    - Git : https://www.atlassian.com/git/tutorials/install-git
            |    - Docker : https://docs.docker.com/install/
            |    - Docker-Compose : https://docs.docker.com/compose/install/
    
3. In the installation directory of choice clone the seb-server-setup repository of desired version
    
4. Navigate into the installation strategy sub-directory of choice and edit/prepare the configuration for the specified needs
    
5. Build the docker images and do some strategy dependent additional settings
    
6. Bring the docker containers up and running and do some suggested health checks

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

    .. note::
    
        This step can be skipped if the images are already build with the right version.

5. Start the services. 

    .. code-block:: bash
    
        $ docker-compose up -d
        
6. Check if the containers are started and running. There should be two containers running; seb-server and seb-server-mariadb. You can also check the logs of individual container

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
   At least one should check the application-prof.properties file in the spring config directory, if everything is set properly.
   
   .. note::
   
        Check that the spring configuration properties "sebserver.webservice.http.external.*" are set correctly
        to the URL where the SEB Server can be accessed from the public.

4. build the docker images. 

    .. code-block:: bash
    
        $ docker-compose build --no-cache

    .. note::
    
        This step can be skipped if the images are already build with the right version.
        
5. Now we have to give an password that is internally used to create a data base account as well as to secure internal sensitive data.
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
        
7. If there where no changes to the default configuration the SEB Server is now running on port 80 and can be accessed with a browser on http://server-address
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

TODO

