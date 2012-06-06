require 'mustache'
require 'rails/railtie'

class Mustache
  # Railtie initializer for Rails 3.x and higher.
  #
  # Either add a require to the top of your `config/application.rb`
  #
  #     require "mustache/rails"
  #
  # Or setup an auto-require in your Gemfile
  #
  #     gem "mustache-rails", :require => "mustache/railtie"
  #
  class Railtie < Rails::Railtie
    # Public: Application configuration object.
    #
    # Defaults can be modified in your `config/application.rb`.
    config.mustache = ActiveSupport::OrderedOptions.new

    # Public: Relative path to .mustache template files.
    #
    # Defaults to "app/templates". Its highly recommended to keep the
    # default value.
    #
    # Returns String.
    config.mustache.template_path = "app/templates"

    # Public: Relative path to mustache view classes.
    #
    # Defaults to "app/views". Its highly recommended to keep the
    # default value.
    #
    # Returns String.
    config.mustache.view_path = "app/views"

    # Public: Namespace to look for mustache view classes under.
    #
    # Defaults to "::Views". You may want to drop this namespace by
    # setting the value to "".
    #
    # The value may also be set to a Class, but a String is
    # recommended for lazily loading.
    #
    # Returns String or Class.
    config.mustache.view_namespace = "::Views"

    # Internal: Ensures view path is encluded in autoload path.
    initializer 'mustache.add_autoload_paths', :before => :set_autoload_paths do |app|
      app.config.autoload_paths << app.root.join(app.config.mustache.view_path).to_s
    end

    # Internal: Adds .mustache template path to ActionController's view paths.
    initializer 'mustache.add_view_paths', :after => :add_view_paths do |app|
      ActiveSupport.on_load(:action_controller) do
        append_view_path app.root.join(app.config.mustache.template_path).to_s
      end
    end

    # Internal: Assigns configured view namespace to ActionView context.
    initializer 'mustache.set_view_namespace' do |app|
      ActiveSupport.on_load(:action_view) do
        require 'action_view/mustache'
        require 'action_view/template/handlers/mustache'
        require 'action_view/helpers/mustache_helper'
        ActionView::Base.mustache_view_namespace = app.config.mustache.view_namespace
      end
    end
  end
end
