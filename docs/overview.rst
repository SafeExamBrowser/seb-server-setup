Overview
========

Overall Architecture
--------------------

SEB Server is a enterprice server application written in Java and uses Spring and Spring Boot as a main-framwork. 

The image below shows the overall architecture of the SEB Server which is basically split into two main parts, a webservice and a Graphical User Interface (GUI) service. This two services can be deployed togehter in one server instance or they can be deployd separately with the ability to scale the webservice for example up to the specified needs.

.. image:: images/overall-architecture.png
    :target : https://github.com/SafeExamBrowser/seb-server-setup/blob/master/docs/images/overall-architecture.png
    
The webservice uses a well defined REST API interface over HTTP nad using mainly JSON as data structure for communication.

Installation Repository
-----------------------

TODO