How to prepare the Rostsystem
=============================

First and foremost you must install `Heroku CLI`_. Once installed run ``heroku login`` and login using the Spider foreman account.

1. Run cleanup task using the Heroku CLI with ``heroku run rake cleanup:keep_users --app fsekvoting``

2. `Change dyno type`_ from "Free" to "Hobby". This should be done a day or a couple of hours before the assembly, and then switched back to "Free" when it is over since the "Hobby" dyno costs money

3. If needed, give rights to the guild's secretary on the website so they can set the correct roles to people attending the assembly

4. (Optional) The database can store 10000 rows, but if this is not enough then you have to upgrade the Postgres add-on from "Hobby Dev" to "Hobby Basic". 10000 rows is however often more than enough for a guild assembly. The number of rows used can be seen by typing ``heroku pg:info --app fsekvoting``

.. _Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli

.. _Change dyno type: https://dashboard.heroku.com/apps/fsekvoting/resources
