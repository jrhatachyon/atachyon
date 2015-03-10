###Atachyon Rails Project

This is the source code to the site operating at
[https://atachyon.com](https://atachyon.com).  It is a Rails 4 codebase and uses a
SQL backend for the database and Sphinx for the search engine.
The code is forked from [Lobsters](https://github.com/jcs/lobsters).

You are free to fork this code and modify it (according to the [license]
(https://github.com/jrhatachyon/atachyon/blob/master/LICENSE))
to run your own link aggregation website.

####Contributing bugfixes and new features

Please see the [CONTRIBUTING]
(https://github.com/jrhatachyon/atachyon/blob/master/CONTRIBUTING.md)
file.

####Initial setup

* Install Ruby. Supported Ruby versions include 1.9.3, 2.0.0 and 2.1.0.

* Checkout the atachyon git tree from Github

         $ git clone git://github.com/jrhatachyon/atachyon.git
         $ cd atachyon
         atachyon$ 

* Run Bundler to install/bundle gems needed by the project:

         atachyon$ bundle

* Create a MySQL (other DBs supported by ActiveRecord may work, only MySQL and
MariaDB have been tested) database, username, and password and put them in a
`config/database.yml` file:

          development:
            adapter: mysql2
            encoding: utf8mb4
            reconnect: false
            database: atachyon_dev
            socket: /tmp/mysql.sock
            username: *username*
            password: *password*
            
          test:
            adapter: sqlite3
            database: db/test.sqlite3
            pool: 5
            timeout: 5000

* Load the schema into the new database and seed it:

          atachyon$ rake db:schema:load
	  atachyon$ rake db:seed

* Create a `config/initializers/secret_token.rb` file, using a randomly
generated key from the output of `rake secret`:

          Lobsters::Application.config.secret_key_base = 'your random secret here'

* (Optional, only needed for the search engine) Install Sphinx.  Build Sphinx
config and start server:

          atachyon$ rake ts:rebuild

* Define your site's name and default domain, which are used in various places,
in a `config/initializers/production.rb` or similar file:

          class << Rails.application
            def domain
              "example.com"
            end
          
            def name
              "Example News"
            end
          end
          
          Rails.application.routes.default_url_options[:host] = Rails.application.domain

* Create an initial administrator user and at least one tag:

          atachyon$ rails console
          Loading development environment (Rails 4.1.8)
          irb(main):001:0> User.create(:username => "test", :email => "test@example.com", :password => "test", :password_confirmation => "test", :is_admin => true, :is_moderator => true)
          irb(main):002:0> Tag.create(:tag => "test")

* Run the Rails server in development mode.  You should be able to login to
`http://localhost:3000` with your new `test` user:

          atachyon$ rails server
