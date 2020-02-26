Solution
========

This is an example implementation of the F-store. It can also be found in its entirety on GitHub here: `Rails`_, `app`_.

.. _Rails: https://github.com/fsek/web/commit/064d56d92c8c157bd262a49fddfaa4fb7fecc28f
.. _app: https://github.com/fsek/app/commit/e04a28f7ccca076002122d6c9f2f9d68dc3c3f6e

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

4. Here, the admin path to the products will become ``/admin/store_products``. The ``except`` statement can be used if some methods are not implemented in the ``controller``, which in this case is the ``show`` action.

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
            attributes(:id, :name, :price, :in_stock, :image_url)
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

10. Here, the API path will become ``/api/store_products``. With ``only`` we specify that the only method we have implemented in the ``API controller`` is ``index``.

    .. code-block:: ruby

        # web/app/config/routes.rb
        resources :store_products, only: :index

App
---

1. We create the files ``app/www/store.html``, ``app/www/scss/partials/_store.scss`` and ``app/www/js/store.js``. The JS and SCSS files are loaded by adding the respective lines.

    .. code-block:: html

        <!-- app/www/index.html -->
        <script type="text/javascript" src="js/store.js"></script>

    .. code-block:: scss

        // app/www/scss/index.scss
        @import 'partials/store';

2. The route is added by specifing a ``name`` and ``path`` to the new page, as well as an ``url`` to the HTML file it should render.

    .. code-block:: js

        // app/www/js/index.js
        var alternativesView = app.views.create('#view-alternatives', {
          routesAdd: [
            // {
                // ... Other routes
            // },
            {
              name: 'store',
              path: '/store/',
              url: './store.html',
            },
            // {
                // ... Even more routes
            // }
          ]
        });

3. Here it is important that the ``data-name`` is the ``name`` we defined in the routes, i.e. ``store``.

    .. code-block:: html

        <!-- app/www/store.html -->
        <div data-name="store" class="page no-toolbar">
          <div class="navbar">
            <div class="navbar-inner sliding">
              <div class="left">
                <a href="#" class="back link">
                  <i class="icon icon-back"></i>
                  <span class="ios-only">Tillbaka</span>
                </a>
              </div>
              <div class="title">F-shoppen</div>
            </div>
          </div>
          <div class="page-content store-content">
            <div class="infinite-scroll-preloader">
              <div class="preloader"></div>
            </div>
          </div>
        </div>

4. Here the navigation is added to the top of the alternatives view list.

    .. code-block:: html

        <!-- app/www/index-html -->
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
                    <a href="/store/" class="item-link">
                      <div class="item-content">
                        <div class="item-inner">
                          <div class="item-title">F-shoppen</div>
                        </div>
                      </div>
                    </a>
                  </li>
                  <!--
                    ... Another list item
                  //-->
                </ul>
              </div>
            </div>
          </div>
        </div>

5. We can catch the ``page::init`` event when it's called on the page where ``data-name="store"`` by doing the following:

    .. code-block:: js

        // app/www/js/store.js
        $$(document).on('page:init', '.page[data-name="store"]', function () {
          console.log('Spodermon iz kewl');
        });

6. Our JS file can now look like:

    .. code-block:: js

        // app/www/js/store.js
        $$(document).on('page:init', '.page[data-name="store"]', function () {
          let storeProductAPIEndpointURL = API + '/store_products';

          $.getJSON(storeProductAPIEndpointURL)
            .done(function(resp) {
              initStore(resp);
            })
            .fail(function(resp) {
              console.log(resp.statusText);
            });

          function initStore(resp) {
            console.log(resp);
          }
        });

   Here we have used the global variable ``API`` to define our URL. The value of ``API`` is defined in ``app/www/js/index.js``.

7. Here we create a simple template with the ``id`` ``storeTemplate``

    .. code-block:: html

        <!-- app/www/index.html -->
        <script type="text/template7" id="storeTemplate">
          Welcome to the F-store!
        </script>

   and can test if it works by extending our JS file to:

    .. code-block:: js

        // app/www/js/store.js
        $$(document).on('page:init', '.page[data-name="store"]', function () {
          let storeProductAPIEndpointURL = API + '/store_products';

          $.getJSON(storeProductAPIEndpointURL)
            .done(function(resp) {
              initStore(resp);
            })
            .fail(function(resp) {
              console.log(resp.statusText);
            });

          function initStore(resp) {
            let templateHTML = app.templates.storeTemplate();
            let storeContainer = $('.store-content');
            storeContainer.html(templateHTML);
          }
        });

   Here we first get the HTML code of template and then put it into ``<div class="page-content store-content"></div>`` in ``app/www/store.html``.

