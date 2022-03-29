Fruits App
==========
============
Introduction
============


===========================
Prerequisits
===========================

Preparing your local web
------------------------
We will run the app against our local web and not stage in this example, and we need a working implementation of "Fruits" from our web examples. If you want, you can implement that yourself before you continue, or you can checkout the johanna-fruits-example branch on fsek/web. You probably want to do
::

    git pull origin master

if you use the johanna-fruits-example branch, since quite a few dependency upgrades have been deployed since the example was written. Also make sure that you have read through the example and understand roughly how it works, we will assume that you are somewhat familiar with the backend for "fruits" from this point onwards. Make sure that foreman s works, and create a few fruits so we have some data to work with.

App preparations
----------------
Make sure that you have cloned the App2 repository somewhere, and that you can run the app on an emulator.

===================
Create a git branch
===================
Once you have made sure that you can run the web server, we can start working on the app. As always when we make code changes, the first thing we want to do is to create a new branch. Head over to the location of your App2 repo clone, and do
::

    git checkout -b "app-fruit-example"

ofc you can use whatever name you like for the branch, but something descriptive is often nice.

==========================================
Configure the app to run against localhost
==========================================
Normally, the app will fetch data from stage.fsektionen.se, but we want to use the fruits-api which we are currently 
developing locally. Navigate to **lib/environments/environment.dart**. It will look like this:

    .. literalinclude:: Fruits/environment_initial.dart
        :language: dart
We want to change the API_URL variable to use localhost:3000, like this:
::

    static const String API_URL = "http://10.0.2.2:3000"

10.0.2.2 is the adress for localhost on the android emulator. We do not care about the CABLE_URL, since we will not use web 
sockets in this example. Start your local web server and make sure that the app connects to it from the emulator.

===============================
Adding an empty page for fruits
===============================
Now we are going to add an empty place holder page where we can eventually put our fruits. We will put it under the "Hilbert Cafe"
tab in the "Övrigt" section. First, we create the base files for what will eventually become our fruits page. Create a new
directory under **/lib/screens** called **fruits**, and add the file **fruits.dart**. We put a basic empty stateful widget in it:

    .. literalinclude:: Fruits/fruits_empty_page.dart
        :language: dart

Now we will need to be able to access our new page somehow. We want to add it among the items in "Övrigt", so we head over to 
**lib/screens/other.dart**. Among the import statements at the top of the file, we add:
::

    import 'package:fsek_mobile/screens/fruits/fruits.dart';

so we can use our fruit page. Around line 20, we find the line
::

    final catagories = ["Sångbok", "Bildgalleri", "Hilbert Café"];

Add the string "Frukter" to the end of the list. Further down in the file, we find a routeMap. Here we add the key-value pair
::

    "Frukter": FruitPage()

Now we should see "Frukter" under "Hilbert Cafe" in "Övrigt" in the app, clicking on it should open an empty page with an
appbar saying Frukter.

=================
Adding the fruits
=================
So far, we have only added some dummy static content. Now, we get to the interesting part! It is time to bring in our fruits!
We are going to interact with the website using the API. Data is sent over the API as json objects. On the web-side of things,
we 

MORE CONTENT WITH API BASICS


The general idea for piping data from the web to the app is as follows: We create a *service* that will make an http request to the server,
corresponding to an action in the API-controller over on our rails web site. The server will respond with a json object containing the data we requested.
We then parse this raw json-data into a dart object that we can use in our app.
Adding a fruit model and JSON parser
------------------------------------
In order to represent the fruit as a dart object, we create a fruit model. This is in many ways similar to the model for fruit
we created in rails. We head on over to **lib/models/home** and create the file **fruit.dart** (this is not rails, we can name
our model whatever we want, but descriptive names are nice). We are also going to need a fail **fruituser.dart** in the same
folder, for reasons that will soon be explained. 
    .. literalinclude:: Fruits/fruit_model.dart
        :language: dart

    .. literalinclude:: Fruits/fruituser_model.dart
        :language: dart

Don't worry about the warnings your linter is giving you, we will soon autogenerate a bunch of stuff, but first some comments
on the contents of these files. We want our fruit class to contain the fruit attributes that is sent to us over the API.
The serializer is responsible for converting the rails fruit object into json format, so we peek at the fruit serializer over
in our web repository (if you do not have such a serializer, read the prerequisits again). If you have the same implementation
as the one on "johanna-fruits-example", we see that we send the attributes id, name and is_moldy. These explain the first
three attirbutes in our **fruit.dart** file. We also see
::

    has_one :user

in the serializer. This means that we send the associated "user" object as a nested json in our fruit json representation.
When sending the corresponding user for a fruit, we do not need, nor want, every bit of information about that user, so the
fruit serializer for the index action has a UserSerializer that tells us which attributes to send for the user that owns the 
fruit. We can see that we only send id, firstname and lastname. We thus want a model for the type of user that is sent by the
fruit-API, and we call it FruitUser. FruitUser is a user that only has an id, a firstname and a lastname. We will now auto-generate
the code for parsing json into Fruits and FruitUsers. To do this, we run
::

    flutter pub run build_runner build

