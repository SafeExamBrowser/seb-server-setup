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
    
**Service Update**

.. include:: service-update.rst

**Service Reset**

.. include:: service-reset.rst
        
**Service Backup / Restore**

.. include:: service-backup.rst