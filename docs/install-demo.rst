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
        
6. Check if the containers are started and running. There should be two containers running; seb-server and seb-server-mariadb. You can also check the logs of individual container.

 .. code-block:: bash
 
        $ docker ps --all
        $ docker logs ${container name}
        
7. If there where no changes to the default configuration the SEB Server is now running on port 8080 and can be accessed with a browser on http://server-address:8080/. There is one pre-configured institution (ETH Zürich) and one user-account with all roles to manage the server. The username of the initial account is always "super-admin" and the password is "admin". After successful startup you will see a message like the following within the SEB Server log file.

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
    
**Service Update**

.. include:: service-update.rst

**Service Reset**

.. include:: service-reset.rst
        
**Service Backup / Restore**

.. include:: service-backup.rst