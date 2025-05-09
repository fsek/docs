Mattermost Backup
======================

To properly backup Mattermost, both the database and all the files/content need to be backed up.
Backing up the files is pretty easy, copying is good enough.

To back up the database we need to first dump it to a file. On the server there
is a systemd service ``mattermost_backup.service`` which handles this.
See: :ref:`mm_db_backup`.

.. toctree::
    :maxdepth: 2
    :caption: Contents:

    backup_db
