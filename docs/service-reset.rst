.. note::
    The reset depends on your setup. Please be aware that if you have adapted a specified setup for your needs
    you need to also adapt the following reset procedure.

To reset a SEB Server installation either to delete the installation or the be able to install from scratch, you have to shout down the service
and prune the docker system entirely. To do so, use the following steps.

.. warn:: 
    Make sure you have a actual backup from the database before reset the whole service. Otherwise all data will be lost.
    
.. note:: 
    If you want to reuse data from backup you have to make sure you use the same initial password on the setup as before.
    Otherwise the service will not be able to decrypt previously encrypted data from the database. 

1. If the service is still running, go into the service setup directory and shout it down

 .. code-block:: bash
    
    $ docker-compose down
        
2. Prune the related volumes (type yes of docker is asking you to proceed)

 .. code-block:: bash
    
    $ docker volume prune
        
3. Make sure you have no other currently inactive services that you need and then prune the docker system.
   This will remove all dangling containers and images as well as networks.
   
 .. code-block:: bash
   
    $ docker system prune
        
4. After this cleanup you are able to start with a new installation from scratch.
    
        
 