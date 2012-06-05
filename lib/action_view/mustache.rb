require 'action_view'
require 'mustache'

module ActionView
  class Mustache < ::Mustache
    class Context < ::Mustache::Context
      undef_method :partial, :escapeHTML
    end

    def initialize(view)
      # Reference to original AV context.
      @_view = view

      self.template_name = view.instance_variable_get(:@virtual_path)

      if controller = view.controller
        # Copy controller ivars into our view
        controller.view_assigns.each do |name, value|
          instance_variable_set '@'+name, value
        end
      end

      # Define `yield` keyword for content_for :layout
      context[:yield] = lambda { content_for :layout }
    end

    # Use AV's render instead of Mustache
    undef_method :render

    def context
      @context ||= Context.new(self)
    end

    # Forwards methods to original Rails view context
    def method_missing(*args, &block)
      @_view.send(*args, &block)
    end

    # Checks if method exists in Rails view context
    def respond_to?(method, include_private = false)
      super || @_view.respond_to?(method, include_private)
    end
  end
end
