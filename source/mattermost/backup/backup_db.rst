.. _mm_db_backup:
Mattermost DB Backup
==========


There is a service and corresponding timer,
``mattermost_backup.service`` and ``mattermost_backup.timer``
that regularly (once a week on saturdays as of 2025-05-09) uses ``pg_dump``
inside the postgres service of the mattermost docker compose to dump the
database to a gzipped file in ``/fsek/mattermost_postgres_backup``.

This
service assumes that:

1. The directory ``/fsek/mattermost_postgres_backup`` exists
2. The mattermost ``docker-compose.yml`` is in the directory ``/fsek/mattermost_postgres_backup``
3. The database is called ``mattermost`` and the user is named ``mmuser``

Note that if any of these change you **must** update
``mattermost_backup.service`` or else it will stop working!
