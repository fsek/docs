File naming and placing
=======================

Hopefully, you have learned a bit about Rails and how things work together. If not head over here to learn a bit. This guide will make more sense if you know a bit about Rails.

==========
Help Rails
==========

Rails take care of a lot of things for you. But to help Rails you need to work in a specific way. Rails look for certain things while compiling all the files you've written. To help Rails you need to place your files in specific folders and name them in specific ways. If everything is done correctly Rails will also compile your files correctly.

==============
File Placement
==============

All files are placed in subfolders located in app. Generally, images and other assets are placed in the assets folder.

Rails
-----

* Models

  * Models are placed in the models folder.

* Controllers

  * All controllers are placed in the controllers folder. If you want to restrict usage to users with higher privileges you place the files in controllers/admin.

* Views

  * A view is a folder of files which is placed in the views folder. Same as with the controllers, if you want to restrict access to regular users then place them in the admin subfolder.

CSS
---

All style files should be placed in the assets/stylesheets/partials folder.

Javascript
----------

Javascript files are placed in the assets/javascripts folder.

======
Naming
======

To make this section more understandable a bike management system will be pseudo-implemented.

Rails
-----

* Models

  * Name your model something descriptive. You will use the model name later when naming the controller and view. Let's create a model named bike.rb.

* Controllers

  * Name your controllers with [model-name]_controller but the model name in the plural form (it's not really plural in all cases as you just add an s to the model name). In our case, the controller will be called bikes_controller.rb.

* Views

  * Use the model name in the plural form when naming your view. In our case, our view folder will be called bikes.

CSS
---

The most important rule when naming CSS-files is to use an underscore (_) before the name. Other than that you will want to name the file something descriptive. Rails don't really care what you name your file but other developers will. In our case, the file would, for example, be called _bikes.scss

Javascript
----------

Give the JS-files descriptive names. Rails don't care about the name but others will. In our case, the name would be bikes.js.
