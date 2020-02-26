Task
====

The task for the second TCP (2019) was to create an online webshop for the F-guild. Below one can find a detailed description of the task.

Rails
-----

1. Create a database table ``store_product`` in ``web/db/migrate``. Each product should have the following fields: ``name``, ``price``, ``image_url`` and ``in_stock``. Remember to assign each field with an appropriate type, specify whether or not it should be mandatory and or if it should have a default value. The price should be saved in Swedish öre. Use the code below and add the missing code.

    .. code-block:: ruby

        # web/db/migrate/YYYYMMDDHHMMSS_create_store_products.rb
        class CreateStoreProducts < ActiveRecord::Migration[5.0]
          def change
            create_table :store_products do |t|
              # TODO. Add the four fields here.

              t.timestamps null: false
            end
          end
        end

2. Create the corresponding ``model`` for Rails in ``web/app/models``. Think of the validations, e.g. that a price should not be able to be negative. Also, implement a ``to_s`` method in the ``model``.

3. Migrate the database using ``rails db:migrate`` and create a few test products using the Rails console. This console in entered by typing ``rails c``. *Hint:* By typing ``StoreProduct`` in the Rails console you should be able too see all of its fields. This is a good way to test that everything works as expected.

4. Add an admin route to ``web/config/routes.rb`` by adding a few lines in the "User-related routes" section. The path to the products should be ``/produkter``. You have successfully set up the route if you get an ``uninitialized constant`` error when going to ``tcp://localhost:3000/admin/produkter``.

5. Implement an admin ``controller``. Copy and paste the following script and fill in the missing code:

    .. code-block:: ruby

        # web/app/controllers/admin/store_products_controller.rb
        class Admin::StoreProductsController < Admin::BaseController
          load_permissions_and_authorize_resource

          def new
            # TODO
          end

          def index
            # TODO. This method should return a grid initialization.
          end

          def edit
            @store_product = StoreProduct.find(params[:id])
          end

          def create
            # TODO. First, make a new StoreProduct object and then try to save it.
            # Use `redirect_to` with an appropriate path and `notice` saying something
            # relevant depending on if it was saved successfully or not.
          end

          def update
            # TODO. The StoreProduct that is being updated should be named @store_product.
          end

          def destroy
            @store_product = StoreProduct.find(params[:id])
            if @store_product.destroy
              redirect_to admin_store_products_path, notice: alert_destroy(StoreProduct)
            else
              redirect_to edit_admin_store_product_path, notice: alert_danger('Kunde inte förinta produkt')
            end
          end

          # All methods below this will be private
          private

          def store_product_params
            # This method ensures that the hash we get from the view has
            # a `StoreProduct`, and that we allow the permitted fields to be updated.
            params.require(:store_product).permit(:name, :price, :image_url, :in_stock)
          end
        end

   *Hints:* Type ``rails routes | grep store`` to see all paths that have the word ``store`` in it. Make use of the ``store_product_params`` method when creating a new product.

6. Create a few basic ``views`` to list and create new products. These ``views`` should be placed in ``web/views/admin/store_products``, namely

    .. code-block:: bash

        web/views/admin/store_products/
            _form.html.erb
            edit.html.erb
            index.html.erb
            new.html.erb

   The code for ``edit.html.erb`` can be found here:

    .. code-block:: erb

        <% # web/app/views/admin/store_products/edit.html.erb %>
        <div class="col-md-10 col-md-offset-1 col-sm-12 reg-page">
          <div class="headline">
            <h1><%= 'Redigera produkt' %></h1>
          </div>
          <%= render('form', store_product: @store_product) %>
          <hr>
          <%= link_to('Förinta', admin_store_product_path(@store_product),
                                    method: :delete,
                                    data: {confirm: 'Är du säker på att du vill förinta produkten?'},
                                    class: 'btn danger pull-right') %>
          <%= link_to('Alla produkter', admin_store_products_path, class: 'btn secondary') %>
        </div>

   When you have implemented the views, make sure that they work as expected before moving to the next task.

7. Create a ``serializer`` for the products. Copy and paste the following script and implement the missing code:

    .. code-block:: ruby

        # web/app/serializers/api/store_product_serializer.rb
        class Api::StoreProductSerializer < ActiveModel::Serializer
          class Api::StoreProductSerializer::Index < ActiveModel::Serializer
            # TODO. Include all fields
          end
        end

