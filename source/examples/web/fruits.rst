Fruits
======

This is a highly explanatory and beginner-friendly example of web implementation. 
Even though it’s a little silly, it explains the workflow and basic process of implementation quite well.

============
General idea
============

We begin by creating an overview of the idea. For this example, the vision is to implement the 
possibility of allocating fruit to the users on the website. 
Before we begin writing any code we must think about the general properties of a fruit, given the context.

.. image:: Fruits/fruits.png
  :width: 600px

So, generally we want to create a fruit object described by the two parameters name, a string, and isMoldy, 
a boolean. The fruit is connected to a user of whom it’s owned by. A user can own many fruits, but a fruit 
cannot be shared between users. These kinds of relations are important to keep track of. 

===================
Create a git branch
===================

Before actually writing any code, you must create a git branch so as to not accidentally mess with any 
other code (and especially not with the master branch). It is praxis to name it using kebab case in a manner 
of **[your name]-[general description]**. We create a new git branch through the command

::

  git checkout -b “johanna-fruits-example”

you can then make sure you are on the right branch through the command

::

  git status

or

::

  git branch

====================
Migrate the database
====================

For each Rails model, there is a database table. We go to **web/db/** and create a new file called 
**20201129220000_create_fruits.rb** as we are about to create a database for the fruits on 29 November 2020 at 10 pm. 
This naming convention exists to structure the files according to their creation. 

Here we will specify what parameters there are.

  .. literalinclude:: Fruits/20201129220000_create_fruits.rb
    :language: ruby

We are saying that each fruit inhabits a name and degree of moldiness, neither of which can be empty (``null``), 
and is connected to a certain user. We have set the default value of ``isMoldy`` to false, as we would expect 
a new fruit to be fresh.

When this is finished we go to the terminal and run

::

  rails db:migrate


==============
Create a model
==============

This time the file and class name are singular, as opposed to the database elements that are plural. 
We go to **web/app/models/** and create a new file called **fruit.rb**.

  .. literalinclude:: Fruits/fruit.rb
    :language: ruby

Here we once again see the different parameters. In the model we make sure that the right 
values go into the fruits’ database table. 

First we specify the relation between a user and a fruit; since we wish the user to own fruits, 
and a fruit to be owned by a single user, we use the line ``belongs_to`` which describes it quite well. 
``belongs_to`` is an Association that makes the creation and deletion of objects smoother. 

The ``validates :name, presence true`` line ensures that a fruit only can be created if it is given a name. 
Same goes for ``isMoldy``. But how come we don’t write ``validates :isMoldy, presence: true``? Doing so will 
lead to some bugs when creating a fruit. Read the documentation for ``validates``:

*If you want to validate the presence of a boolean field (where the real values are true and false), 
you will want to use validates_inclusion_of :field_name, in: [true, false].*

*This is due to the way Object#blank? handles boolean values: false.blank? # => true.*

Lastly there is the ``to_s`` function, which is quite self explanatory.

=================================================
Test the model directly through the Rails console
=================================================

At this point the fruit is practically done, console-wise. It is very practical to continuously try 
out an object directly through the Rails console while it is being implemented. Run

::

  rails c

to enter the Rails console. We copy the situation in the top illustration by running

::

  Fruit.create!(user_id: 1, name: “Banana”, isMoldy: false)

and

::

  Fruit.create!(user_id: 1, name: “Apple”, isMoldy: true)

The user with user_id: 1 (Hilbert Admin-älg) now owns two fruits. You can run 

::

  Fruit.all

to ensure that it is a list containing two fruits with the correct parameters. To delete these fruits we run 

::

  Fruit.delete_all


==========================
Add an association to user
==========================

We have already declared the Association ``belongs_to`` for the fruit, but we also need to declare a related 
Association for the user. We go to **web/app/models/user.rb** and write the following line

  .. code-block:: ruby

    has_many :fruits, dependant: :destroy

which, of course, says that a user can own many fruits. The ``dependant: :destroy`` bit is what ensures 
that all associated fruits will vanish as the user is deleted. If we go back to the Rails console, 
we can try out some new things. This time we will create the same fruits, but instead of having the 
user_id as a parameter, we will create the fruits directly through the user

::

  User.first.fruits.create!(name: “Banana”, isMoldy: false)
  User.first.fruits.create!(name: “Apple”, isMoldy: true)

Then calling 

::

  User.first.fruits

will return a list of these two fruits. We write ``User.first`` since we want to reach the first element 
in the list of users. Writing ``User.find(1)`` returns the user with ``id`` 1, and is equivalent to ``User.first``.

=================
Define the routes
=================

In order for the fruits to show up on the website, the different routes have to be initialized in 
the file **web/app/config/routes.rb**. Before adding any code we have to be sure about who is supposed to 
have access to what. For this example we would like each user to be able to view their own fruits, 
and only admins to be able to create and delete fruits. We will therefore write

  .. code-block:: ruby

    resources :fruits, path: :frukter, only: [:index, :show]

    namespace :admin do
      resources :fruits, path: :frukter, except: :show
    end

We can view all the available fruit-paths by running 

::

  rails routes | grep fruit

If we were to run rails routes only we would get an endless stream of every single route. 

======================
Create the controllers
======================

The admin controller
--------------------

As we have specified that there are going to be different routes for admins and regular users, there has 
to be different controllers for each. We begin by writing the admin controller. We go to **web/app/controllers/admin/** 
and create a file **fruits_controller.rb**. The convention here is to name the file in plural. The “shell” of the file 
looks like this:

  .. code-block:: ruby

    class Admin::FruitsController < Admin::BaseController
      load_permissions_and_authorize_resource

      [methods]

    end

The class is also named in plural, and doing so has the benefit of automating some default routes. As you might have 
figured out, the **FruitsController** inherits from the **Admin BaseController**. You can view its contents at 
**web/app/controllers/admin/base_controller.rb**, if you’re curious.

In the controller we write methods that will be used to execute actions concerning the fruit. What actions do we want 
admins to be able to perform?

* Retrieve all existing fruits
* Create a new fruit
* Edit a fruit
* Delete a fruit

The control methods are quite standard, so let’s take a look at the finished file and then analyze its contents.

  .. literalinclude:: Fruits/admin_fruits_controller.rb
    :language: ruby

Let’s go back to the bullet list from before and match it with the corresponding methods:

* Retrieve all existing fruits - *index*
* Create a new fruit - *new and create (and fruit_params)*
* Edit a fruit - *edit and update*
* Delete a fruit - *delete*

Standard control methods
************************

But wait, how can there be new and edit methods if we haven’t implemented them ourselves? The way Rails works enables 
us to leave methods empty if we don’t want it to do something special. Rails, by standard, renders the 
corresponding view (we’ll get to that later) when one navigates to a url; so clicking on an "edit" button will in this case 
render **web/app/views/edit.html.erb** and nothing else.

The @fruits variable
**********************

``index`` initialize the variable ``@fruits``. As for ``edit``, ``index``  will render its corresponding 
view, but with the difference that we have made ``@fruits`` accessible in 
there. ``@fruits`` is given the value ``initialize_grid(Fruit)`` since we wish to render a grid of the Fruit database table in the index view. 
For ``update`` and ``delete``, it is possible to use the ``@fruit`` variable without initializing it as the 
preceding action (e.g. pressing a button) itself will make the object in question available in the view.

The create method
*****************

To create a new fruit, we begin by navigating to the corresponding url, which renders a page with a form. 
In the form, the parameters are set and then sent to the ``create`` method in our controller, wherein the object is saved. The ``save`` method is 
inherited from **ActiveRecord Base** (follow the inheritance line of our model **fruit.rb**!), and is what adds a new 
fruit model to the database table. The method returns either ``true`` or ``false`` depending on its success. 
(The process is the same for ``edit`` and ``update``!)

**Try it out!**
What happens when running ``Fruit.new`` in the Rails console? What happens when running 
``Fruit.new(id: 100, user_id: 1, name: “Orange”, isMoldy: true)``? Do these commands affect the 
outcome of ``Fruit.all`` (the contents of the database table)? Try instead running ``Fruit.new(id: 100, user_id: 1, name: “Orange”, isMoldy: true).save``, 
and see what happens :-).

redirect_to
***********

We see that ``create``, ``update`` and ``delete`` methods all have incorporated the ``redirect_to`` method. As the name suggests 
it redirects to a certain page. The first parameter points to the end destination and the second renders a flash 
message on the screen. These “end destinations” are accessed through the paths you see when running 

::

  rails routes | grep fruit

The edit path has ``(@fruit)`` at its end since the path is specific to each fruit, 
fsektionen.se/admin/frukter/[fruit_id]/redigera*, as one edits one fruit at a time. ``admin_fruits_path`` 
on the other hand refers to all fruits and takes you to fsektionen.se/admin/frukter*. Remember how we named this url 
path “frukter”? (Scroll up!)

fruit_params
************

Lastly, there is the ``fruit_params`` method. The contents of this method whitelists the attributes that are allowed to be 
saved, which is why this method is used in the ``create`` method. We have defined that ``:fruit`` is a required attribute, 
while the rest are optional. This was introduced to Rails 
as a security feature. ``fruit_params`` checks if ``params[:id]`` exist and then return a params hash with the given, accepted, 
attributes if it does. 

The "regular" controller
------------------------

This controller will be found in **web/app/controllers/fruits_controller.rb**. Since the explanations above were 
quite in-depth we’ll write out the complete controller directly:

  .. literalinclude:: Fruits/reg_fruits_controller.rb
    :language: ruby


Through the ``index`` method we want to retrieve all the fruits that belong to the user. We are able to do so using 
the ``includes`` method as we already have defined the relation between a user and their fruits with Associations. 
Unlike the admin controller, there is the ``show`` method, which will be used to show a single fruit. *Why is it necessary to define?*

================
Design the views
================

The views have already been mentioned quite a lot. If things feel a bit confusing right now, the views might help with the understanding. 
The views are found in **web/app/views/** and define the HTML styling of the fruits’ web pages. 

Admin view
----------

For the admin views we will create four files
* index.html.erb
* _form.html.erb
* new.html.erb
* edit.html.erb

which all previously have been referred to, one way or another.


Index
*****

This page will list all existing fruits in a table. As we initialized the variable ``@fruits = initialize_grid(Fruit)`` 
in the ``index`` method, we can easily create a table using the grid method.

  .. literalinclude:: Fruits/admin_index.html.erb
    :language: html+erb

You will notice throughout these files that there are code snippets of the form ``t(‘.something’)``. 
These are used in place of regular strings, e.g. ``“something”``, to enable Swedish and English translations. 
We will get to those later.

Code of the form ``<%= code %>`` are written in embedded Ruby, simply meaning we are embedding Ruby in an HTML file. 
An example of this is the aforementioned grid. In here we insert ``@fruits`` as a parameter, then for each row ``g``, we 
define the content of each column. In the first column we put the fruit owner by calling ``fruit.user``. This column is 
unique for having ``attribute: ‘user_id’`` as a parameter, which will automatically render a field to filter the grid rows 
according to the user’s name.

The third and fourth columns link to ``edit`` and ``delete`` methods for the fruit respectively. For the delete link we must 
have ``method: :delete`` as a parameter to specify that we want to delete the fruit. For ``edit`` we use the 
pre-existing path ``edit_admin_fruit``. Here we can see why there is no need to define an ``edit`` method in the controller.
In the index file there exists the ``fruit`` variable which points to each and every Fruit object. Through ``edit_admin_fruit_path(fruit)`` 
we make the fruit accessible in the edit view.

The last two sections render buttons used to filter and reset filter respectively. Above the grid we also have a button 
for creating a new fruit.

Form
****

The form is used both for creating and editing fruits. 

  .. literalinclude:: Fruits/admin_form.html.erb
    :language: html+erb

Using ``fruit.input`` we define what attributes we would like the form to ask for. ``fruit.button :submit`` renders a button 
the user has to press when done. The button label depends on the occurring action; if the form is used to create a fruit 
it will say “Skapa Frukt”, or to edit a fruit it will say “Uppdatera Frukt”.

Next to it there will be a button which redirects back to the fruit index page.

New
***

  .. literalinclude:: Fruits/admin_new.html.erb
    :language: html+erb

As mentioned, both **new** and **edit** will make use of the form. 

Edit
****

  .. literalinclude:: Fruits/admin_edit.html.erb
    :language: html+erb

This file is identical to **new**.

Styling with CSS
****************

We implement CSS code in a new file **_fruits.scss** in  **web/app/assets/stylesheets/partials/**.

  .. literalinclude:: Fruits/_fruits.scss
    :language: CSS

In the index file we make use of ``fruit-padding`` in the very beginning. This simply adds a space below the top section.

User view
---------

Here we will create the views for the regular user.

Index
*****

Unlike the admin index view, we only list the fruits belonging to the current user. The grid will only have columns 
for the fruits’ names and moldiness. Additionally, we will link to each fruit’s show page.
 
  .. literalinclude:: Fruits/reg_index.html.erb
    :language: html+erb

Show
****

On the show page we simply render the fruit’s name and a description of its moldiness.


  .. literalinclude:: Fruits/admin_index.html.erb
    :language: html+erb

======================
Write the translations
======================

Views
-----

  .. literalinclude:: Fruits/fruits_admin.sv.yml
    :language: yaml

  .. literalinclude:: Fruits/fruits.sv.yml
    :language: yaml

  .. code-block:: YAML

  .. literalinclude:: Fruits/fruits_admin.en.yml
    :language: yaml

  .. literalinclude:: Fruits/fruits.en.yml
    :language: yaml

Model
-----

  .. literalinclude:: Fruits/fruit.sv.yml
    :language: yaml

  .. literalinclude:: Fruits/fruit.en.yml
    :language: yaml

===================
Admin dropdown menu
===================

Lastly, we would like there to be a link to the admin pages in the dropdown menu. We go to 
**web/app/views/layouts/dropdowns/_admin_dropdown.html.erb** and add ``Fruit`` to the ``Övrigt`` section.

  .. code-block:: ruby

    <% all_privileges = { 'Användare' => [User, MailAlias, Group, Permission],
                          'Poster' => [Election, Council, Document],
                          'Information' => [News, Event, BlogPost],
                          'Spindelman' => [Menu, ShortLink, Constant, Category],
                          'Pryl' => [Rent, Tool, Door, AccessUser, Key],
                          'Övrigt' => [CafeShift, Introduction, Adventure, WorkPost, Faq, Page, Album, Contact, Meeting, Song, Fruit] } %>


=========
Read more
=========

* `Validations <https://guides.rubyonrails.org/active_record_validations.html>`_
* `Associations <https://guides.rubyonrails.org/association_basics.html>`_
* `Routes <https://guides.rubyonrails.org/routing.html>`_
* `Controllers <https://guides.rubyonrails.org/action_controller_overview.html>`_
* **`Inheritance in Rails Controllers <https://rmulhol.github.io/ruby/2015/04/27/solid-rails.html>`_
* `Rails rendering <https://www.rubyguides.com/2019/04/rails-render/>`_
* **`Parameters <https://www.rubyguides.com/2019/06/rails-params/>`_