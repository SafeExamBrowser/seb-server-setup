Demo
----

**Info:**

Since SEB Server version 1.3 there are two different demo setups provided within the seb-server-setup repositiory.
The Basic Demo is the same demo setup as it exited before version 1.3, a single basic setup all in one for demonstrations.
The Kubernetes Kind Example setup is a new demo and example setup for Kubernetes kind that can also act as a starting point
or template for a Kubernetes based production ready setup.

.. _installdemo-label:

Basic Demo
..........

This setup provides a single (all in one), unsecured SEB Server setup for demonstrations and testing. 
This setup includes a single SEB Server instance and a single MariaDB server instance running both in a docker-container. 
With the default configuration, the MariaDB server is exposed on port 3306 and the SEB Server on port 8080.

::

        installation strategy sub-directory.........docker/demo/basic
        seb-server configuration....................docker/demo/basic/config/spring
        single server setup.........................true
        secured (TLS)...............................false
        integrated mariadb service..................true
        initial data setup..........................demo data
        data setup on reload........................demo data
        integrated reverse proxy....................false
        automated backup-restore service............false
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

The setup uses the latest stable SEB Server version from Docker-Hub and the installation is very straight forward.
You can either copy the two files in /docker/demo directory to a preferred local installation directory or use git
to clone the seb-server-setup repository on your local install machine and work on the cloned directory.

1. Get the two needed files ".env" and "docker-compose.yml" form the docker/demo directory of this seb-server-setup repository
2. Place this two files into a preferred local install directory.
3. Open the ".env" file with a text editor and set the two password needed and save the file.
4. Use "docker-compose pull" to let docker pull all needed images first
5. Use "docker-compose up -d" to start the docker containers.
6. Use "docker logs seb-server" to view the logs of SEB Server startup.
7. Go to http://localhost:8080 and login with user name: "super-admin2 and password "admin"

.. note::

    Since this is a demo installation it may not be necessary but we highly recommend to change the generated password from the initial admin account immediately after first login. 
    
**Service Update**

.. include:: service-update.rst

**Service Reset**

.. include:: service-reset.rst
        
**Service Backup / Restore**

.. include:: service-backup.rst

