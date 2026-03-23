.. _backend_tutorial:

Backend Code Tutorial
=====================

This tutorial will guide you through the basics of our backend code. You will be creating a simple data object and learning how to interact with it using CRUD (Create, Read, Update, Delete) operations.

Preparation
-----------

To work through this tutorial, you will need:

- A local copy of the backend codebase. Install it using the `github README instructions`_.
- Git installed and configured on your machine. Use only the git part of :ref:`this guide <install_git>`.

.. _`github README instructions`: https://github.com/fsek/WebWebWeb

.. _how_the_backend_works:

How the Backend Works
---------------------

When a request comes into the backend (for example, when a user tries to load a page and sends a GET request), it goes through several layers before reaching the database and sending a response back to the user. Below is a simplified overview of the process. You don't need to understand all the details now, but at the end of the tutorial you should be able to see how the different parts fit together. You can return to this section later as you work through the tutorial.

1. The request hits our server (``uvicorn``) and gets passed to FastAPI's application object in ``main.py``.
2. FastAPI matches the URL (eg. "/fruits") and HTTP verb (eg. "GET") to one of the routers in ``routes/`` (you will add ``fruit_router`` there later in this tutorial).
3. Dependencies run before the route handler (the handler is the function which handles the request. eg. "get_fruit()"). We create a database session (``DB_dependency``) and check permissions (``Permission.require(...)``).
4. The route handler uses SQLAlchemy ORM models in ``db_models/`` to read or change rows in the database inside that session.
5. Pydantic schemas in ``api_schemas/`` validate incoming data and serialize outgoing data so responses have the shapes and types we expect.
6. The handler returns a Python object. Pydantic once again validates this outgoing data against the schemas. 
7. FastAPI turns the Python object into JSON, sets the HTTP status code, and sends the response back to the client.
8. If something goes wrong (for example, a fruit is not found), the handler raises ``HTTPException`` so FastAPI can send the right error code to the caller.

Keep this mental model handy as you work through the steps below - each step in the tutorial plugs into one of these layers.


Create a Git Branch
--------------------

Git is great for keeping track of changes in code. You should always create a new branch when working on a new feature or bugfix. This keeps your changes organized and makes it easier for others to help you later on. First run this to make sure you are up to date with the latest changes, and branch off the main branch: ::

    git checkout main
    git pull origin main
    
Now we create the branch of off main. You should run this in the terminal: ::

    git checkout -b COOL-NAME-FOR-YOUR-BRANCH

Replace ``COOL-NAME-FOR-YOUR-BRANCH`` with a descriptive name for your branch. 

Creating a Data Object
---------------------

Great! Now we are ready to start coding. We will be creating a simple data object called "Fruit" with attributes like "name" and "color". The first step is to define the data model. Go to the ``db_models`` directory and create a new file called ``fruit_model.py``. In this file, define the Fruit model using SQLAlchemy ORM (Object-Relational Mapping): ::

    from db_models.base_model import BaseModel_DB
    from sqlalchemy import String
    from sqlalchemy.orm import mapped_column, Mapped

    class Fruit_DB(BaseModel_DB):
        __tablename__ = "fruit_table"

        id: Mapped[int] = mapped_column(primary_key=True, init=False)

        name: Mapped[str] = mapped_column()

        color: Mapped[str] = mapped_column()

        price: Mapped[int] = mapped_column()


This code defines a Fruit model with four attributes: id, name, color, and price. The import statements bring in the necessary SQLAlchemy components to define the model. You don't need to understand all the details for now, but I'll try to explain the important parts:

- BaseModel_DB is the base class for all database models in our codebase. We primarily use it for timestamps and other common functionality.
- __tablename__ specifies the name of the database table that will store Fruit objects. This gets created automatically so you don't need to worry about it.
- Mapped and mapped_column are SQLAlchemy's way of saying “this class attribute is a database column.”. Most of the time, you can look at similar examples in other models to figure out how to define new attributes.
- The id attribute is special. Since names, colors and prices can be the same for different fruits, we need a unique ID which can be used to retrieve a specific fruit. Since id is marked primary_key, it has this function. We also mark it with init=False which tells SQLAlchemy not to expect this value when creating a new fruit object, as it is generated automatically by the database.

You are very welcome to add another attribute if you want to! This will force you to think through the example code a little bit more and not simply copy/paste all the examples. Something simple like a boolean ``is_moldy`` might be suitable, and won't require you to change the example code too much.

Now that we've got a basic model, we want to move on to:

Database Schema
---------------

The database schema tells our backend server what types of things it should expect to receive and send out, so that it can perform type checking and tell us if something goes wrong right away. The schema will for example prevent sending a string "thirty one" as the price of the fruit. This part is pretty simple. Go to the ``api_schemas`` directory and add a new file ``fruit_schema.py``: ::

    from api_schemas.base_schema import BaseSchema

    class FruitRead(BaseSchema):
        id: int
        name: str
        color: str
        price: int


    class FruitCreate(BaseSchema):
        name: str
        color: str
        price: int


    class FruitUpdate(BaseSchema):
        name: str | None = None
        color: str | None = None
        price: int | None = None

