.. _prodsetup-label:

Production
----------

**Info:**

For production we provide currently three different default setups or examples, two if them for bundled setups and one
as an example for a cloud based setup with kubernetes kind example configurations.

.. note::
    There is a new SEB Server setup approach since SEB Server version 1.2 where the docker image is not part of the setup repository
    anymore but is built and published by the main SEB Server repository within docker hub.

    And since SEB Server version 2.0 there are two new services that are included within the SEB Server installation but
    simplified setup process completely based on Docker-Compose for bundled setups, pulling images form Dockerhub.one

    If you already have a SEB Server installation and want to migrate from a former installation with major version 1.X
    to the new major version 2.x, please consult the Major Version Migration Guide
    
The two bundled setup differ in the external DNS binding setup where the fist setup exposes the new services for screen proctoring
within dedicated HTTP ports (not the default ports) while the second setup uses the integrated nginx proxy to route incoming
request for screen proctoring from the default HTTP port to the dedicated services internally.
The fist approach is easier to apply and probably more performant but needs two extra ports that can be accessed by the respective DNS name.
For example if you have a DNS name "seb.example.com" then the seb-server service is exposed on the default ssl port (443) as usual
but the screen proctoring services needs another port to be exposed to. Default is 4431 and 4432 that also needs to be open and
accessible from the Internet.
    
Bundled Setup with dedicated Port mapping
...............................

This is the preferred way to setup a bundled SEB Server instance where all components run together within
the same machine or host and within the same docker network.
A simple and integrated MariaDB setup that uses just the official MariaDB Docker image, and a reverse proxy using the official nginx:latest Docker image. 
This setup uses docker compose to build and run all needed containers. The docker image for SEB Server is been downloaded from docker hub.

::

        installation strategy sub-directory.........docker/prod/bundled/
        seb-server configuration....................docker/prod/bundled/config/spring
        maria-db configuration......................docker/prod/bundled/config/mariadb
        reverse-proxy configuration.................docker/prod/bundled/config/nginx
        jmx configuration...........................docker/prod/bundled/config/jmx
        single server setup.........................yes
        secured (TLS)...............................configurable (needs own TLS certificates)
        integrated mariadb service..................yes (can be configured to connect to external DB)
        initial data setup..........................auto generated Institution and SEB Administrator
        data setup on reload........................Spring - Flyway migration setup
        integrated reverse proxy....................yes, with separated Port mapping for new services
        recommended machine requirements............CPU: x86_64/4 Cores/2-3 GHz, Mem 32GB, Disk Space min 100GB
        
**Requirements:**

- Git installation if not already installed
- Docker installation if not already installed

.. note::

    The newest versions of Git and Docker are recommended. For installation see:
        |    - Git : https://www.atlassian.com/git/tutorials/install-git
        |    - Docker : https://docs.docker.com/install/
        |    - Docker-Compose : https://docs.docker.com/compose/install/
        
**Setup:**

This setup contains a docker-compose.yml file that orchestrates the setup of the needed containers/services and a configuration sub-directory
for all needed components. The docker image for SEB Server will be automatically fetched from docker-hub.
For MariaDB the official public image is used to build-up the MariaDB server service.
The setup also contains a .env File that contains all settings that needs to be set to run with the default configuration.

**Configuration**

The configuration for each service is located in the local /config directory separated by folders for each concern. The "spring" folder
contains all the Spring and Spring-Boot based configurations and is used by the seb-server service. The "mariadb" folder contains the
usual mariadb configuration file that is loaded from the seb-server-mariadb service on startup. The "nginx" folder contains a usual 
nginx reverse-proxy configuration and is used by the reverse-proxy service. The "jmx" folder contains JMX related configurations and is also
used by the seb-server service if JMX is enabled. For more details on how to configure each service see :ref:`configuration-label`.

**Installation:**

1. Login to the target/remote host where the SEB Server demo shall be installed, on windows open a command or PowerShell, create a working directory and navigate into it.
    
 .. code-block:: bash
    
    $ mkdir sebserver
    $ cd sebserver
        
2. Get a clone of the seb-server-setup repository and navigate to the demo setup folder

 .. code-block:: bash
    
    $ git clone -b v1.1-latest https://github.com/SafeExamBrowser/seb-server-setup.git
    $ cd seb-server-setup/docker/prod/bundled/dockerhub/

