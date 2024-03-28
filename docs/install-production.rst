Production
----------

**Info:**


For production we provide currently three different default setups, all of them for bundled environments. 

.. note::
    There is a new SEB Server setup approach since SEB Server version 1.2 where the docker image is not part of the setup repository
    anymore but is built and published by the main SEB Server repository within docker hub. 
    
    If you are new to SEB Server and this is your first installation, we recommend to stick with the new approach that can be found
    in the setup directory docker/prod/bundled/dockerhub/
    
    It is still possible to use the older approach if you already have setup your SEB Server and are going to update the installation
    to another version.
    
The first bundled setup is the usual basic setup with no HTTPS/TLS in place that can be used if the SEB Server shall be running in 
an environment that is already protected with an end to end TLS handling. Usually SEB Server will then run behind a reverse-proxy that handles the
TLS encryption on HTTPS and forward the decrypted traffic directly to the SEB Server on HTTP. We recommend such a setup because it is usually also
preferred by system administration and may already be in place within your IT environment. The other setup "tls" integrates the HTTPS/TLS handling
with the docker setup of SEB Server. The reverse-proxy that usually shadows the SEB Server within the docker-compose setup is used to terminate the
TLS handling and you have to configure and manage your certificates within the setup as described later in detail.

.. note::
    If you want to setup SEB Server for a cloud environment you have to adapt the available docker and docker-compose configurations to apply to
    your best-practices and standards. Please for now have a look into the testing setup directory docker/testing/cloud/ where you can find a
    experimental setup for cloud environments with separated database, webservice and guiservice.
    
    
    
Bundled Setup (one host)
...............................

This is the preferred way to setup a bundled SEB Server instance where all components (database, guiservice and webservice) run together within 
the same machine or host and within the same docker network.
A simple and integrated MariaDB setup that uses just the official MariaDB Docker image, and a reverse proxy using the official nginx:latest Docker image. 
This setup uses docker compose to build and run all needed containers. The docker image for SEB Server is been downloaded from docker hub.

::

        installation strategy sub-directory.........docker/prod/bundled/dockerhub/
        seb-server configuration....................docker/prod/bundled/dockerhub/config/spring
        maria-db configuration......................docker/prod/bundled/dockerhub/config/mariadb
        reverse-proxy configuration.................docker/prod/bundled/dockerhub/config/nginx
        jmx configuration...........................docker/prod/bundled/dockerhub/config/jmx
        single server setup.........................true
        secured (TLS)...............................configurable (needs own TLS certificates)
        integrated mariadb service..................true
        initial data setup..........................auto generated Institution and SEB Administrator
        data setup on reload........................Spring - Flyway migration setup
        integrated reverse proxy....................true
        automated backup-restore service............false
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

3. If some specific configuration is needed, this can be done within this step. See :ref:`configuration-label` for more details on how to configure the services.
   At least you should check the application-prod.properties file in the spring config directory, if everything is set properly.
   
   Also set the mandatory settings defined in the docker-compose.yml according to your setup:
   
- sebserver_webservice_http_external_scheme: Defines the scheme of the external URL (http or https) 
- sebserver_webservice_http_external_servername: Defines the server name of the external URL (e.g.: sebserver.ethz.ch)
- sebserver_webservice_http_external_port: Defines the port of the external URL. Mandatory only if it differs from default (http:80,https:433)

4. build the docker images. 

 .. code-block:: bash
    
    $ docker-compose build --no-cache
        
5. Now we have to give the needed passwords for an initial startup. This can either be done by creating an .env file on the working directory
   or by give the needed passwords as environment variables on the service startup within the next step.

 .. code-block:: bash
    $ printf %s "SEBSERVER_PWD=somePassword\nDB_SA_PWD=passwordForDataBase" >> .env

.. note::
    The passwords must be given also when the service is stopped and restarted again. You can either let the .env file 
    be within the installation directory as is. Or you can delete the .env file from the host and copy or create it again when
    an update or restart of the container is needed. Note that it is very important that the SEBSERVER_PWD do not change and the same
    SEBSERVER_PWD is used for updates and restarts as it was for the initial setup. Otherwise data will be lost due to encryption with
    unknown or incorrect passwords. The password should be in the responsibility of a system administrator and handled with appropriate care.

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
    :target: https://raw.githubusercontent.com/SafeExamBrowser/seb-server-setup/master/docs/images/dockerServicesTestUp.png
        