.. hint::
   You might wonder why we define the fields twice (once in ``db_models`` and once here). The **Model** represents the database table, while the **Schema** represents the public API. Keeping them separate allows us to hide internal database fields (like passwords or internal flags) from the public API.

As you can see, we import the BaseSchema which gives us some nice basics, then we define three schemas for different operations and tell Pydantic (basically the type checker) what fields and types to expect. ``| None = None`` essentially says "If we don't get any value for this field, just pretend it's None.". This allows us to only include the fields we want to change when updating a fruit. Note that this doesn't mean the object in the database will be updated to have None in those fields, any changes to the database happen later in the router code.

.. note::
   This maps directly to :ref:`How the Backend Works <how_the_backend_works>` steps 5-6 (schema validation and serialization).

With the database schema done, we should not get any type errors when moving on to the next step:

Creating a Router
-----------------

The router defines what people are allowed to do with the fruits in our database. We will only add the CRUD (Create, Read, Update, Delete) operations, but it's possible to get a lot more creative with what the routes do.

.. note::
   In :ref:`How the Backend Works <how_the_backend_works>` steps 2-4, routers, dependencies, and handlers sit in the middle of the request flow.

Let's start by creating the router file. This file will contain the four routes we will make for this tutorial. This is easily the most involved and complex part of the tutorial, routes can (and do!) get very long with a lot of complex logic to allow or forbid users from doing certain things with the database objects. This tutorial will try to keep things pretty simple, but remember you can always ask a su-perman if you feel something is especially confusing.

All our routes are in the ``routes`` directory, create a new file ``fruit_router.py`` in there and add the following imports to that file. Don't worry too much about understanding these. ::

    from fastapi import APIRouter, HTTPException, status
    from api_schemas.fruit_schema import FruitCreate, FruitRead, FruitUpdate
    from database import DB_dependency
    from db_models.fruit_model import Fruit_DB
    from user.permission import Permission

    fruit_router = APIRouter()

``fruit_router`` is now the router which will contain all of our individual routes, which we'll go through one by one now.

Read
^^^^

We tend to start our router files with the Read route(s) for some reason. You should use something like this: ::

    @fruit_router.get("/{fruit_id}", response_model=FruitRead)
    def get_fruit(fruit_id: int, db: DB_dependency):
        fruit = db.query(Fruit_DB).filter_by(id=fruit_id).one_or_none()
        if fruit is None:
            raise HTTPException(status.HTTP_404_NOT_FOUND)
        return fruit

I'll walk through this line by line: ::

    @fruit_router.get("/{fruit_id}", response_model=FruitRead)

This line tells FastAPI that this function is a GET route at the URL path /{fruit_id}. The {fruit_id} part is a variable that will be filled in when calling the route. The response_model=FruitRead part tells FastAPI (which tells Pydantic) to use the FruitRead schema to validate and serialize the response data. ::  

    def get_fruit(fruit_id: int, db: DB_dependency):

This line defines the function get_fruit which takes two parameters: fruit_id and db. The passing of db happens automatically and just connects the route to the database. ::  

    fruit = db.query(Fruit_DB).filter_by(id=fruit_id).one_or_none()

Now we query the database for a fruit with the given fruit_id. If no such fruit exists, one_or_none() will return None. ::  

    if fruit is None:
        raise HTTPException(status.HTTP_404_NOT_FOUND)

If no fruit was found, we raise a 404 Not Found HTTP exception. ::

    return fruit

If a fruit was found, we return it. FastAPI will automatically serialize it to JSON using the FruitRead schema since we specified that in the first line.

.. note::
   This is a concrete example of :ref:`How the Backend Works <how_the_backend_works>` steps 5-7.

Create
^^^^^^

We can now read fruit objects, so let's add a route to create new fruits! ::

    @fruit_router.post("/", response_model=FruitRead, dependencies=[Permission.require("manage", "User")])
    def create_fruit(fruit_data: FruitCreate, db: DB_dependency):
        fruit = Fruit_DB(
            name=fruit_data.name,
            color=fruit_data.color,
            price=fruit_data.price,
        )
        db.add(fruit)
        db.commit()
        return fruit

I'll explain this one line by line as well: ::

    @fruit_router.post("/", response_model=FruitRead, dependencies=[Permission.require("manage", "User")])

This line tells FastAPI that this function is a POST route at the URL path /. The response_model=FruitRead part tells FastAPI to use the FruitRead schema to validate and serialize the response data. The dependencies part ensures that only users with the "manage" permission for "User" can access this route. 

.. note:: 
    Usually you really don't want to use "User" here, but adding a new permission target for "Fruit" is difficult for this tutorial so we use "User" for now.
    