8. Create an ``API controller`` for the store and implement the ``index`` method below. *Hint:* By doing task 10 and commenting out ``load_permissions_and_authorize_resource`` you can test if your ``API controller`` and ``serializer`` works as expected.

    .. code-block:: ruby

        # web/app/controllers/api/store_products_controller.rb
        class Api::StoreProductsController < Api::BaseController
          load_permissions_and_authorize_resource

          def index
            # TODO. This should return a JSON object containing all products.
          end
        end

9. Add the rights to fetch the products for all signed in users in ``abilities``. This file can be found in  ``web/app/models/ability.rb``.

10. Add an API route for the created ``API controller`` in ``routes.rb`` and test that it works. The path will become what you write after ``resources``, e.g. ``tcp://localhost:3000/api/songs``. *Hint:* By removing ``load_permissions_and_authorize_resource`` from the ``API controller`` you can fetch the data without being logged in, allowing you to simply test your ``API controller`` and ``serializer``.

App
---

0. Replace line 9 in ``app/www/index.html`` with:

    .. code-block:: html

        <!-- app/www/index.html -->
        <meta http-equiv="Content-Security-Policy" content="default-src 'self' https://stage.fsektionen.se https://fsektionen.se wss://fsektionen.se wss://stage.fsektionen.se gap://ready 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; child-src 'self' https://www.youtube.com gap://ready; media-src *; img-src * 'self' https://stage.fsektionen.se https://fsektionen.se data:" />

1. Create a HTML, SCSS and JS file for the F-store. Don't forget to load the JS file in ``index.html`` and the SCSS file in ``index.scss``. Copy and paste the following outline of the JS file to the newly created one:

    .. code-block:: js

        // app/www/js/store.js
        $$(document).on('', '', function () {       // TODO
          let storeProductAPIEndpointURL = '';      // TODO

          $.getJSON(storeProductAPIEndpointURL)
            .done(function(resp) {
              initStore(resp);
            })
            .fail(function(resp) {
              console.log(resp.statusText);
            });

          function initStore(resp) {
            // TODO
          }
        });

   This is the general structure of our JS files. We first fetch the data and then send it to a function called ``initSomething`` where we handle the rest. Note that the other files don't need to contain any code at this point.

2. Add routes to the store in the alternatives view. The ``name`` should be ``store`` and ``url`` should be the relative path to the created HTML file. The routes are defined in ``index.js``.

3. Implement the created HTML file similarly to the other pages. Remember to set the ``date-name`` to the ``name`` you defined in the routes in the previous task, i.e. ``store``.

4. Add navigation to the new page in the alternatives tab. This is done by adding a few lines of code to the ``<div id="view-alternatives" class="view tab"></div>`` in ``index.html``. The ``<a>`` tag should referene to the path you defined in the routes in task 2.

5. Catch the ``page:init`` event in the created JS file. Make sure that it works by logging ``Spodermon iz kewl``.

6. Fetch data from the API endpoint called ``store_products`` and log it.

7. Create a template in ``index.html`` and test that it works. The latter is done by calling the template in the JS file and storing the HTML code in the store container. Note that the template does not have to handle potential input data, it should only be able to be used correctly.

8. Edit the template such that it generates a store. The page should make use of `Framework7 Cards`_ to display information about the products. On the cards there should be a button where one should be able to purchase the product. Remember that the price of the products are in Swedish Öre. *Hint:* Scroll down on the Framework 7 Cards documentation to see some examples.

9. Create an ``onClick`` event for the buy button that makes a ``POST`` request to ``https://stage.fsektionen.se/api/store_orders`` to be able to purchase the product. This should be done by calling the following function with the product ``id`` as the input argument:

    .. code-block:: js

        // app/www/js/store.js
        function buyProduct(id) {
          $.ajax({
            url: '',                    // TODO
            type: '',                   // TODO
            dataType: 'json',
            data: {},                   // TODO
            success: function(resp) {
              app.dialog.alert(resp.success, 'Varan är köpt');
            },
            error: function(resp) {
              app.dialog.alert(resp.responseJSON.error);
            }
          });
        }

   Make sure that the ``POST`` request is successful. The data of the ``POST`` request should contain an ``item`` object with ``id`` and ``quantity`` as data. Below you can find an example of the structure of the data.

    .. code-block:: bash

        "item": {
            "id": 1,
            "quantity": 1
        }

10. Style the page so it looks fresh.

.. _Framework7 Cards: https://framework7.io/docs/cards.html
