Installation
============

All provided setups are pre-configured docker-compose setups that suppose to work well with a general installation process and fit with
usual IT environment. The setups are mainly categorized into bundled setups and distributed setups where a bundled setup is a single
docker-compose setup that bundles all services together within one machine and an internal docker-network. A distributed setup may contain
different docker-compose configuration to set up SEB Server in a distributed environment like a cloud service for example.

**Docker Compose for bundled setup**

A docker compose configuration for a bundled setup looks pretty much the same for each setup and consists of four services:

- **seb-server-setup** This service is just to setup everything in advance and uses a Docker container for that runs some
  initial actions to bind the volumes and copy the initial password, make it internally available by also deleting it from the hosts
  file system. And probably some other needed commands that presets things for the specific setup. 
 
- **mariadb** This is the MariaDB service that is bound to the internal network as well as exposing its default port to the host
  network by default. This service uses the official "mariadb/server:10.5" image for the service and the configuration that is provided
  within the config/mariadb7 folder. The MariaDB container is started with the given internal password as the root password. This service
  uses a separated named docker volume to store the data (seb-server-mariadb). 
 
.. note::
    The named volume of the MariaDB service is not mapped to the host file system for default. 
    If you have to do so, for backup and restore procedure for example, you can configure this within the docker-compose setup.
 
- **seb-server** This is the main server service that starts the Spring-Boot application within the container. This service uses the
  configuration in the folder: config/spring. The server is bound only to the internal docker network on port 8080 for default and also
  connects to the database within the internal docker network that is created with the docker-compose setup (seb-server-network). The service
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
 
**Distributed setup example with Kind (Kubernetes in docker)**

Since version 1.3 there is a distributed setup example for Kind that can be used as a starting point to setup a fully
distributed and scalable SEB Server service in the cluster with Kubernetes. The setup instructions are located within the "Demo" setup section.
 
**Docker Compose for distributed setup**
 
Default setups for distributed environments to install SEB Server as a cloud service for example are not provided yet. You can use the pre-defined components
from a bundled setup and adapt and use it for your distributed environments. Please also contact a system administrator or cloud administrator
of your company/institution to find a solution that fits best within your needs and given IT environment. If you have questions or need help / report bugs, 
please use the `issue tracker <https://github.com/SafeExamBrowser/seb-server-setup/issues>`_  on GitHub for reporting.

**HTTPS / TLS Configuration**

There are manly two strategies to configure HTTPS / TLS for a SEB Server;

    - The HTTPS / TLS is handled by a reverse-proxy that is exposed to the Internet and forwards the requests over HTTP to the SEB Server that in this
    case has only an simple HTTP connector and is not exposed to the Internet but to the internal network with the reverse proxy
    - The HTTPS / TLS is handled by the SEB Server itself (end to end). 

.. note::
    It is highly recommended to use the first approach here that is easier to install then the end to end approach. 
    There are some prepared installations for the second approach within the seb-server-setup repository (tls) but they are experimental yet.

General Installation Process
-----------------------------

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
    
3. In the installation directory of your choice clone the seb-server-setup repository of desired version from GitHub.
    
4. Navigate into the installation strategy sub-directory you want to install from and edit/prepare the configuration for your needs.
    
5. Build the docker images with docker-compose build.
    
6. Bring the docker containers up and running with docker-compose up, and do some suggested health checks.


For detailed setup and installation please see the detailed installation guide for the particular setup; demo, testing and production.

.. toctree::
   :maxdepth: 1
   
   install-demo
   install-testing
   install-production

