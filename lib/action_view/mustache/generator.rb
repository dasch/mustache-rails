require 'action_view'
require 'mustache'

module ActionView
  class Mustache < ::Mustache
    class Generator
      def compile(exp)
        src = ""
        src << "@output_buffer = output_buffer || ActionView::OutputBuffer.new;\n"
        src << compile!(exp)
        src << "@output_buffer.to_s;"
        src
      end

      def compile!(exp)
        case exp.first
        when :multi
          exp[1..-1].map { |e| compile!(e) }.join
        when :static
          str(exp[1])
        when :mustache
          send("on_#{exp[1]}", *exp[2..-1])
        else
          raise "Unhandled exp: #{exp.first}"
        end
      end

      def on_section(name, content, raw, delims)
        code = compile!(content)

        <<-RUBY
        if v = #{compile!(name)}
          if v == true
            #{code}
          elsif v.is_a?(Proc)
            @output_buffer.concat(v.call {
              capture {
                #{code}
              }
            }.to_s)
          else
            v = [v] unless v.is_a?(Array) || defined?(Enumerator) && v.is_a?(Enumerator)
            v.each { |h|
              ctx.push(h);
              #{code}
              ctx.pop;
            }
          end
        end
        RUBY
      end

      def on_inverted_section(name, content, raw, _)
        code = compile!(content)

        <<-RUBY
        v = #{compile!(name)}
        if v.nil? || v == false || v.respond_to?(:empty?) && v.empty?
          #{code}
        end
        RUBY
      end

      def on_partial(name, indentation)
        "@output_buffer.concat(render(:partial => #{name.inspect}));\n"
      end

      def on_utag(name)
        <<-RUBY
        v = #{compile!(name)};
        if v.is_a?(Proc)
          v = v.call.to_s
        end
        @output_buffer.safe_concat(v.to_s);
        RUBY
      end

      def on_etag(name)
        <<-RUBY
        v = #{compile!(name)};
        if v.is_a?(Proc)
          v = v.call.to_s
        end
        @output_buffer.concat(v.to_s);
        RUBY
      end

      def on_fetch(names)
        names = names.map { |n| n.to_sym }

        if names.length == 0
          "ctx[:to_s]"
        elsif names.length == 1
          "ctx[#{names.first.to_sym.inspect}]"
        else
          initial, *rest = names
          <<-RUBY
            #{rest.inspect}.inject(ctx[#{initial.inspect}]) { |value, key|
              value && ctx.find(value, key)
            }
          RUBY
        end
      end

      def str(s)
        "@output_buffer.safe_concat(#{s.inspect});\n"
      end
    end
  end
end
