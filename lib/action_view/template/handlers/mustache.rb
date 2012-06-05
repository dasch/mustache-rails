require 'action_view'
require 'action_view/template'
require 'action_view/template/handlers'
require 'action_view/mustache/generator'
require 'mustache'

module ActionView
  class Template
    module Handlers
      class Mustache
        def self.call(template)
          tokens = ::Mustache::Parser.new.compile(template.source)
          src    = ActionView::Mustache::Generator.new.compile(tokens)

          <<-RUBY
            ctx = mustache_view.context
            ctx.push local_assigns
            #{src}
          RUBY
        end
      end
    end

    register_template_handler :mustache, Handlers::Mustache
  end
end