8. If there where no changes to the default configuration the SEB Server is now running on port 80 and can be accessed with a browser on http(s)://server-address
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


.. _installseparated-label:

Separated Setup
....................

This install provides separated docker and docker-compose setups for each involved service. This setup is
mostly recommend when you want to setup the SEB Server components on different hosts for better performance
but do not have the ability to work on the cloud with Kubernetes for example.

::

        installation strategy sub-directory.........docker/prod/separated/
        maria-db setup-directory....................docker/prod/separated/db/
        seb-server webservice setup-directory.......docker/prod/separated/webservice/
        seb-server guiservice setup-directory.......docker/prod/separated/guiservice/
        single server setup.........................false
        integrated mariadb service..................false
        initial data setup..........................auto generated Institution and SEB Administrator
        data setup on reload........................Spring - Flyway migration setup
        integrated reverse proxy....................false
        automated backup-restore service............false
        recommended machine requirements............CPU: x86_64/4 Cores/2-3 GHz, Mem 32GB, Disk Space min 100GB

.. note::
    If you are interested in setting up SEB Server for the cloud and use Kubernetes, the next chapter gives you a Kind example for this.

The three involved Services on SEB Server are:

- The Database: This is a MariaDB database that can also be external or already existing.
The other services needs access to the database and must also be able to create and modify a new data schema.
- The Webservice: This service implements the main part of SEB Server (business functions) and must have access
to the Database service. This service provides then an HTTP Rest API for GUI services.
- The Guiservice. This service implements the SEB Server user interface and must have access to the Webservice.

The above bundled installation puts all this three services into one single docker-compose installation and all
services run on the same host. But if you want to split the services up on different hosts you can start with this
examples to setup each service on a different host. The setup procedure is the same for all services, like described
in the above bundled setup, although the different services needs different configurations.

TLS setup is not part of this setup since this is mostly be done on the host level. If not, you can relay on the reverse
proxy configuration of the bundled setup to setup each service with its own reverse proxy that terminates the TLS
connection within the docker-network.

Please have a look at each of the above described service installation directory and in the docker-compose.yml file of
the respective setup directory. There you find the environment variables that has to be set specific to your setup.
Like in the example:

 .. code-block:: docker-compose

    version: '3.5'
    services:
      seb-webservice:
          image: "anhefti/seb-server:v1.6-latest"
          container_name: seb-webservice
          volumes:
            - seb-server-config:/sebserver/config
            - ./config/spring:/sebserver/config/spring
            - ./config/jmx:/sebserver/config/jmx
          environment:
            - JAVA_HEAP_MIN=1G
            - JAVA_HEAP_MAX=8G
            - JMX_PORT=
            - spring_profiles_active=ws,prod-ws,prod

            # Set your passwords for DB connection and SEB Server encryption here
            - sebserver_password=${SEBSERVER_PWD}
            - sebserver_mariadb_password=${DB_SA_PWD}

            # Set the below settings for database connection.
            # NOTE: This can also point to an internal address when the db server is in the same network
            - datastore_mariadb_server_address=seb-server-mariadb
            - datastore_mariadb_server_port=3306
            - spring_datasource_username=root

            # Set the below URL component settings from where the web-service is externally available
            # NOTE: This must be the address from that the service is externally available (not network internal address)
            - sebserver_webservice_http_external_scheme=https
            - sebserver_webservice_http_external_servername=seb-webservice.ch

            # This uses the new ping batch processing strategy for improve performance for bundled setups.
            # To reset to old ping blocking processing strategy set BLOCKING instead of BATCH here.
            - sebserver_webservice_ping_service_strategy=BATCH

            # JMX settings
            - MONITORING_MODE=false
            #- JMX_PORT=9090
          ports:
            - 8080:8080
            #- 9090:9090 # Connect this port to host if you want to use JMX (MONITORING_MODE=true)
          networks:
            - seb-server-network
          restart: unless-stopped

Also don't forget to set needed passwords in the respective ".env" file for the installation and adapt the files in
the config directory according to your needs.


.. _installkind-label:

Kubernetes Kind Example
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