3. Open the existing .env file and apply the needed settings for the setup as the .env file example shows:

    SEBSERVER_PWD: The SEB Server password is needed for various reasons. This password must be always the same and should be securely stored somewhere
    DB_SA_PWD=somePW: The super user password for the data base connection. If you don't want to use the super user to connect to database you need to configure this within the docker-compose file for all services that needs a database connection.
    DNS_NAME: The DNS name where your host is available from the Internet
    BASE_PORT: The default port for HTTP connection. Usually 443 that is default for HTTPS connections
    SPS_WEB_PORT: The additional open SSL port for the screen proctoring webservice API
    SPS_GUI_PORT: The additional open SSL port for the screen proctoring guiservice (graphical user interface)

    .. note::
        The passwords must be given also when the service is stopped and restarted again. You can either let the .env file
        be within the installation directory as is. Or you can delete the .env file from the host and copy or create it again when
        an update or restart of the container is needed. Note that it is very important that the SEBSERVER_PWD do not change and the same
        SEBSERVER_PWD is used for updates and restarts as it was for the initial setup. Otherwise data will be lost due to encryption with
        unknown or incorrect passwords. The password should be in the responsibility of a system administrator and handled with appropriate care.

4. Go to the nginx configuration folder and put your own valid SSL certificates to the "cert" subdirectory. The integrated reverse proxy will then use this certificates to secure all given connection ports.
If you have changed the default ports in step 3. you must also change it for the reverse proxy by open the app.conf file and change the port settings there accordingly.

5. Pull the Docker images from Dockerhub

 .. code-block:: bash
    
    $ docker-compose pull

6. Start the services. If you want to give the needed password here instead within an .env file, you can add them as environment variables within the call

 .. code-block:: bash
    
    $ docker-compose up -d

or

 .. code-block:: bash
    
    $ SEBSERVER_PWD=somePassword DB_SA_PWD=passwordForDataBase docker-compose up -d 
        
7. Check if the containers are started and running. The output should look something like the following.

 .. code-block:: bash
    
    $ docker ps --all
    $ docker logs ${container name}
        
.. image:: images/dockerServicesTestUp.png
    :align: center
    :target: https://raw.githubusercontent.com/SafeExamBrowser/seb-server-setup/rel-2.0/docs/images/docker-ps.png
        
8. If there where no changes to the default configuration the SEB Server is now running on port 443/4431/4432 and can be accessed with a browser on http(s)://server-address
   There is one pre-configured institution and one user-account with SEB Server Administrator role to manage the server. 
   The username and generated password of the initial admin account can be found on the logs:

   .. code-block:: bash

       $ docker logs seb-server

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


For a complete initial log guide pleas read: :ref:`logguide-label`

.. note::
    We highly recommend to change the generated password from the initial admin account immediately after first login. 




Bundled Setup with internal Service routing
...........................................

TODO








.. _installkind-label:

Cloud based Kubernetes Kind Example
........................

This setup provides an example for a distributed and scalable cloud setup with Kubernetes and Kind.
You can use this as a staring point or template for a Kubernetes based production ready setup.

