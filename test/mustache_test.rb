require 'test/unit'

require 'active_support/dependencies'
require 'action_view'
require 'action_view/mustache'
require 'action_view/template/handlers/mustache'
require 'action_view/helpers/mustache_helper'

class MustacheTest < Test::Unit::TestCase
  TEMPLATES_PATH = File.expand_path("../fixtures/templates", __FILE__)
  VIEWS_PATH     = File.expand_path("../fixtures/views", __FILE__)

  def setup
    @view = ActionView::Base.new
    @view.view_paths << TEMPLATES_PATH
    unless ActiveSupport::Dependencies.autoload_paths.include?(VIEWS_PATH)
      ActiveSupport::Dependencies.autoload_paths << VIEWS_PATH
    end
    assert_equal nil, @view.mustache_view_namespace
  end
end
