Overview
========

Overall Architecture
--------------------

SEB Server is a enterprise server application written in Java and uses `Spring <https://spring.io//>`_ and Spring Boot as a main-framework. 

The image below shows the overall architecture of the SEB Server which is basically split into two main parts, a webservice and a Graphical User Interface (GUI) service. This two services can be deployed together in one server instance or they can be deployed separately with the ability to scale the webservice for example up to the specified needs.

.. image:: images/overall-architecture.png
    :target: https://raw.githubusercontent.com/SafeExamBrowser/seb-server-setup/master/docs/images/overall-architecture.png
    
The webservice uses a well defined REST API interface over HTTP and mainly JSON as a data structure for communication. The webservice also implements OAuth2 as a standard authentication method.

Installation Repository
-----------------------

TODO