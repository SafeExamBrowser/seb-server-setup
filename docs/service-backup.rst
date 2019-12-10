Currently there is only a manual docker-based backup in place:

.. code-block:: bash
    # Create a backup
    $ docker run --rm -v noencrypt_seb-server-mariadb:/volume -v $PWD:/backup loomchild/volume-backup backup seb-server-backup-[DATE]
    
    # Restore from a previously created backup
    $ docker run --rm -v noencrypt_seb-server-mariadb:/volume -v $PWD:/backup loomchild/volume-backup restore seb-server-backup-[DATE]
    $ docker restart seb-server-mariadb