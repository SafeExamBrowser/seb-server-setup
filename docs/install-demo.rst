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
        exposed JMX port............................9090


**Requirements:**

- Git if not already installed
- Docker and Docker-Compose if not already installed

.. note::

    The newest versions of Git and Docker are recommended. For installation see:
        |    - Git : https://www.atlassian.com/git/tutorials/install-git
        |    - Docker : https://docs.docker.com/install/
        |    - Docker-Compose : https://docs.docker.com/compose/install/
    
**Setup:**

The docker setup consists of a Dockerfile that defines and builds an image for the SEB Server and a docker-compose.yml file that orchestrates the setup of the needed containers/services. 
The build of the image for SEB Server first clones the defines version of the SEB Server source repository from GitHub and build the SEB Server with Maven that leads to a self-contained, spring-boot-based, 
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
 
        $ git clone -b v1.1-latest https://github.com/SafeExamBrowser/seb-server-setup.git
        $ cd seb-server-setup/docker/demo/basic

3. If some specific configuration is needed, this can be done within this step. See :ref:`configuration-label` for more details on how to configure the services

.. note::
    Check that the spring configuration properties "sebserver.webservice.http.external.*" are set correctly to the URL where the SEB Server 
    can be accessed from the public Internet. Usually your server has an URL like https://example.com. so use "https" for the scheme, "example.com"
    for the servername and specify the port if it differs from default port (80/443).
    
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

        installation strategy sub-directory.........docker/demo/cloud/kind-example
        seb-server configuration....................docker/ethz/cloud/kustomize/config/
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
    
    $ git clone https://github.com/SafeExamBrowser/seb-server-setup.git -b v1.3-latest
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

