Solution
========

This is an example implementation of the F-store. It can also be found in its entirety `here`_ on GitHub.

.. _here: https://github.com/fsek/web/compare/david-web-intro-2020

Rails
-----

1. The time at which the file was created and its class name should be in the filename.

    .. code-block:: ruby

        # web/app/db/migrate/YYYYMMDDHHMMSS_create_store_products.rb
        class CreateStoreProducts < ActiveRecord::Migration[5.0]
          def change
            create_table :store_products do |t|
              t.string :name, null: false
              t.integer :price, null: false, default: 0
              t.text :image_url
              t.boolean :in_stock, null: false

              t.timestamps null: false
            end
          end
        end

   In this example implementation we have set the fields ``name``, ``price`` and ``in_stock`` as mandatory. This was done by specifing ``null: false``. We have also set the default ``price`` to zero using ``default: 0``. Thus one can create a product without specifying a price, since the default value then will be set, resulting in the field being filled. We also always want to have ``timestamps`` to be able to see when each product was created.

2. For Rails to recognize the model it is important that the class and filename is in singular.

    .. code-block:: ruby

        # web/app/models/store_product
        class StoreProduct < ApplicationRecord
          validates :name, presence: true
          validates :price, numericality: { greater_than_or_equal_to: 0 }

          scope :in_stock, -> { where(in_stock: true) }

          def to_s
            name
          end
        end

   Here we require that each ``StoreProduct`` must have a ``name`` by setting ``presence: true``. In the ``model`` one can also specify ``scopes``. In this case, calling ``StoreProducts.in_stock`` will return all the products that have the attribute ``in_stock`` set to ``true``.

3. Creating and saving a ``StoreProduct`` can e.g. by done by typing

    .. code-block:: ruby

        StoreProduct.create!(name: 'Product 1', price: 100, in_stock: true)

   into the Rails console.

4. The ``except`` statement can be used if some methods are not implemented in the ``controller``, which in this case is the ``show`` action.

    .. code-block:: ruby

        # web/app/config/routes.rb
        namespace :admin do
          resources :store_products, except: [:show], path: :produkter
        end

5. Here follows the entire ``controller`` file:

    .. code-block:: ruby

        # web/app/controllers/admin/store_products_controller.rb
        class Admin::StoreProductsController < Admin::BaseController
          load_permissions_and_authorize_resource

          def new
            @store_product = StoreProduct.new
          end

          def index
            @store_products = initialize_grid(StoreProduct.all, order: :name)
          end

          def edit
            @store_product = StoreProduct.find(params[:id])
          end

          def create
            @store_product = StoreProduct.new(store_product_params)
            if @store_product.save
              redirect_to admin_store_products_path, notice: alert_create(StoreProduct)
            else
              redirect_to new_admin_store_product_path(@store_product), notice: alert_danger('Kunde inte skapa produkt')
            end
          end

          def update
            @store_product = StoreProduct.find(params[:id])
            if @store_product.update(store_product_params)
              redirect_to admin_store_products_path, notice: alert_update(StoreProduct)
            else
              redirect_to edit_admin_store_product_path(@store_product), notice: alert_danger('Kunde inte uppdatera produkt')
            end
          end

          def destroy
            @store_product = StoreProduct.find(params[:id])
            if @store_product.destroy
              redirect_to admin_store_products_path, notice: alert_destroy(StoreProduct)
            else
              redirect_to edit_admin_store_product_path, notice: alert_danger('Kunde inte förinta produkt')
            end
          end

          private

          def store_product_params
            params.require(:store_product).permit(:name, :price, :image_url, :in_stock)
          end
        end

6. Here follows the code for all the ``views``:

    .. code-block:: erb

        <% # web/app/views/admin/store_products/index.html.erb %>
        <div class="headline">
          <h1><%= title('Produkter') %></h1>
        </div>

        <div class="col-md-2 col-sm-12">
          <%= link_to('Ny produkt', new_admin_store_product_path, class: 'btn primary') %>
        </div>

        <div class="col-md-10 col-sm-12">
          <%= grid(@store_products) do |g|
            g.column(name: 'Namn', attribute: 'name') do |product|
              link_to(product, edit_admin_store_product_path(product))
            end
            g.column(name: 'Pris', attribute: 'price', filter: false)
            g.column(name: 'I lager', attribute: 'in_stock', filter: false) do |product|
              if product.in_stock? then t('global.yes') else t('global.no') end
            end
          end -%>
        </div>

   Two comments regarding the code above. Firstly, the ``filter: false`` argument will remove the possibility to search that column, i.e. that one cannot search for all prodcuts with e.g. the price ``37``. Secondly, for the ``in_stock`` column we replace the value with ``t('global.yes')`` or ``t('global.no')`` depending on if the product is in stock or not. Rails fetches these values from a translation file (``web/config/locales/views/global.sv.yml`` if the website is set to display in Swedish) where a (Swedish) translation of ``Yes`` and ``No`` exists.

    .. code-block:: erb

        <% # web/app/views/admin/store_products/_form.html.erb %>
        <%= simple_form_for([:admin, store_product]) do |f| %>
          <%= f.input :name %>
          <%= f.input :price %>
          <%= f.input :in_stock %>
          <%= f.input :image_url %>
          <%= f.button :submit %>
        <% end %>

    .. code-block:: erb

        <% # web/app/views/admin/store_products/new.html.erb %>
        <div class="col-md-10 col-md-offset-1 col-sm-12 reg-page">
          <div class="headline">
            <h3><%= title('Ny produkt') %></h3>
          </div>

          <%= render('form', store_product: @store_product) %>
          <hr>
          <%= link_to('Alla produkter', admin_store_products_path, class: 'btn secondary') %>
        </div>


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

7. Here, all the fields are included in the ``Index`` serializer.

    .. code-block:: ruby

        # web/app/serializers/api/store_product_serializer.rb
        class Api::StoreProductSerializer < ActiveModel::Serializer
          class Api::StoreProductSerializer::Index < ActiveModel::Serializer
            attributes(:name, :price, :in_stock, :image_url)
          end
        end

8. The ``API controller`` formats the data of each product with the implemented ``StoreProductSerializer`` and outputs everything as a JSON object.

    .. code-block:: ruby

        # web/app/controllers/api/store_products_controller.rb
        class Api::StoreProductsController < Api::BaseController
          load_permissions_and_authorize_resource

          def index
            @store_products = StoreProduct.all
            render json: @store_products, each_serializer: Api::StoreProductSerializer::Index
          end
        end

9. The ability to see all products can be done by writing:

    .. code-block:: ruby

        # web/app/models/ability.rb
        can :index, StoreProduct

10. With ``only`` we specify that the only serializer we have implemented is ``Index``.

    .. code-block:: ruby

        # web/app/config/routes.rb
        resources :store_products, only: :index
