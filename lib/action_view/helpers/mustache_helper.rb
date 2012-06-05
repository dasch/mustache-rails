require 'active_support/concern'
require 'action_view'
require 'action_view/base'
require 'action_view/helpers'
require 'action_view/mustache'

module ActionView
  module Helpers
    module MustacheHelper
      extend ActiveSupport::Concern

      included do
        cattr_accessor :mustache_view_namespace
      end

      def mustache_view_class
        return unless @virtual_path
        klass = "#{mustache_view_namespace}/#{@virtual_path}".camelize.constantize
        unless klass < ActionView::Mustache
          raise TypeError, "#{klass} isn't a subclass of ActionView::Mustache"
        end
        klass
      end

      def mustache_view
        @_mustache_view ||= mustache_view_class.new(self)
      end
    end
  end

  Base.send :include, Helpers::MustacheHelper
end
