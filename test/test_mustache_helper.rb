require 'mustache_test'

class TestMustacheHelper < MustacheTest
  def test_mustache_view_class
    assert_equal "Inspect", @view.render(:template => "inspect")
  end

  def test_namesapced_mustache_view_class
    @view.mustache_view_namespace = "::Test"
    assert_equal "Test::Inspect", @view.render(:template => "inspect")
  ensure
    @view.mustache_view_namespace = nil
  end

  def test_missing_view_class
    assert_raise ActionView::Template::Error do
      @view.render(:template => "missing_view")
    end
  end

  def test_wrong_parent_class_view_class
    assert_raise ActionView::Template::Error do
      @view.render(:template => "wrong_parent")
    end
  end

  def test_inline_template_uses_default_context
    assert_equal "view: ActionView::Mustache", @view.render({
      :inline => "view: {{mustache_view_class}}",
      :type => :mustache
    })
  end
end
