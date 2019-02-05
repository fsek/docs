.. _app-standard-workflow:

Standard workflow
=================

If you've followed the :ref:`app-installation-guide` you should have everything set up to start working. Below we're going to take a look at the standard workflow on this project. This will help you get started coding and implementing your feature.

==========================
Opening the project folder
==========================

This step might seem a little trivial, but it's important to make sure that we have all the correct files opened going forward. Go ahead and open the ``app`` directory in your IDE/text editor of choice. The folder that's important is the ``www`` folder, which contains all of our HTML, SCSS/CSS and Javascript files. This is where you'll be doing all of your work and adding your feature. The folder structure in ``www`` is sorted according to the different file types and is quite self explanatory.

=====================
Creating a new branch
=====================

With the project opened you are ready to start coding. Before we make any changes though, we want to create and checkout a new branch with git. ::

  git checkout -b <branch name>

If this is new to you I would recommend to checkout :ref:`learning-git` before we continue and familiarize yourself with the git workflow and its core concepts.

===========================================
Starting the web server and running the app
===========================================

Now we are good to start coding and contributing to the project. Remember that all the changes you make are local and doesn't affect anyone but you. Now, it would also be quite nice to be able to see the effect of the changes you make. We do this by hosting a local web server with PhoneGap that runs the app for you in real time. To start the server we use npm and simply execute::

  npm start

The first time you start the web server it will ask you if you want to send information to PhoneGap, which we don't. It will also ask for access through your firewall which you should allow. After a few seconds, you should be able to access the server and see the app at http://localhost:3000. Make sure you open the developer tools in your browser (F12), change to a responsive design mode (Ctrl+Shift+M) and select a device.

==============
Making changes
==============

This is where we part for a while and where you'll shine bright like the star you are. Go ahead and start coding that sik feature with those golden fingers. I recommend reading through :ref:`app-our-systems` before you start. This will give you a better understanding of the project and help you get the ball rolling. Below are....  Assume that you have a basic understanding of Framework7.

Creating a new page
-------------------

The first thing we need to is add a new HTML file that will contain our new page. We can do this through a text editor/IDE or with the command line. Do what ever works for you, but it's important to have the ``.html`` file ending and make sure to save it directly in the ``www`` folder, with all the other HTML files. Lets assume you have created a page called ``cool_stuff.html``. Now, we obviously want to add some cool stuff, but lets start with the standard page layout::

  # app/www/cool_stuff.html
  <div data-name="cool-stuff" class="page no-toolbar">
    <div class="navbar">
      <div class="navbar-inner sliding">
        <div class="left">
          <a href="#" class="back link">
            <i class="icon icon-back"></i>
            <span class="ios-only">Tillbaka</span>
          </a>
        </div>
      </div>
    </div>
    <div class="page-content">
      Some cool content...
    </div>
  </div>

This is more or less the structure all of our pages follow, with the important difference of ``data-name``. The ``data-name`` is very important because it gives your page a unique tag that we use to catch different page specific events. , like `onPageInit` or ` (F7-link).

Okay, so we have created a pretty cool page, or atleast a foundation for one, but we have no way of navigating to it yet. This is fairly simple to fix and consists of two parts: *defining a new route* and *linking to a route*. To define a new route we have to open ``index.js`` and scroll down to the different view objects. Views can be seen as HTML objects that contain a selection of pages and a page navigation history. The app contains six views, one for each tab and one for the login page. You can read more about views **Our systems link and F7 link???**. Let's say we want to add our cool page to the alternatives tab. This means that we need to add a new route to ``cool_stuff.html`` in the ``alternativesView`` object. ::

  # app/www/js/index.js
  var alternativesView = app.views.create('#view-alternatives', {
    routesAdd: [
      {
        name: 'cool_stuff',
        path: '/cool_stuff/',
        url: './cool_stuff.html',
      },
      {
        ... # Other routes
      },
    ]
  });

Now the F7 router knows which page to load when we navigate to the ``/cool_stuff/`` route in the alternatives view. We can now begin on the second part, linking to a route. That is, we can setup a HTML link to our page and the F7 router will lookup the correct file to render through the route we just defined. All we need to do is define the route in the ``href`` attribute of the ``<a>``-tag::

  <a href="/cool_stuff/">Link to a cool page</a>

(Read more about routes blabla, simplest form - from root, second link needs to defined in the routes of the route.) Let's add a link to the alternatives tab in ``index.html`` under "Sångbok". Here we add a bit more to the link to make it a list item, rather than just text.  ::

  # app/www/index.html
  <div id="view-alternatives" class="view tab">
    <div data-name="alternatives" class="page">
      <div class="navbar android-hide">
        <div class="navbar-inner sliding">
          <div class="title">Alternativ</div>
        </div>
      </div>
      <div class="page-content settings-content">
        <div class="list">
          <ul>
            <li>
              <a href="/songbook/" class="item-link">
                <div class="item-content">
                  <div class="item-inner">
                    <div class="item-title">Sångbok</div>
                  </div>
                </div>
              </a>
            </li>

            # Link to cool_stuff.html
            <li>
              <a href="/cool_stuff/" class="item-link">
                <div class="item-content">
                  <div class="item-inner">
                    <div class="item-title">A cool page</div>
                  </div>
                </div>
              </a>
            </li>

            ... # More list items and stuff

          </ul>
        </div>
      </div>
    </div>
  </div>

That's it. It should now be possible able to navigate to ``cool_stuff.html`` from the alternatives tab. Now we want to fill the page with some cool stuff, which often is done with content retrived through our API.

Making an API request
---------------------

Intro om intressant innehåller => API + databas

Let's continue with ``cool_stuff.html`` from the example above and try to add some cool stuff with the API. Before we get deeper into the actual request, we first need to figure out when we want to make this request and where it should be defined and executed in our code. The first question has a pretty  If we assume that there exists an endpoint in our API called ``cool_stuff`` which has a GET-request set up. Now,

Creating a template
-------------------

=================================================
Testing on multiple devices and operating systems
=================================================

When you have gotten to the styling part of your feature make sure you test on both Android and iOS devices, since they have different styling. Also, remember to switch the OS specific styling overrides in ``index.html`` when you switch OS. That is, make sure you have the ``material-overrides.css`` when working with Android devices and ``ios-overrides.css`` on iOS devices. If you don't, you'll notice that things look very bad. It's also important to test on different screen sizes. What looks good on one device doesn't necessarily look good on others.

=====================================
Adding changes to next version/update
=====================================

When you're finished with your changes and they look good on all devices it's time to add them to the next version. We do this using git which is described step by step in :ref:`git-workflow`. Head over there and follow the steps. When your done the whole section will enjoy your feature in the next release.

