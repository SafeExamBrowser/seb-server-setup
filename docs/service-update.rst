.. note::
    The update depends on your setup and SEB Serverversion change.
    If you change from one major version to another, please consult the migration guide for the major version upgrade specifically.
    Please be aware that if you have adapted a specified setup for your needs you need to also adapt the following update procedure.


To update an already installed and bundled SEB Server service, follow the steps below:

1. Shout down the SEB Server setup docker services with

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
    
.. note::
    Since SEB Server version 1.2.x there is a new setup procedure (dockerhub). If you use this setup, you have to provide the passwords that
    was given on startup again. Do not use another password for the SEBSERVER_PWD and only adapt the DB_SA_PWD if your database has a new password for the user.
    You can just copy or recreate the .env in the working directory that contains the needed password or you can give them with the docker-compose up command later on.
    
    
4. Rebuild the image with the new SEB Server version

 .. code-block:: bash
 
    $ docker-compose build --no-cache
    
Or with a pull if you use a setup with an image from docker-hub:

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


Major Version Migration from SEB Server Version 1.x to Version 2.x
--------------------------------------------------------------------

Since this major version update not only includes a usual DB migration but also new services that need to be setup, a migration
from SEB Server 1.x to version 2.x needs special treating and it is not going to work by just adapting the version tags for the images.

There are basically two different ways to go on with this migration.
If you are able to make a database backup and restore, setting up an entire new SEB Server would be the easiest way. But if
you want to reuse our internal/integrated database without migrating the data form old database to a new one, you need to take
care to merge your old setup configuration with the new one.x

**We recommend the first approaches:**

1. Make sure you have all essential settings like passwords for SEB Server and Database connection from your existing SEB Server setup at hand
2. Make a backup of your existing SEB Server database or schema, with an SQL dump or similar technique you are familiar with. This is needed for safety reasons to be able to restore old data if needed
3. Stop all docker services with and delete the existing configuration volumes in docker

.. note::
    Do not delete the data base volume "seb-server-mariadb" since this are your current data and it will be migrated once the new service starting up.
    If you use an external database, you are just fine and you can connect the it within the new setup just like usual. The migration will then be applied on fist service startup

.. code-block:: bash
    $ docker-compose down
    $ docker volume ls
    $ docker volume rm seb-server-config

4. Install SEB Server with a total new installation as described within the install section: :ref:`prodsetup-label`

.. code-block:: bash
    $ git checkout $ git checkout tags/v2.0-latest

5. Once the new SEB Server setup is up and running, check if migration of the database was successfully. :ref:`logguide-label` for more information.
6. You should now be able to access the new SEB Server with old data and old logins.


**For the second approaches please use the following guide:**

1. Make sure you have all essential settings like passwords for SEB Server and Database connection from your existing SEB Server setup at hand and backed up
2. Make a backup of your existing SEB Server database or schema, with an SQL dump or similar technique you are familiar with. This is just in case you want to go back and restore the old installation
3. Stop all services with docker-compose down on the old installation.
4. Checkout the latest 2.0 version of the SEB Server setup repo "seb-server-setup" with:

.. code-block:: bash
    $ git checkout $ git checkout tags/v2.0-latest

 or

.. code-block:: bash
    $ git clone -b v2.0-latest https://github.com/SafeExamBrowser/seb-server-setup.git

5. Apply all needed settings from your restored data and also apply new needed settings accordingly. Please consult also the new installation guide for this: :ref:`prodsetup-label`
6. Start the new Setup with and consult the logs (docker logs seb-server), check that all is okay and DB migration was successfully applied. Also consult the :ref:`logguide-label` for more information.

.. code-block:: bash
    $ docker-compose pull
    $ docker-compose up -d

7. You should now be able to access the new SEB Server with old data and old logins.