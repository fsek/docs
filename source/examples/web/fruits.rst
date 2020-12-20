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

.. image:: pear.jpg
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

For each Rails object, there is a database table. We go to **web/app/db/** and create a new file called 
**20201129220000_create_fruits.rb** as we are about to create a database for the fruits on 29 November 2020 at 10 pm. 
This naming convention exists to structure the files according to their creation. 

Here we will specify what parameters there are.

::

	class CreateFruits < ActiveRecord::Migration[5.0]
  	def change
    	create_table :fruits do |t|
      	t.references :user
      	t.string :name, null: false
      	t.boolean :isMoldy, null: false, default: false
    	end
  	end
	end

We are saying that each fruit inhabits a name and degree of moldiness, neither of which can be empty (null), 
and is connected to a certain user. We have set the default value of isMoldy to false, as we would expect 
a new fruit to be fresh.

When this is finished we go to the terminal and run

::

	rails db:migrate


==============
Create a model
==============

This time the file and class name are singular, as opposed to the database elements that are plural. 
We go to **web/app/models/** and create a new file called **fruit.rb**.

::

	class Fruit < ApplicationRecord
  	belongs_to :user, required: true
	  validates :name, presence: true
	  validates_inclusion_of :isMoldy, in: [true, false]

  	def to_s
   	 name
  	end
	end

Here we once again see the different parameters. The model is used to make sure that the right 
values go into the fruits’ database table. 

First we specify the relation between a user and a fruit; since we wish the user to own fruits, 
and a fruit to be owned by a single user, we use the line belongs_to which describes it quite well. 
``belongs_to`` is an Association that makes the creation and deletion of objects smoother. 

The ``validates :name, presence true`` line ensures that a fruit only can be created if it is given a name. 
Same goes for ``isMoldy``. But how come we don’t write validates ``:isMoldy, presence: true``? Doing so will 
lead to some bugs when creating a fruit. Read the documentation for validates:

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

to enter the Rails console. We copy the situation in the illustration above by running

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

We have already declared the Association belongs_to for the fruit, but we also need to declare a related 
Association for the user. We go to **web/app/models/user.rb** and write the following line

::

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
in the list of users. Writing ``User.find(1)`` returns the user with id = 1, and is equivalent to ``User.first``.

=================
Define the routes
=================

In order for the fruits to show up on the website, the different routes have to be initialized in 
the file **web/app/config/routes.rb**. Before adding any code we have to be sure about who is supposed to 
have access to what. For this example we would like each user to be able to view their own fruits, 
and only admins to be able to create and delete fruits. We will therefore write

::

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