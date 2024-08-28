Demo Setup
----

.. _installdemo-label:

**Info:**

Since SEB Server version 2.0 we provide one simple demo setup that bundles up all services within one Docker-Compose network
and with no TLS/SSL implementation to deploy on a single host or locally on localhost with some limitations on security and
performance.


::

        installation strategy sub-directory.........docker/demo/
        seb-server configuration....................none (demo configuration)
        single server setup.........................yes
        secured (TLS)...............................no
        integrated mariadb service..................yes
        initial data setup..........................demo data
        data setup on reload........................demo data
        integrated reverse proxy....................no
        exposed database port.......................3306
        recommended machine requirements............CPU: x86_64/2 Cores / 2 GHz, Mem 16GB, Disk Space min 100GB


**Requirements:**

- Git if not already installed
- Docker and Docker-Compose if not already installed

.. note::

    The newest versions of Git and Docker are recommended. For installation see:
        |    - Git : https://www.atlassian.com/git/tutorials/install-git
        |    - Docker : https://docs.docker.com/install/
        |    - Docker-Compose : https://docs.docker.com/compose/install/
    
**Setup:**

The setup uses the latest stable SEB Server version from Docker-Hub and the installation is straight forward.
You can either copy the two files in /docker/demo directory to a preferred local installation directory or use git
to clone the seb-server-setup repository on your local install machine and work on the cloned directory.

1. Get the two needed files ".env" and "docker-compose.yml" form the docker/demo directory of this seb-server-setup repository

2. Place this two files into a preferred local install directory.

3. Open the ".env" file with a text editor and set the needed environment variables:

::
    
    SEBSERVER_PWD: The SEB Server password is needed for various reasons. This password must be always the same and should be securely stored somewhere
    CLIENT_EXTERNAL_DNS_NAME: The DNS name for clients connecting to SEB Server. When deploy locally this is localhost. IP address or DNS name for dedicated host
    SERVER_EXTERNAL_DNS_NAME: The DNS name for internal communication. When deploy locally this is host.docker.internal. IP address or DNS name for dedicated host
    
4. Use "docker-compose pull" to let docker pull all needed images first

5. Use "docker-compose up -d" to start the docker containers.

6. Use "docker logs seb-server" to view the logs of SEB Server startup.

7. Go to http://localhost:8080 and login with user name: "super-admin" and password "admin"

.. note::

    Since this is a demo installation it may not be necessary but we highly recommend to change the generated password from the initial admin account immediately after first login. 


