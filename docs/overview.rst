Overview
========

Overall Architecture
--------------------

SEB Server is a enterprise server application written in Java and uses `Spring <https://spring.io/>`_ and Spring Boot as a main-framework. 

The image below shows the overall architecture of the SEB Server which is basically split into two main parts, 
a webservice and a Graphical User Interface (GUI) service. This two services can be deployed together in one server 
instance or they can be deployed separately with the ability to scale the webservice for example up to the specified needs.

.. image:: images/overall-architecture.png
    :align: center
    :target: https://raw.githubusercontent.com/SafeExamBrowser/seb-server-setup/master/docs/images/overall-architecture.png
    
The webservice uses a well defined REST API interface over HTTP and mainly JSON as a data structure for communication. 
The webservice also implements OAuth2 as a standard authentication method. 
The GUI service is also written in Java and uses Eclipse RWT to create the HTML front-end and drive upon the REST API of 
the webservice. While the webservice externalize state as much as possible (except some internal caching) to make horizontal 
scaling possible and easy, the GUI service has a session-state for the logged in users

.. _installation-repo-label:

Installation Repository
-----------------------

The installation and setup of SEB Server depends on the service needs and the local environment and infrastructure that exists 
and can be used. Because the setup can vary from a simple in-house all-in-one server setup to a setup that serves many institutions 
and must be horizontally scalable, the seb-server-setup repository contains pre-configured docker-based SEB Server setups for the most 
common cases and can easily be extended by adding new installation setup. 

The seb-server-setup repository structure defines the installation type on the fist directory level. Currently only docker-based 
installations are supported. On the second directory level defines installation purpose categories like "demo" for setting up a 
SEB Server for demonstrations, "testing" or "prod" for testing purposes or final productivity setup. The third and forth directory level, 
if existing, defines then different SEB Server setups like "stand-alone" or "distributed" and finally the encryption (TLS) method that 
should be used. Below is an example of the seb-server-setup directory structure. 

::
    
    - docker
        - demo
        - prod
          - distributed
             - [not yet available]
          - standalone
             - letsencrypt [experimental]
             - noencrypt
             - selfsigned [experimental]
        - testing
          - noencrypt
          - selfsigned [experimental]
        - ..?
      
At each endpoint exists a root installation directory with docker-files for the services, a docker-compose definition and a "config" directory
containing service related configurations like Spring configuration for the SEB Server, MariaDB configuration for the database and/or
reverse proxy configuration.

**HTTPS / TLS Configuration**

There are manly two ways/strategies to configure HTTPS / TLS for a SEB Server;

    - The HTTPS / TLS is handled by a reverse-proxy that is exposed to the Internet and forwards the requests over HTTP to the SEB Server that in this
    case has only an simple HTTP connector and is not exposed to the Internet but to the internal network with the reverse proxy
    - The HTTPS / TLS is handled by the SEB Server itself (end to end). 
    
    .. note:: It is highly recommended to use the first approach here that is easier to install then the end to end approach. 
    There are some prepared installations for the second approach within the seb-server-setup repository (selfsigned) but they are experimental yet
