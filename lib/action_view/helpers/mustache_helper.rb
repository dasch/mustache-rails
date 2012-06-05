require 'action_view'
require 'action_view/mustache'

module ActionView
  module Helpers
    module MustacheHelper
      def self.included(base)
        base.instance_eval do
          cattr_accessor :mustache_view_namespace
        end
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
end
