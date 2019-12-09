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

        installation strategy sub-directory.........docker/demo
        single server setup.........................true
        secured (TLS)...............................false
        integrated mariadb service..................true
        integrated reverse proxy....................false
        automated backup-restore service............false
        


**Requirements:**

- Git installation if not already installed
- Docker installation if not already installed

.. note::

    The newest versions of Git and Docker are recommended. For installation see:
        |    - Git : https://www.atlassian.com/git/tutorials/install-git
        |    - Docker : https://docs.docker.com/install/
    
**Setup:**

The docker setup consists of a Dockerfile (sebserver.Docker) that defines and builds an image for the SEB Server and a docker-compose.yml file that orchestrates the setup of the needed containers/services. 
The build of the image for SEB Server first clones the defines version of the SEB Server source repository form GitHub and build the SEB Server with Maven that leads to a self-contained, spring-boot-based, 
jar artifact that will be run with a usual java command on container startup. For MariaDB the defined public image is been used to build-up the MariaDB server service.

**Configuration**

There is only the SEB Server Spring configuration in place so far for the Demo setup. See :ref:`configuration-label`.


**Installation:**

1. Login to the target/remote host where the SEB Server demo shall be installed, on windows open a command or PowerShell, create a working directory and navigate into it.
    
    .. code-block:: bash
    
        $ mkdir /sebserver
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
The username of the initial account is always "super-admin" and the can be extracted from the SEB Server log-file. 
View logs with docker logs find the SEB Server initialization info and there the initial admin-account line

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

To update an already installed SEB Server instance, following the steps below;

1. Shouting down the SEB Server setup docker services with;

    .. code-block:: bash
    
        $ docker-compose down
        
2. Update to the newest or preferred version within the seb-server-setup. Use git tags to show the available tags. If there are already local changed - if the configuration was modified from the original settings - and the local changes shall still be used and remain, git stash can be used to locally store and merge them.

    .. code-block:: bash
    
        # Get new tags from remote
        $ git fetch --tags

        # Get latest tag name
        $ latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
        
        # If local changes shall remain
        $ git stash

        # Checkout latest tag
        $ git checkout $latestTag
        
        # If local changes shall remain
        $ git stash apply
        
3. Boot the SEB Server setup docker services with

    .. code-block:: bash
    
        $ docker-compose up -d
        
4. Check if the containers are started and running. There should be two containers running; seb-server and seb-server-mariadb. You can also check the logs of individual container

    .. code-block:: bash
    
        $ docker ps --all
        $ docker logs ${container name}


Testing
-------

TODO

Production
----------

TODO

