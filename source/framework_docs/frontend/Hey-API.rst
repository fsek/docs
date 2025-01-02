Hey-API
=======


Hey-API is a crucial part of our frontend and maybe the most important package we are using right now (28/12-2024).

============
What it does
============

Hey-API uses something called OpenAPI to **AUTOMATICALLY** generate API routes in the frontend that can be used to communicate with our backend. 
This saves us lots of time because we don't have to build our own routes every time a new route is added in the backend. Instead we can run: ::
    npm run generate-api
Which generates all the routes as they are in the backend. For this to work the backend needs to be run locally to work. 
If in production it will generate the routes from the production service (NOT IMPLEMENTED YEY).


