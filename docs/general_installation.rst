General Installation Instructions
----------------------------------

All provided setups are pre-configured docker-compose setups that suppose to work well with a general installation process and fit with
usual IT environment. The setups are mainly categorized into bundled setups and distributed setups where a bundled setup is a single
docker-compose setup that bundles all services together within one machine and an internal docker-network. A distributed setup may contain
different docker-compose configuration to set up SEB Server in a distributed environment like a cloud service for example.

**Docker Compose for bundled setup**

A docker compose configuration for a bundled setup looks pretty much the same for each setup and consists of the following services:
 
- **mariadb** This is the MariaDB service that is bound to the internal network as well as exposing its default port to the host
  network by default. This service uses the official "mariadb/server:10.5" image for the service and the configuration that is provided
  within the config/mariadb7 folder. The MariaDB container is started with the given internal password as the root password. This service
  uses a separated named docker volume to store the data.
 
.. note::
    The named volume of the MariaDB service is not mapped to the host file system for default. 
    If you have to do so, for backup and restore procedure for example, you can configure this within the docker-compose setup.
 
- **seb-webservice** This is the main SEB server service that starts the Spring-Boot back-end application within the container. This service uses the
  configuration in the folder: config/spring. The server is bound only to the internal docker network on port 8080 for default and also
  connects to the database within the internal docker network that is created with the docker-compose setup (seb-server-network).
 
.. note::
    (since 3.0)

    The SEBSERVER_VERSION attribute relates on a Git tag of the seb-server repository (without the "v" prefix). Usually you want to point to
    the exact version of the SEB Server by using `sematic versioning <https://semver.org/>`_ like 1.0.0 or 1.0.1 or you can set the latest
    minor version to always get the latest specific minor version with all patches on installation or update. If you want the latest minor version
    use version tags like 1.0-latest or 1.1-latest.

- **sps-webservice** This is the webservice back-end for the new screen proctoring feature that is separated from the SEB Server for performance and scaling reasons.
  This is a usual Java/Spring Boot application like seb-server and implements screen proctoring maintenance API as well as screen proctoring session API
  for SEB connections. This service also needs a connection to a database store. This can either be the same database server as seb-webservice
  or another database for performance reasons. It is also possible to configure an additional S3 compatible storage to just store the screen shots.

- **seb-guiservice** This is the service for the new graphical user interface with screen proctoring integration that runs in NodeJS and uses Vue
  Java Script framework. This service connects to the seb-webservice as well as to the sps-webservice and uses the API of both services.
 
- **reverse-proxy** This service uses a nginx server as reverse-proxy to connect the bundle to the host network and applies
the routing to internal back-end webservices namely seb-webservice and sps-webservice as well as to the seb-guiservice that
is applied to the location "/". The seb-webservice is applied to the location /seb-web/ and the sps-webservice is applied
to the location /sps-web/ for default. Depending on the setup you use, the nginx server is listen to a specific port by default.
Please have a look into the nginx server configuration ./config/nginx/app.conf if the default fits your needs and adapt the
nginx server configuration if necessary to work in your environment.

**HTTPS / TLS Configuration**

There are manly two strategies to configure HTTPS / TLS for a SEB Server;

    - The HTTPS / TLS is handled by a reverse-proxy that is exposed to the Internet and forwards the requests over HTTP to the SEB Server that in this
    case has only an simple HTTP connector and is not exposed to the Internet but to the internal network with the reverse proxy
    - The HTTPS / TLS is handled by the SEB Server itself (end to end).

.. note::
    It is highly recommended to use the first approach here that is easier to install then the end to end approach.
    There are some prepared installations for the second approach within the seb-server-setup repository (tls) but they are experimental yet.

 
**Distributed setup example with Kind (Kubernetes in docker)**

Since version 1.3 there is a distributed setup example for Kind that can be used as a starting point to setup a fully
distributed and scalable SEB Server service in the cluster with Kubernetes.


General Installation Process
............................

First we will have a look at the overall installation process that can be applied to all bundled installation strategies we have discussed 
in section :ref:`installation-repo-label`. 
The endpoint root of every sub-directory of an installation strategies has the same structure and contains docker files, docker compose 
configurations and various configuration files within the "config" sub-directory.

This is an example structure of an installation strategy sub-directory. The installation directory docker/testing/basic/ in this case 
provides a setup for testing with a mariadb service, a seb-server single instance service and a reverse proxy service that is bundled and
exposed to the host network by the proxy.

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
        .env
        docker-compose.yml
        
The docker based installation typically is composed of a config directory with all the related config files and a docker-compose
file that bundles all together. Configuration files as well as docker files are pre-configured in a way that a minimum of additional
settings has to be done to setup the service.
The most important settings are used as environment variables and extracted to an .env file with default values.
For a specific setup you at least need to adapt this variables and most important, to set your own passwords for your setup.
You also be able to remove the environment variables that contains passwords form the .env file and either use it directly
or configure the setup to extract them from a secure volt if you have such. How to do this for particular cases is not
part of this documentation and depends on your environment.

A usual installation process for SEB Server mostly look something like the following:

1. Connect to the remote host where the SEB Server instance has to be installed 
    
2. Install Git and Docker on the remote host if not already installed.
    
    .. note::
    
        The newest versions of Git and Docker are recommended. For installation see:
            |    - Git : https://www.atlassian.com/git/tutorials/install-git
            |    - Docker : https://docs.docker.com/install/
            |    - Docker-Compose : https://docs.docker.com/compose/install/
    
3. In the installation directory of your choice clone the seb-server-setup repository of desired version from GitHub.
    
4. Navigate into the installation strategy sub-directory you want to install from and edit/prepare the configuration for your needs.
    
5. Adapt the .env File and complete the configuration and apply all needed settings for your setup

6. Pull the docker images form Dockerhub by using docker-compose pull command
    
7. Bring the docker containers up and running with docker-compose up, and do some suggested checks.

For detailed setup and installation please see the detailed installation guide for the particular setup; demo, testing and production.