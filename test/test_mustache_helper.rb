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

  def test_missing_view_class
    assert_raise ActionView::Template::Error do
      @view.render(:template => "wrong_parent")
    end
  end
end