8. An example template:

    .. code-block:: bash

        <!-- app/www/index.html -->
        <script type="text/template7" id="storeTemplate">
          {{#each products}}
            <div class="card">
              <div class="card-header" style="background-image: url({{image_url}})"></div>
              <div class="card-content card-content-padding">
                <div class="product-name">{{name}}</div>
                Pris: {{price}} kr
                <button data-id="{{id}}" class="button button-fill buy-product">Köp</button>
              </div>
            </div>
          {{/each}}
        </script>

   We can loop over the products and set the price to be in Swedish Kronor as:

    .. code-block:: js

        // app/www/js/store.js
        function initStore(resp) {
          let products = resp.store_products;
          products.forEach(function(product) {
            product.price /= 100;
            if (product.image_url === "") {
              product.image_url = "img/missing_thumb.png";
            }
          });

          let templateHTML = app.templates.storeTemplate({products: products});
          let storeContainer = $('.store-content');
          storeContainer.html(templateHTML);
        }

   Here we also set the image to be our standard missing thumbnail image if the product does not have an ``image_url``.

9. Here we catch the ``on`` ``click`` event, get the product ``id`` from the template and call the ``buyProduct`` function.

    .. code-block:: js

        // app/www/js/store.js
        function initStore(resp) {
          let products = resp.store_products;
          products.forEach(function(product) {
            product.price /= 100;
            if (product.image_url === "") {
              product.image_url = "img/missing_thumb.png";
            }
          });

          let templateHTML = app.templates.storeTemplate({products: products});
          let storeContainer = $('.store-content');
          storeContainer.html(templateHTML);

          $('.buy-product').on('click', function() {
            productId = $('.buy-product').attr('data-id');
            buyProduct(productId);
          });
        }

        function buyProduct(id) {
          $.ajax({
            url: API + '/store_orders',
            type: 'POST',
            dataType: 'json',
            data: {
              "item": {
                "id": id,
                "quantity": 1
              }
            },
            success: function(resp) {
              app.dialog.alert(resp.success, 'Varan är köpt');
            },
            error: function(resp) {
              app.dialog.alert(resp.responseJSON.error);
            }
          });
        }

10. SCSS code and the complete JS file:

    .. code-block:: bash

        // app/www/scss/partials/_store.scss
        .store-content {
          .card:nth-child(-n+2) {
            margin-top: 16px;
          }

          .card {
            width: calc(50% - 18px);
            float: left;
            box-shadow: none;
            margin-left: 8px
          }

          .card-header {
            background-size: cover;
            background-repeat: no-repeat;
            background-position: center;
            background-color: #f8f8f8;
            height: 37vh;
          }

          .card-content {
            text-align: center;
          }

          .product-name {
            font-size: 19px;
            font-weight: bold;
          }

          .buy-product {
            background-color: $fsek-orange;
            margin-top: 10px;
          }
        }

    .. code-block:: js

        // app/www/js/store.js
        $$(document).on('page:init', '.page[data-name="store"]', function () {
          let storeProductAPIEndpointURL = API + '/store_products';

          $.getJSON(storeProductAPIEndpointURL)
            .done(function(resp) {
              initStore(resp);
            })
            .fail(function(resp) {
              console.log(resp.statusText);
            });

          function initStore(resp) {
            let products = resp.store_products;
            products.forEach(function(product) {
              product.price /= 100;
              if (product.image_url === "") {
                product.image_url = "img/missing_thumb.png";
              }
            });

            let templateHTML = app.templates.storeTemplate({products: products});
            let storeContainer = $('.store-content');
            storeContainer.html(templateHTML);

            $('.buy-product').on('click', function() {
              productId = $('.buy-product').attr('data-id');
              buyProduct(productId);
            });
          }

          function buyProduct(id) {
            $.ajax({
              url: API + '/store_orders',
              type: 'POST',
              dataType: 'json',
              data: {
                "item": {
                  "id": id,
                  "quantity": 1
                }
              },
              success: function(resp) {
                app.dialog.alert(resp.success, 'Varan är köpt');
              },
              error: function(resp) {
                app.dialog.alert(resp.responseJSON.error);
              }
            });
          }
        });