.. note::
    Kubernetes secrets should never get into Git unencrpyted. This is only an example.
    One solution to encrypt secrets for Git and decrypt it during deployment into the
    cluster is [SealedSecrets](https://github.com/bitnami-labs/sealed-secrets).

::

        installation strategy sub-directory.........docker/prod/cloud/kind-example
        seb-server configuration....................docker/prod/cloud/kustomize/config/
        single server setup.........................false
        secured (TLS)...............................false
        integrated mariadb service..................true
        initial data setup..........................auto generated Institution and SEB Administrator
        integrated reverse proxy....................ingress
        automated backup-restore service............false
        exposed database port.......................false
        exposed JMX port............................false


**Requirements:**

- Git if not already installed
- Docker and Docker-Compose if not already installed

.. note::

    The newest versions of Git and Docker are recommended. For installation see:
        |    - Git : https://www.atlassian.com/git/tutorials/install-git
        |    - Docker : https://docs.docker.com/install/
        |    - Docker-Compose : https://docs.docker.com/compose/install/


- kind: https://kind.sigs.k8s.io/docs/user/quick-start/#installing-from-release-binaries
- kubectl: https://kubernetes.io/docs/tasks/tools/
- kustomize: https://github.com/kubernetes-sigs/kustomize/releases

Kind, kubectl and kustomize can be installed as binaries so that they are available in the CLI console

.. note::
    Kind = Kubernetes In Docker. So this will work as a kubernetes cluster within a docker-container.

**Setup:**

The demo setup consists of some kind setup descriptors, the kustomization.yaml and a deploy script.
The kustomization.yaml file first sets common values which are modified most: image version and replica count.
It then uses the base config published in this repository (docker/ethz/cloud/kustomize/) and extends it to a demo deployment.

**Configuration**

The configuration for each service is located in docker/ethz/cloud/kustomize/config/ directory separated by folders for each service.
The different services are webservice, guiservice and mariadb. This corresponds to the three kubernetes services that are setup by this demo.
Each service configuration folder contains then separate configuration folder for each individual concern of the service.
"spring" folder contains all the Spring and Spring-Boot based configurations and the jmx folder contains configuration for JMX binding (experimental)

.. note::
    If you need TLS encryption which is specific to your setup environment, plese refer to https://cert-manager.io/docs/
    There are also some commented placholder for certificate handling within the file: ingress.yml within the example

**Installation:**

1. Login to the target/remote host where the SEB Server demo shall be installed, on windows open a command or PowerShell, create a working directory and navigate into it.

 .. code-block:: bash

    $ mkdir sebserver
    $ cd sebserver

2. Get a clone of the seb-server-setup repository and navigate to the demo setup folder

 .. code-block:: bash

    $ git clone https://github.com/SafeExamBrowser/seb-server-setup.git -b v1.4-latest
    $ cd seb-server-setup/docker/demo/cloud/kind-example

3. If some specific configuration is needed, this can be done within this step. See :ref:`configuration-label` for more details on how to configure the services.
Spring based configuration settings can be set either in the respective application-prod.properties files in docker/ethz/cloud/kustomize/config/
or via override in docker/demo/cloud/kind-example/kustomization.yml within the respective service.

.. note::
    The spring property names can be overriden in the respective yml by change the "." separator with a "_" separator.

4. Create the docker-container with the Kubernetes cluster and initialize Ingress.

- Linux: exec kind_deploy.sh

 .. code-block:: bash

    $ .\kind_deploy

- Windows:

 .. code-block:: bash

    $ kind create cluster --config=kindcluster.yaml
    $ kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml

Now you should be able to show the Ingress pods:

 .. code-block:: bash

    $ kubectl get pods -n ingress-nginx

5. Create a namespace for the services:

 .. code-block:: bash

    $ kubectl create ns seb-server-prod

6. Build the services from the template:

 .. code-block:: bash

    $ kustomize build . | kubectl apply -f -

.. note::
    If there is an error on the kustomize startup, make shure the ingress has already started propperly by using: $ kubectl get pods -n ingress-nginx
    and try again to run the kustomize template.

Now you should be able to show the services, pods and logs with:

 .. code-block:: bash

    $ kubectl get pods -n seb-server-prod
    $ kubectl get svc -n seb-server-prod
    $ kubectl logs seb-guiservice-prod-[f45588cfc-4944h] -n seb-server-prod

8. If there where no changes to the default configuration the SEB Server is now running on port 80 and can be accessed with a browser on http(s)://server-address
   There is one pre-configured institution and one user-account with SEB Server Administrator role to manage the server.
   The username and generated password of the initial admin account can be found on the webservice logs:

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

9. You can delete the whole kind cluster with:

 .. code-block:: bash

    $ kind delete cluster


.. _logguide-label:

Setup Initial Log Guide
-----------------------

**SEB Server Service Startup Log**

get with docker log seb.server. Example and comments:

::
    08:00:38.110 INFO  [main]:[ch.ethz.seb.sebserver.SEBServer] Started SEBServer in 12.343 seconds (JVM running for 12.825)
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   ___  ___  ___   ___
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->  / __|| __|| _ ) / __| ___  _ _ __ __ ___  _ _
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->  \__ \| _| | _ \ \__ \/ -_)| '_|\ V // -_)| '_|
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->  |___/|___||___/ |___/\___||_|   \_/ \___||_|
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Version: v2.0-stable-f632cc9
    08:00:38.118 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Active profiles: [gui, ws, prod-ws, prod-gui, prod]
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Context Path: /
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *** GUI Service starting up...                        ***
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.119 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Webservice connection: http://localhost:8080/admin-api/v1
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> GUI service internal connection : http://0.0.0.0:8080
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> GUI service external connection : https://localhost:443
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> GUI service endpoint : /gui
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Webservice admin API endpoint: /admin-api/v1
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Webservice exam API endpoint: /exam-api
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Webservice admin API basic access: --guiClient--
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> SEB Server GUI running on bundled setup
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *** GUI Service successfully successfully started up! ***
    08:00:38.120 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.121 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.121 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *** Webservice starting up...                         ***
    08:00:38.121 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.121 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.121 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Register Webservice: 9c68d959-b0c0-4611-b5cb-c8d39cfe58c6_v2.0-stable-f632cc9
    08:00:38.226 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Successfully register Webservice instance. uuid: 9c68d959-b0c0-4611-b5cb-c8d39cfe58c6_v2.0-stable-f632cc9, address: 172.19.0.4
    08:00:38.226 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.226 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> ** Migration check START **
    08:00:38.226 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Check database status
    08:00:38.311 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Found pending migrations: 2
    08:00:38.311 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.311 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> **** Start Migration ************************************
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Migration finished, new current version is: 29 --> set charset utf8mb4 v2 0
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> **** End Migration **************************************
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> ** Migration check END **
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Initialize Services...
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> **** Run data-base integrity checks ****
    08:00:38.612 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.615 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Apply check: OrientationTableDuplicatesCheck / Checks if there are duplicate entries in the orientation table by using the config_attribute_id and template_id to identify duplicates.
    08:00:38.650 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Result: Fixed duplicates by deletion: [990]
    08:00:38.651 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Apply check: ClipboardSEBSettingsGUICheck / Check if clipboardPolicy SEB Setting is missing in the GUI and if so add it to GUI
    08:00:38.654 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Result: clipboardPolicy SEB Setting detected in GUI
    08:00:38.657 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Apply check: ViewTableDuplicatesCheck / Checks if there are duplicate entries in the view table by using the name and template_id to identify duplicates.
    08:00:38.663 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Result: OK
    08:00:38.663 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Apply check: DowngradeSEBSettingsCheck / Check if there are additional SEB Settings orientations within the database that do not match the once for the current SEB Server version.
    08:00:38.663 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Result: No additional SEB Settings orientations for downgrading found.
    08:00:38.663 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Apply check: TableCharsetCheck / Checks the char-set and collation of DB tables if correct utf8mb4_general_ci is set
    08:00:38.663 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Result: Skip check since this is done by a migration task
    08:00:38.714 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------>
    08:00:38.714 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Activate exam run controller background task
    08:00:38.714 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Task runs on an interval of 60000 milliseconds
    08:00:38.714 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] --------> Real exam running time span is expanded on 3600000 before start and 3600000 milliseconds after ending
    08:00:38.722 INFO  [main]:[ch.ethz.seb.sebserver.webservice.servicelayer.dao.impl.WebserviceInfoDAOImpl] Set webservice 9c68d959-b0c0-4611-b5cb-c8d39cfe58c6_v2.0-stable-f632cc9 as master
    08:00:38.724 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------>
    08:00:38.724 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Activate SEB lost-ping-event update background task on a fix rate of: 5000 milliseconds
    08:00:38.725 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------>
    08:00:38.725 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> Run SEBInstructionService...
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> No pending SEB client instructions found on persistent storage
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *** Webservice Info:                                  ***
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> JDBC connection pool max size: 100
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.731 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Configured Features:
    08:00:38.733 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.auditlogs --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.institution --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.user.account --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.user.account.self.registering --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.user.account.self.registering.autoactivation --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   admin.user.administration --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   config.certificate --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   config.connection.configuration --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   config.exam.configuration --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   config.template --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.administration --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.ask --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.connection.config --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.monitoring.indicators --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.noLMS --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.seb.clientgroups --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.seb.liveProctoring --> false
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.seb.restriction --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.seb.screenProctoring --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   exam.template --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.quiz.lookup --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.ANS_DELFT --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.MOCKUP --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.MOODLE --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.MOODLE_PLUGIN --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.OLAT --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   lms.setup.type.OPEN_EDX --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.finished.exams --> true
    08:00:38.734 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.overall.export --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.cancel.connection --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.client.filter --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.detailview --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.detailview.logexport --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.issue.filter --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.live.proctoring --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.lockscreen --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.quit --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.screen.proctoring --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exam.state.filter --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->   monitoring.running.exams --> true
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Working with ping service: BLOCKING
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Server address: 0.0.0.0
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Server port: 8080
    08:00:38.735 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Local-Host address: 172.19.0.4
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Local-Host name: 4c15d0736cde
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Remote-Host address: 127.0.0.1
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Remote-Host name: localhost
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Context Path: /
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> External-Host URL: https://localhost:443
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Autologin URL: https://localhost:443
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> LMS-External-Address-Alias: {}
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> HTTP Scheme https
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Access-Tokens:
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> admin API access token validity: 3600s
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> admin API refresh token validity: 25200s
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> exam API access token validity: 43200s
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Screen Proctoring Bundle enabled: true
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ------> ScreenProctoringServiceBundle [bundled=true, serviceURL=https://localhost:4431, clientId=sebserverClient, apiAccountName=SEBServerAPIAccount]
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.736 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> Property Override Test: This is a basic bundled productive setup
    08:00:38.737 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ---->
    08:00:38.737 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************
    08:00:38.737 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *** Webservice successfully started up!               ***
    08:00:38.737 INFO  [main]:[ch.ethz.seb.SEB_SERVER_INIT] ----> *********************************************************


 **SPS Webservice example Log**
::

    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT]  _______ _______ _______      _______ _______ ______   __   __ ___ _______ _______
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |       |       |  _    |    |       |       |    _ | |  | |  |   |       |       |
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |  _____|    ___| |_|   |    |  _____|    ___|   | || |  |_|  |   |       |    ___|
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] | |_____|   |___|       |    | |_____|   |___|   |_||_|       |   |       |   |___
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |_____  |    ___|  _   |     |_____  |    ___|    __  |       |   |      _|    ___|
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT]  _____| |   |___| |_|   |     _____| |   |___|   |  | ||     ||   |     |_|   |___
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |_______|_______|_______| ___|_______|_______|___|  |_|_|___|_|___|_______|_______|____ _______ _______ ______   ___ __    _ _______
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |       |       |    _ | |       |       |  |  | |    |       |    _ | |       |       |       |       |    _ | |   |  |  | |       |
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |  _____|       |   | || |    ___|    ___|   |_| |    |    _  |   | || |   _   |       |_     _|   _   |   | || |   |   |_| |    ___|
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] | |_____|       |   |_||_|   |___|   |___|       |    |   |_| |   |_||_|  | |  |       | |   | |  | |  |   |_||_|   |       |   | __
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |_____  |      _|    __  |    ___|    ___|  _    |    |    ___|    __  |  |_|  |      _| |   | |  |_|  |    __  |   |  _    |   ||  |
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT]  _____| |     |_|   |  | |   |___|   |___| | |   |    |   |   |   |  | |       |     |_  |   | |       |   |  | |   | | |   |   |_| |
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] |_______|_______|___|  |_|_______|_______|_|  |__|    |___|   |___|  |_|_______|_______| |___| |_______|___|  |_|___|_|  |__|_______|
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ----> Version: v1.0-stable-9abbf93
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ----> Active profiles: [prod]
    2024-08-28 10:00:35 28.08.2024 08:00:35.927 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:35 28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ----> Context Path: /
    2024-08-28 10:00:35 28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:35 28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    2024-08-28 10:00:35 28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ----> *** Webservice starting up...                         ***
    2024-08-28 10:00:35 28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    2024-08-28 10:00:35 28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:35 28.08.2024 08:00:35.928 INFO  [main]:[SERVICE_INIT] ----> Register Webservice: 96487e9f-e503-4d56-bcbd-7688f38ce12d_v1.0-stable-9abbf93
    2024-08-28 10:00:35 28.08.2024 08:00:35.934 INFO  [main]:[com.zaxxer.hikari.HikariDataSource] HikariPool-1 - Starting...
    2024-08-28 10:00:36 28.08.2024 08:00:36.015 INFO  [main]:[com.zaxxer.hikari.HikariDataSource] HikariPool-1 - Start completed.
    2024-08-28 10:00:36 28.08.2024 08:00:36.078 WARN  [main]:[org.mariadb.jdbc.message.server.ErrorPacket] Error: 1146-42S02: Table 'SEBScreenProctoring.webservice_server_info' doesn't exist
    2024-08-28 10:00:36 28.08.2024 08:00:36.168 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:36 28.08.2024 08:00:36.168 INFO  [main]:[SERVICE_INIT] ----> **** Migration check START ******************************
    2024-08-28 10:00:36 28.08.2024 08:00:36.169 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:36 28.08.2024 08:00:36.169 INFO  [main]:[SERVICE_INIT] ----> Check database status
    2024-08-28 10:00:36 28.08.2024 08:00:36.171 INFO  [main]:[org.flywaydb.core.internal.license.VersionPrinter] Flyway Community Edition 7.8.2 by Redgate
    2024-08-28 10:00:36 28.08.2024 08:00:36.214 INFO  [main]:[org.flywaydb.core.internal.database.base.BaseDatabaseType] Database: jdbc:mariadb://seb-server-mariadb/SEBScreenProctoring (MariaDB 10.5)
    2024-08-28 10:00:36 28.08.2024 08:00:36.276 INFO  [main]:[SERVICE_INIT] ----> Found pending migrations: 4
    2024-08-28 10:00:36 28.08.2024 08:00:36.277 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    2024-08-28 10:00:36 28.08.2024 08:00:36.277 INFO  [main]:[SERVICE_INIT] ----> **** Start Migration ************************************
    2024-08-28 10:00:36 28.08.2024 08:00:36.277 INFO  [main]:[org.flywaydb.core.internal.license.VersionPrinter] Flyway Community Edition 7.8.2 by Redgate
    2024-08-28 10:00:36 28.08.2024 08:00:36.299 INFO  [main]:[org.flywaydb.core.internal.license.VersionPrinter] Flyway Community Edition 7.8.2 by Redgate
    2024-08-28 10:00:36 28.08.2024 08:00:36.310 INFO  [main]:[org.flywaydb.core.internal.command.DbValidate] Successfully validated 4 migrations (execution time 00:00.003s)
    2024-08-28 10:00:36 28.08.2024 08:00:36.320 INFO  [main]:[org.flywaydb.core.internal.schemahistory.JdbcTableSchemaHistory] Creating Schema History table `SEBScreenProctoring`.`flyway_schema_history` ...
    2024-08-28 10:00:36 28.08.2024 08:00:36.378 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Current version of schema `SEBScreenProctoring`: << Empty Schema >>
    2024-08-28 10:00:36 28.08.2024 08:00:36.400 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Migrating schema `SEBScreenProctoring` to version "1 - create tables v1 0"
    2024-08-28 10:00:36 28.08.2024 08:00:36.408 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.oauth_access_token' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.432 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.oauth_refresh_token' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.448 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.user' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.470 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.screenshot_data' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.494 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.screenshot' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.518 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.seb_group' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.544 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.session' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.576 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.client_access' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.597 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.entity_privilege' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.625 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.additional_attribute' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.642 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.webservice_server_info' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.659 WARN  [main]:[org.flywaydb.core.internal.sqlscript.DefaultSqlScriptExecutor] DB: Unknown table 'SEBScreenProctoring.audit_log' (SQL State:  - Error Code: 1051)
    2024-08-28 10:00:36 28.08.2024 08:00:36.693 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Migrating schema `SEBScreenProctoring` to version "3 - add UUID to client access"
    2024-08-28 10:00:36 28.08.2024 08:00:36.724 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Migrating schema `SEBScreenProctoring` to version "4 - add exam table"
    2024-08-28 10:00:36 28.08.2024 08:00:36.901 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Migrating schema `SEBScreenProctoring` to version "5 - set charset utf8mb4"
    2024-08-28 10:00:36 28.08.2024 08:00:36.965 INFO  [main]:[org.flywaydb.core.internal.command.DbMigrate] Successfully applied 4 migrations to schema `SEBScreenProctoring`, now at version v5 (execution time 00:00.592s)
    2024-08-28 10:00:36 28.08.2024 08:00:36.967 INFO  [main]:[org.flywaydb.core.internal.license.VersionPrinter] Flyway Community Edition 7.8.2 by Redgate
    2024-08-28 10:00:36 28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ----> Migration finished, new current version is: 5 --> set charset utf8mb4
    2024-08-28 10:00:36 28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ----> **** End Migration **************************************
    2024-08-28 10:00:36 28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    2024-08-28 10:00:36 28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:36 28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ----> **** Migration check END ********************************
    2024-08-28 10:00:36 28.08.2024 08:00:36.982 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.007 INFO  [main]:[SERVICE_INIT] ----> Successfully register Webservice instance. uuid: 96487e9f-e503-4d56-bcbd-7688f38ce12d_v1.0-stable-9abbf93, address: 172.19.0.5
    2024-08-28 10:00:37 28.08.2024 08:00:37.007 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.007 INFO  [main]:[SERVICE_INIT] ----> **** Initialize Services... *****************************
    2024-08-28 10:00:37 28.08.2024 08:00:37.007 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.015 INFO  [main]:[SERVICE_INIT] ------> Activate background update task
    2024-08-28 10:00:37 28.08.2024 08:00:37.015 INFO  [main]:[SERVICE_INIT] ------> Task runs on an update interval of 15000
    2024-08-28 10:00:37 28.08.2024 08:00:37.039 INFO  [main]:[ch.ethz.seb.sps.server.datalayer.dao.impl.WebserviceInfoDAOImpl] Set webservice 96487e9f-e503-4d56-bcbd-7688f38ce12d_v1.0-stable-9abbf93 as master
    2024-08-28 10:00:37 28.08.2024 08:00:37.042 INFO  [main]:[SERVICE_INIT] -------->
    2024-08-28 10:00:37 28.08.2024 08:00:37.042 INFO  [main]:[SERVICE_INIT] --------> This instance has become master!
    2024-08-28 10:00:37 28.08.2024 08:00:37.042 INFO  [main]:[SERVICE_INIT] -------->
    2024-08-28 10:00:37 28.08.2024 08:00:37.061 INFO  [main]:[SERVICE_INIT] ----> Screenshot Store: 2 workers with update-interval: 1000 initialized
    2024-08-28 10:00:37 28.08.2024 08:00:37.061 INFO  [main]:[SERVICE_INIT] ----> SessionServiceHealthControl initialized
    2024-08-28 10:00:37 28.08.2024 08:00:37.064 INFO  [main]:[SERVICE_INIT] ----> Screenshot FULL_RDBMS Store: initialized
    2024-08-28 10:00:37 28.08.2024 08:00:37.064 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.064 INFO  [main]:[SERVICE_INIT] ----> **** Services initialized *******************************
    2024-08-28 10:00:37 28.08.2024 08:00:37.064 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.071 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.071 INFO  [main]:[SERVICE_INIT] ----> Create Initial SEB Server API Account with name: SEBServerAPIAccount
    2024-08-28 10:00:37 28.08.2024 08:00:37.072 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.109 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    2024-08-28 10:00:37 28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ----> *** Webservice Info:                                  ***
    2024-08-28 10:00:37 28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    2024-08-28 10:00:37 28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ----> JDBC connection pool max size: 10
    2024-08-28 10:00:37 28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ----> Admin access token validity seconds: 3600
    2024-08-28 10:00:37 28.08.2024 08:00:37.110 INFO  [main]:[SERVICE_INIT] ----> Admin refresh token validity seconds: 25200
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> SEB session access token validity seconds: 43200
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Webservice context path: /
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Internal Server address: 0.0.0.0
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Internal Server port: 8090
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Local-Host address: 172.19.0.5
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Local-Host name: 47e92ba78184
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Remote-Host address: 127.0.0.1
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Remote-Host name: localhost
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> External service URI: https://localhost:4431
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ----> Remote-Host name: localhost
    2024-08-28 10:00:37 28.08.2024 08:00:37.111 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ----> Setup: distributed / cloud setup
    2024-08-28 10:00:37 28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ----> Bundle: SEB Server bundle
    2024-08-28 10:00:37 28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ---->
    2024-08-28 10:00:37 28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ----> *********************************************************
    2024-08-28 10:00:37 28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ----> *** Webservice successfully started up!               ***
    2024-08-28 10:00:37 28.08.2024 08:00:37.112 INFO  [main]:[SERVICE_INIT] ----> *********************************************************