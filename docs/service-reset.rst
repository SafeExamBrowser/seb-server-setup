To reset a SEB Server installation either to delete the installation or the be able to install form scratch, we have do shout down the service
and prune the docker system entirely. To do so, use the following steps.

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
    
        
 