in the command line (this is my favorite command of all time). This should create files like **fruit.g.dart**.

Creating a FruitService
-----------------------
Now that we have a model for our fruits and can parse them from json, we need to create a service that makes the correct http 
request to the server, recieves the json response, parses it to dart objects and returns the results. We will start with a
service for the basic "index" action in rails. In **lib/services/** make a file called **fruit.service.dart**

    .. literalinclude:: Fruits/fruit_service_index.dart
        :language: dart

AbstractService wraps the basics for making an http request. We do not need to worry too much about it here, but feel free
to take a look at it if you want to. the index action in ruby will gives an object of the form 
:: 

    {"fruits" : [*JSON representation of fruit 1*, ....]}

and we parse that into a list of fruits. Depending on internet and server speed etc, we might have to wait a while for the
response to come, which async/await handles: we make a promise that our object will arrive at some point in the future, and
can continue execution of the program in the meantime. Finally, we need to register our FruitService on the service locator
so that we can use it. Go to **lib/services/service_locator.dart** and add the import statement 
:: 

    import 'package:fsek_mobile/services/fruit.service.dart';

and 
::

    locator.registerLazySingleton(() => FruitService());

where appropriate.

=============================
Adding the fruits on our page
=============================
Now we have a way to fetch fruits from the website, so it's time to return to our mostly empty fruit page and start to populate
it. Go back to **lib/screens/fruits/fruits.dart**, and modify it to look like this:

   .. literalinclude:: Fruits/fruits_added_state.dart

We have now added an initState function for our stateful widget. This initializes the state of the widget when it is first built.
We add the attribute fruits, which will contain a list of all the fruit objects we recieve from the API call, and make the API call
with the service we created. With our list of fruits ready, we can begin to fill the page. We add a listView with text widgets containing
the fruit names to the page.

   .. literalinclude:: Fruits/fruits_plain_text.dart
       :language: dart

This is a good point to stop, take a step back, and make sure that everything is working as intended. We should now be able to click
on the "Frukter" button in "Övrigt", and see an (ugly) list of fruit names, with all the fruits we have created on the web.

Improving the list of fruits
----------------------------
Once we've made sure that things work as intended up to this point, it is time to start doing some basic styling. We probably want
the list of fruits to contain clickable cards, that direct you to individual fruit pages with slightly more information in them.
Eventually, that means adding the "show" action to our FruitService, but before we do that, we prepare the cards. We do something similar
to this: 

    .. literalinclude:: Fruits/fruits_dummy_cards.dart

We've replaced the text widget in our list view with a custom private widget, _FruitCard, that creates clickable cards for each fruit.
The click does not do anything yet: the onTap function is an empty lambda expression. Feel free to expermient with the styling of the
_FruitCard here. Perhaps we want a different color? A different text font? Different layouts?

===========================
Adding pages for each fruit
===========================
Modify service
--------------
With an (hopefully pretty) fruit list completed, we can think about adding individual pages for each fruit. First, we modify our service 
to fetch data for singular fruits. This is the "show" action in rails, and we reach that action in the API-controller by sending a 
http GET request to the path API_URL/frukter/*id for fruit we want*. Go vack to **lib/services/fruit.service.dart** and add a function
getFruit:

::

    Future<Fruit> getFruit(int id) async {
        Map json = await AbstractService.get("/frukter/$id");
        return Fruit.fromJson(json['fruit']);
    }


Adding a widget to display individual fruits
--------------------------------------------
We will now make a very basic widget to display the fruits individually, to make sure everything works. Create a new file in
**lib/screen/fruits**, and call it for example **fruitview.dart** (again, reminder that this is not rails and we can name things
whatever we want).
    .. literalinclude:: Fruits/fruits_basic_fruitview.dart

Compare this to what we did initially when we made the simple text list for the fruits. This time, we get a single fruit
instead of a list of fruits, but otherwise the basic structure for the widgets are very similar.

Finally, we want to make the cards in our list navigate to this widget. Replace the empty onTap in the InkWell in the _FruitCard
with 
:: 

    onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FruitView(id: fruit.id ?? -1)));
    },

What import statement will you need to add for this to work? Make sure that the page navigation works when you click on the _FruitCards.

=================================
Styling the individual fruit page
=================================
Finally, we add some basic styling to the individual fruit pages. For example, we probably want to display the moldiness of the fruits
on the individual page in some way. Here's an example for how one could modify **lib/screens/fruits/fruitview.dart** to be somewhat
more helpful
    .. literalinclude:: Fruits/fruitview.dart
Once again, feel free to experiment here.


=======================
Ideas to try on you own
=======================
This example covers the basics of how to fetch data from the web and use it to implement new features in the app. There are
a lot of things you could try to do on your own to expand upon it if you want to learn more about how the web and app interacts! Here are some ideas:
* Currently, the fruit index lists all fruits for all users. We probably only want to fetch the fruits belonging to the current user. How would
  you fix that in the web backend?
* It would be nice to be able to create and delete fruits in the app! What actions would you have to add to the API-controller? What http 
  requests to does actions correspond to? What would you add to the fruit service to carry out those actions?