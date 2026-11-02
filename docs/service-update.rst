Service Update
--------------

.. note::
    If you need to make a major version update, from version 2.x to version 3.x for example, please consult the :ref:`majorversionupdate-label`


The update depends on your setup and SEB Serverversion change.
If you change from one major version to another, please consult the migration guide for the major version upgrade specifically.
Please be aware that if you have adapted a specified setup for your needs you need to also adapt the following update procedure.

To update an already installed and bundled SEB Server service, follow the steps below:

1. Shout down the SEB Server setup docker services with

 .. code-block:: bash
    
    $ docker-compose down
     
2. Update the SEBSERVER_VERSION tag to the version you want to update to. If you have changed the docker-compose.yml file directly, make sure you have the correct image version there.

         
.. note::
      Usually you want to point to the exact version of the SEB Server setup by using `semantic versioning <https://semver.org/>`_ like 1.0.0 or 1.0.1. 
      You are also able to set the latest minor version to always get the latest specific minor version with all patches. 
      If you want the latest minor version use version tags like 1.0-latest or 1.1-latest.
         
3. Do some additional configuration if needed.
    
.. note::
    Usually there is no additional configuration needed on minor version updates (only on major version updates).
    If there is, it should be stated in the Release notes of the minor or patch versions
    
    
4. Pull the new images form Docker hub

 .. code-block:: bash
    
    $ docker-compose pull
        
5. Boot the SEB Server setup docker services with

 .. code-block:: bash
    
    $ docker-compose up -d


6. Check if the containers are started and running and everything is set in place for the particular setup

 .. code-block:: bash
    
    $ docker ps --all
    $ docker logs ${container name}
        
7. Cleanup the docker engine with

 .. code-block:: bash
    
    $ docker system prune

