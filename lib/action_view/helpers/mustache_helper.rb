require 'active_support/concern'
require 'action_view'
require 'action_view/base'
require 'action_view/helpers'
require 'action_view/mustache'

module ActionView
  module Helpers
    # Public: Standard helper mixed into ActionView context for
    # constructing the Mustache View.
    module MustacheHelper
      extend ActiveSupport::Concern

      included do
        # PID: Storing our view namespace settings on a class variable
        # is kinda nasty. It'd better to avoid the global and always
        # use our application's config object.
        cattr_accessor :mustache_view_namespace
      end

      # Public: Get Mustache View Class for template.
      #
      # Choose template class by camalizing the template path name and
      # prefixing our view namespace.
      #
      # The class must be a subclass of ActionView::Mustache
      # otherwise a TypeError will be raised.
      #
      # If the template is "anonymous" and has no path, which is the
      # case for render(:inline), the default ActionView::Mustache
      # base class will be returned.
      #
      # Examples
      #
      #     "blog/show" => Blog::Show
      #
      # Returns Class or raises a TypeError.
      def mustache_view_class
        return ActionView::Mustache unless @virtual_path
        klass_name = "#{mustache_view_namespace}/#{@virtual_path}".camelize
        begin
          klass = klass.constantize
        rescue NameError => e
          load_path = ActiveSupport::Dependencies.autoload_paths.map { |p| "  #{p}\n" }.join
          raise NameError, "Couldn't find #{klass_name}:\n#{load_path}"
        end
        unless klass < ActionView::Mustache
          raise TypeError, "#{klass} isn't a subclass of ActionView::Mustache"
        end
        klass
      end

      # Public: Get or initialize Mustache View.
      #
      # The view object is cached so partial renders will reuse the
      # same instance.
      #
      # Returns a Mustache View which is a subclass of
      # ActionView::Mustache.
      def mustache_view
        @_mustache_view ||= mustache_view_class.new(self)
      end
    end
  end

  Base.send :include, Helpers::MustacheHelper
end
