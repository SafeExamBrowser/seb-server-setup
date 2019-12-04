Installation
============

Fist we will have a look at the overall installation process that can be applied to all different installation strategies we have discussed 
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
        
So a specific installation the process should mostly be the same:

- Connecting to the remote machine where the SEB Server instance has to be installed

- Install Git and Docker if not already installed.

    .. note::
    
        The newest versions of Git and Docker are recommended. For installation see:
        - Git : https://www.atlassian.com/git/tutorials/install-git
        - Docker : https://docs.docker.com/install/

- In the installation directory of choice clone the seb-server-setup repository of desired version

- Navigate into the installation strategy sub-directory of choice and edit/prepare the configuration for the specified needs

- Build the docker images and do some strategy dependent additional settings

- Bring the docker containers up and running and do some suggested health checks

Next part describes this process in detail for all supported installation strategies and also gives a service overview for a
specific installation strategy.


Demo
----

**Info:**

::

        installation strategy sub-directory.........docker/demo
        single server setup.........................true
        secured (TLS)...............................false
        integrated mariadb service..................true
        integrated reverse proxy....................false
        automated backup-restore service............false
        
This setup provides a single, unsecured SEB Server setup for demonstrations and testing. Includes a single SEB Server instance and a single MariaDB server instance running both in a docker-container. 
With the default configuration, the MariaDB server is exposed on port 3306 and the SEB Server on port 8080.

**Requirements:**

- Git installation. Newest version recommended but at least version 2.19 : https://www.atlassian.com/git/tutorials/install-git
- Docker installation. Newest version recommended : https://docs.docker.com/install/

**Setup:**

The docker setup consists of a Dockerfile (sebserver.Docker) that defines and builds an image for the SEB Server and a docker-compose.yml file that orchestrates the setup of the needed containers/services. 
The build of the image for SEB Server first clones the defines version of the SEB Server source repository form GitHub and build the SEB Server with Maven that leads to a self-contained, spring-boot-based, 
jar artifact that will be run with a usual java command on container startup. For MariaDB the defined public image is been used to build-up the MariaDB server service.
        