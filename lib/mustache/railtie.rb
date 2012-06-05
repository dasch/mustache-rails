require 'mustache'
require 'action_view/mustache'
require 'rails/railtie'

class Mustache
  class Railtie < Rails::Railtie
    config.mustache = ActiveSupport::OrderedOptions.new

    # Defaults
    config.mustache.template_path  = "app/templates"
    config.mustache.view_path      = "app/views"
    config.mustache.view_namespace = "::Views"

    initializer 'mustache.add_autoload_paths', :before => :set_autoload_paths do |app|
      app.config.autoload_paths << app.root.join(app.config.mustache.view_path).to_s
    end

    initializer 'mustache.add_view_paths', :after => :add_view_paths do |app|
      ActiveSupport.on_load(:action_controller) do
        append_view_path app.root.join(app.config.mustache.template_path).to_s
      end
    end

    initializer 'mustache.install_helper', :after => :prepend_helpers_path do |app|
      require 'action_view/helpers/mustache_helper'
      ActionView::Base.send :include, ActionView::Helpers::MustacheHelper
      ActionView::Base.mustache_view_namespace = app.config.mustache.view_namespace
    end
  end
end

ActiveSupport.on_load(:action_view) do
  require 'action_view/template/handlers/mustache'
  ActionView::Template.register_template_handler :mustache, ActionView::Template::Handlers::Mustache
end
