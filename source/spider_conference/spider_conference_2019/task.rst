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

4. Add an admin route to ``web/config/routes.rb`` by adding a few lines in the "User-related routes" section. The path to the products should be ``/produkter``.

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
            # TODO
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

        class Api::StoreProductsController < Api::BaseController
          load_permissions_and_authorize_resource

          def index
            # TODO. This should return a JSON object containing all products.
          end
        end

9. Add the rights to fetch the products for all users in ``abilities``. This file can be found in  ``web/app/models/ability.rb``.

10. Add an API route for the created ``API controller`` in ``routes.rb`` and test that it works.
