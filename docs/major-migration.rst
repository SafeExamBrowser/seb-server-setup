.. _majorversionupdate-label:

Major Version Migration
-----------------------

Since this major version update not only includes a usual DB migration but also new services that need to be setup, a migration
from SEB Server 1.x to version 2.x needs special treating and it is not going to work by just adapting the version tags for the images.

There are basically two different ways to go on with this migration.
If you are able to make a database backup and restore, setting up an entire new SEB Server would be the easiest way. But if
you want to reuse our internal/integrated database without migrating the data form old database to a new one, you need to take
care to merge your old setup configuration with the new one.

**We recommend the first approach:**

1. Make sure you have all essential settings like passwords for SEB Server and Database connection from your existing SEB Server setup at hand

2. Make a backup of your existing SEB Server database or schema, with an SQL dump or similar technique you are familiar with. This is needed for safety reasons to be able to restore old data if needed

3. Stop all docker services with and delete the existing configuration volumes in docker

.. code-block:: bash
    
    $ docker-compose down
    $ docker volume ls
    $ docker volume rm seb-server-config

.. note::
    Do not delete the data base volume "seb-server-mariadb" since this are your current data and it will be migrated once the new service starting up.
    If you use an external database, you are just fine and you can connect the it within the new setup just like usual. The migration will then be applied on fist service startup


4. Install SEB Server with a total new installation as described within the install section: :ref:`prodsetup-label`

.. code-block:: bash
    
    $ git checkout $ git checkout tags/v2.0-latest

5. Once the new SEB Server setup is up and running, check if migration of the database was successfully. :ref:`logguide-label` for more information.

6. You should now be able to access the new SEB Server with old data and old logins.


---------------------------------------------------------------------------------------------------------------------

**For the second approach please use the following guide:**

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