::  

    def create_fruit(fruit_data: FruitCreate, db: DB_dependency):

Like before, we define the function create_fruit which takes two parameters: fruit_data and db. The fruit_data parameter is automatically populated by FastAPI from the request body using the FruitCreate schema. ::  

    fruit = Fruit_DB(
        name=fruit_data.name,
        color=fruit_data.color,
        price=fruit_data.price,
    )

Here we create a new Fruit_DB object using the data from fruit_data. ::

    db.add(fruit)
    db.commit()

db.add(fruit) adds the new fruit to the database session, and db.commit() saves the changes to the database. ::

    return fruit

Finally, we return the newly created fruit. FastAPI will serialize it to JSON using the FruitRead schema. In our frontend, this is rarely used since we usually GET all fruits at once after creating it to make sure we have the latest data.

Okay, now we can move on to the Update route. This one will go a little faster since you should be getting the hang of it by now.

Update
^^^^^^

Use this code: ::

    @fruit_router.patch("/{fruit_id}", response_model=FruitRead, dependencies=[Permission.require("manage", "User")])
    def update_fruit(fruit_id: int, fruit_data: FruitUpdate, db: DB_dependency):
        fruit = db.query(Fruit_DB).filter_by(id=fruit_id).one_or_none()
        if fruit is None:
            raise HTTPException(status.HTTP_404_NOT_FOUND)

        # This does not allow one to "unset" values that could be null but aren't currently
        for var, value in vars(fruit_data).items():
            if value is not None:
                setattr(fruit, var, value)

        db.commit()
        return fruit

As you can see, we still only allow users with the "manage" permission for "User" to access this route. The rest of the code is similar to what we've seen before. The only new part is the loop that updates the fruit's attributes based on the data provided in fruit_data. If a value is None, we skip updating that attribute. ``setattr(fruit, var, value)`` is a built-in Python function that sets the attribute named var of the fruit object to the given value.


Delete
^^^^^^

You have all the knowledge needed to understand this last route. Here it is: ::

    @fruit_router.delete("/{fruit_id}", response_model=FruitRead, dependencies=[Permission.require("manage", "User")])
    def delete_fruit(fruit_id: int, db: DB_dependency):
        fruit = db.query(Fruit_DB).filter_by(id=fruit_id).one_or_none()
        if fruit is None:
            raise HTTPException(status.HTTP_404_NOT_FOUND)
        db.delete(fruit)
        db.commit()
        return fruit

As in the earlier routes, the response path matches :ref:`How the Backend Works <how_the_backend_works>` steps 5-7.


Add the Router to the Application
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The main program needs to know about your new router in order for it to work. Go to routes/__init__.py and add the following import at the top. ::

    from routes.fruit_router import fruit_router

Then, find the section where other routers are included and add this line: ::

    app.include_router(fruit_router, prefix="/fruits", tags=["Fruits"])

.. note::
   This is the wiring described in :ref:`How the Backend Works <how_the_backend_works>` step 2 (router registration).

Great! You have now created all four CRUD routes for the Fruit model. This is a good time to take a step back and review what you've done. Next up is testing your new routes to make sure they work as expected.


Testing the Routes
------------------

You should always test your routes to make sure they work as you expect them to. We really encourage you to write automated tests for your routes (ask a su-perman if you need help with that), but the easiest way to test them quickly is to use the built-in Swagger UI that comes with FastAPI. Start the backend with the command ``uvicorn main:app --reload`` and open your web browser to ``http://localhost:8000/docs``.

You should see the Swagger UI with a list of all available routes. You will have to log in first using the "Authorize" button in the top right corner to test the routes that require permissions. Ask a su-perman for the account details.

.. tip::
   Testing can really help during development. Test your routes manually as you create them, and when you create pull requests always include automated tests to ensure your code works as expected and to prevent future changes from breaking it. (You can ask a su-perman or bot for help with writing tests!)

Now that you're logged in, find your fruit routes in the list and test them out one by one. Make sure to test all four CRUD operations to ensure everything works as expected.

If everything works, congratulations! You've successfully created a new data object with CRUD operations in our backend codebase. If you encounter any issues, don't hesitate to ask a su-perman for help.


Next Steps
----------

This is a really simple example meant to get you started. When you add new objects in the real codebase, it often helps to start from an existing similar object and modify it to fit your needs. You will also often need to add more complex logic to the routes, for example to handle relationships between different objects or to enforce more specific permission checks. If you want to continue this example, you could try adding:

- Actually using "Fruit" as a permission target instead of "User".
- Writing automated tests for the fruit routes to ensure they work as expected. The more complex the routes get, the more important this becomes.
- Adding relationships to other models, for example a "Basket" model that can contain multiple fruits.
- Adding an is_moldy attribute which defaults to False and halves the price if toggled to True and doubles it if untoggled.



