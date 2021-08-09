Troubleshooting
===============

This page's purpose is to collect frequently ask questions, problems and workarounds that are reported and known. 
There shall be at least a problem description, an optional explanation if needed, a solution description and the SEB Server version and domain information. For Example:

--------------------------------

- **Version**     : 1.0.0
- **Domain**      : production / bundled / basic
- **Problem**     : This is an example problem description.
- **Explanation** : An explanation is not mandatory but shall be provided if you want to give some background information to the problem.
- **Solution**    : A description of the solution, workaround or upcoming fixes.

------------------------------

- **Version** : 1.0.0
- **Domain**  : general bundled setups or stand-alone webservice
- **Problem** : You cannot find the admin-account that is expected to be generated on the first initial startup of the SEB Server web-service within the logs.

.. note::
    There may be different reasons to cause this problem. Make sure that:
        - You are looking to the correct logs. The initial admin account is only be generated on the very first startup when there is a uninitialized database. Make sure you look at the very first startup of the web-service on the logs.
        - The configuration attribute "sebserver.init.adminaccount.gen-on-init" is set to true and the attributes "sebserver.init.organisation.name" and "sebserver.init.adminaccount.username" are properly set within the spring-configuration.
        - The database connection is okay and we have a fresh uninitialized database on first startup of the service.
        
If all the above suggestions are not solving the problem, you can check the database if there is already an initial user account created for it. If this is the case, a solution would be to shout-down the service, to delete the user-account in the database and to restart the service again. You can use a SQL client tool to connect to the database with the data you have from the setup. Usually the SQL port is 3306 if not changed and the user is root with the password you have given within the secret file on setup.

- Stop the service with:

    .. code-block:: bash
 
        $ docker stop seb-server

- Connect to the database with a SQL client and delete the existing initial user-account from the user table.

- And restart it again with:

    .. code-block:: bash
 
        $ docker restart seb-server
        
Now the initial user-account should be created again and the credentials should be get from the logs as usual.

If you dont have a SQL client tool or are not able to connect to the database, you by can delete the database for SEB Server within a brute-force method by delete the docker-volume that contains this data. This only works if you have an integrated database setup with docker (no external database) and if you don't have active data in the database already. With this approach all data will be lost.

- Stop the service with:

    .. code-block:: bash
 
        $ docker stop seb-server
        
- Delete the database docker-volume with

    .. code-block:: bash
 
        $ docker volume rm seb-server-mariadb

- And restart it again with:

    .. code-block:: bash
 
        $ docker restart seb-server
        
Now the initial user-account should be created again and the credentials should be get from the logs as usual.


------------------------------

- **Version** : 1.0.0
- **Domain**  : general bundled setups
- **Problem** : SEB Server is not able to connect internally to MariaDB SEB Server is not able to connect internally to MariaDB within the docker network. You see a connection error on the seb-server log files in SEB Server startup. 

.. note::
   Use "docker logs seb-server" to quickly show the SEB Server application logs.
   
- **Explanation** : It seems that this error happens sometimes when the services are starting slowly, and either the MariaDB service or the network is not up and running while the seb-sever service tries to connect. It also fails on following automated service restarts for some unknown reason. We are working on a better solution for this.
- **Solution** : to stop and restart the seb-server service manually. This usually works if the described explanation is the reason of the connection error.

    - Stop the service with:

        .. code-block:: bash
 
            $ docker stop seb-server
   
    - And restart it again with:

        .. code-block:: bash
 
            $ docker restart seb-server
   
    - See the logs if this solved the problem:

        .. code-block:: bash
 
            $ docker logs seb-server
   
-------------------------------------
   
- **Version** : 1.0.0
- **Domain**  : general bundled setups
- **Problem** : The initial password file setup was not correctly done for the first time or you need or want to reset the password.
- **Solution** : You have to remove the configuration volume from the docker engine and create the password file again. Then restarting the service.

.. note::
   Do this with care! If there is already data stored that was encrypted for security reasons with a password that was originally set on the
   initial setup, this must not be changed. Otherwise the SEB Server service will not be able to decrypt the old secured data anymore. 
   In the initial setup you are able to change the password but from the time one you have living data on the service you never should change
   this initial password. 

 - Stop the whole service with:

  .. code-block:: bash
 
    $ docker-compose down
   
 - Go into the config directory and create the "secret" file with the password as described in the setup process:

  .. code-block:: bash
 
    $ cd config
    $ vi secret
    $ cd ..
   
 - Start the whole service again with:

  .. code-block:: bash
 
    $ docker-compose up -d
   
------------------------------------------------

