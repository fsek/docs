Translation files
=================

We are using the platform OneSky_ to handle our Swedish and English translations. This section describes how to use the gem `onesky-rails`_ we are using to talk to the OneSky API as well as the workflow you should follow when adding a new phrase.

.. _OneSky: https://www.oneskyapp.com/
.. _onesky-rails: https://github.com/onesky/onesky-rails

=======================================
Adding OneSky API secret to environment
=======================================

The gem 'onesky-rails' provide a ``upload`` and ``download`` rake command to sync files. To be able to use these you must add the public and secret key from our OneSky account locally to your computer, more specifically to the environment file ``.env`` inside the ``web`` folder. These can be found by logging onto the `OneSky website`_. Ask your foreman for login details. Once you have logged in press "Site settings" on the upper right and then "API Keys & Usage" to find the keys.

.. _OneSky website: https://www.oneskyapp.com/sign-in

Before adding the keys to your computer you must first change your current directory to the ``web`` folder. When you are there run

::

  echo ONESKY_API_KEY=PUBLIC_KEY >> .env
  echo ONESKY_API_SECRET=SECRET_KEY >> .env
  echo ONESKY_PROJECT_ID=67804 >> .env

with the keys from the OneSky website to add the keys to the ``.env`` file.

========
Workflow
========

This section describes the standard workflow of adding a new phrase.

Add phrase to Swedish translation file
--------------------------------------

The translation files can be found in ``web/config/locales``. Model specific phrases and phrases used in the views can be found inside the folder ``models`` and ``views`` respectively.

Example
~~~~~~~

Here follows a part of the translation file ``meetings.sv.yml`` used in the meeting view:

::

  sv:
    meetings:
      index:
        new: Ny bokning
        to_alumni: Till alumnirummet
        to_sk: Till styrelserummet
        administrate: Administrera
      edit:
        title: Redigera bokning
        destroy: Förinta bokning
        index: Alla lokalbokningar
        confirm_destroy: Är du säker på att du vill förinta bokningen?

Each phrase has a so called Phrase ID. The ID of the last row above is ``meetings.edit.confirm_destroy``. It is important that this ID is named properly for the meeting view to be able to find the phrase. The last attribute, e.g. ``confirm_destroy``, should say something about what the phrase is about or where it is used.

Say you want to add a phrase to the edit page of meetings. To do this you simply add a line with a suitable attribute as

::

  sv:
    meetings:
      index:
        new: Ny bokning
        to_alumni: Till alumnirummet
        to_sk: Till styrelserummet
        administrate: Administrera
      edit:
        title: Redigera bokning
        destroy: Förinta bokning
        index: Alla lokalbokningar
        confirm_destroy: Är du säker på att du vill förinta bokningen?
        new_phrase: Ny fras


Upload translation files to OneSky
----------------------------------

When you have added the phrase to an already existing or a new translation file, we want to upload them to OneSky. This can be done by running

::

  rake onesky:upload

inside your ``web`` folder. Note that this command will upload all Swedish translation files, including those that have not been edited.


Add English translation to phrase
---------------------------------

Now we need to add an English translation to the added phrase. This is done by logging onto the OneSky website and going to "Projects->Fsektionen/Regular Web App" and then selecting "English". From this page you can filter to only show the relevant translation file, e.g. ``meetings.sv.yml``. OneSky should then show you which phrases that are not yet translated.


Export English translation
--------------------------

Now press the F-guild logo to the upper left to goto to the home page and then press "Download translations". Choose ``.yml (Rails YAML)`` as the file format and filter to only export the English translation of the relevant file.

Once the export is done, simply open the downloaded translation file with your favourite text editor and copy the content of the file and paste it into the corresponding English translation file in ``web/config/locales/onesky_en``.
