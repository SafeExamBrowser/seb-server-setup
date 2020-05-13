To update an already installed and bundled SEB Server service, following the steps below;

1. Shouting down the SEB Server setup docker services with;

 .. code-block:: bash
 
     $ docker-compose down
     
2. Update to the newest or preferred version within the seb-server-setup. Use git tags to show the available tags. If there are already local changed - if the configuration was modified from the original settings, and the local changes shall still be used and remain, git stash can be used to locally store and merge them.

 .. code-block:: bash
 
         # Get new tags from remote
         $ git fetch --tags
    
         # Get latest tag name
         $ latestTag=$(git describe --tags `git rev-list --tags --max-count=1`)
         
         # If local changes shall remain
         $ git stash
    
         # Checkout latest tag
         $ git checkout $latestTag
         
         # If local changes shall remain
         $ git stash apply
         
         
.. note::
      Usually you want to point to the exact version of the SEB Server setup by using `semantic versioning <https://semver.org/>`_ like 1.0.0 or 1.0.1. 
      You are also able to set the latest minor version to always get the latest specific minor version with all patches. 
      If you want the latest minor version use version tags like 1.0-latest or 1.1-latest.
         
3. Do some additional configuration if needed.
     
         
4. Rebuild the image with the new SEB Server version

 .. code-block:: bash
    $ docker-compose build --no-cache
        
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