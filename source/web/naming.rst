Naming Conventions
==================

Functions
---------

The Python functions in a route definition should be named descriptively. The name of the function is used as a description in Swagger, which makes it easy to understand what a route is supposed to do in Swagger if named clearly. For example, a function named ``create_example`` will get the description "Create Example" in Swagger.

- **Use snake_case** for function names.
- Choose a name that describes the function’s purpose clearly. For instance, ``create_example`` is more descriptive than ``example_creation``.

Schemas
-------

For many different objects, a lot of basic schemas will be used for similar purposes. One common naming convention is to follow CRUD (Create, Read, Update, and Delete), which describes how the most common schemas should be named.

Let’s say we want to create some schemas for a database model called *Example*. For the different routes, the schemas should ideally be named:

- **POST route**: ``ExampleCreate``
- **GET route**: ``ExampleRead``
- **PATCH route**: ``ExampleUpdate``
- **DELETE route**: ``ExampleDelete``

All schemas should be written in **PascalCase**.

Database Models
---------------

Database models should be written in **PascalCase** with the suffix ``_DB``. For example: ``C
