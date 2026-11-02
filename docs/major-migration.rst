.. _majorversionupdate-label:

Major Version Migration
-----------------------

The next Major version migration applies the update from SEB Server version 2.x to SEB Server version 3.0.

This is a major version update that also affects the SEB Server Docker setup and changes container setups.
With this version comes a completely new User Interface build with Vue and TypeScript. The new User Interface
integrates the former SEB Server User Interface with the Screen Proctoring User Interface so that there is
only one User Interface within a singe container now. The two former services, namely seb-server and sps-webservice
are  mostly the same except the seb-server is renames to seb-webservice and does not provide the old User Interface anymore.

Since this changes the container setup slightly we recommend the following update procedure for a seamless update:

 - Bundled Setups

 For bundled setups the easiest way to update is to make a new setup beside the existing one and using the same DB connection
 to connect to the existing database. You strictly require to use the SEBSERVER_PWD you used for your current setup also for the new setup.

 If you use the internal MariaDB that comes with the docker compose, you have to make sure the existing db volume that was
 named "seb-server-mariadb" by default, is not deleted and is reused by the new setup. We also recomment to make a DB
 backup before update and migration applies to the data.

 Step by step migration from SEB Server 2.x to SEB Server 3.0


1. Make sure you have all essential settings like passwords for SEB Server and Database connection from your existing SEB Server setup at hand

2. Make a backup of your existing SEB Server database or schema, with an SQL dump or similar technique you are familiar with. This is needed for safety reasons to be able to restore old data if needed

3. Stop all docker services and delete the existing configuration volumes in docker:

.. code-block:: bash

    $ docker-compose down
    $ docker volume ls
    $ docker volume rm seb-server-config

.. note::
    Do not delete the data base volume "seb-server-mariadb" since this are your current data and it will be migrated once the new service starting up.
    If you use an external database, you are just fine and you can connect the it within the new setup just like usual. The migration will then be applied on fist service startup

4. Install SEB Server with a total new installation as described within the install section: :ref:`prodsetup-label`

.. code-block:: bash

    $ git checkout $ git checkout tags/v3.0-latest

or

.. code-block:: bash

    $ git clone -b v3.0-latest https://github.com/SafeExamBrowser/seb-server-setup.git

5. Apply all needed settings from your former setup accordingly. Apply all settings you have changed or set in the .env or docker-compose.yml file, to configure your Setup as was configured. Beside of that all new settings come with default values that should work out-of-the-box. Please consult also the new installation guide for this: :ref:`prodsetup-label`

6. Start the new Setup with and consult the logs (docker logs seb-server), check that all is okay and DB migration was successfully applied. Also consult the :ref:`logguide-label` for more information.

.. code-block:: bash

    $ docker-compose pull
    $ docker-compose up -d

7. You should now be able to access the new SEB Server with old data and old logins.


 - Cloud Setup

 There are new templates for cloud setup that gives an example of what the new setup contains. You can compare this
 to the setup you already have and adapt to the changes.

 Since a cloud setup heavily depends on the cloud environment, please contact us via Alliance e-mail directly or on
 github for further if needed.

